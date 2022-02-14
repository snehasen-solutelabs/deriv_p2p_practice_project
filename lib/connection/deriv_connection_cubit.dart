import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:deriv_p2p_practice_project/api/api_error.dart';
import 'package:deriv_p2p_practice_project/connection/binary_api_wrapper.dart';
import 'package:deriv_p2p_practice_project/internet_connection/connection_service.dart';
import 'package:flutter/material.dart';

import 'package:deriv_p2p_practice_project/internet_connection/internet_bloc.dart'
    as internet_bloc;
import 'package:rxdart/src/transformers/start_with.dart';
part 'deriv_connection_event.dart';

part 'deriv_connection_state.dart';

/// Deriv connection bloc that handles the logic of connecting to WebSocket and
/// listen to state changes in Internet bloc.
class DerivConnectionCubit extends Cubit<DerivConnectionState> {
  /// Initializes the bloc and will try to connect to the WebSocket and listens
  /// to the Internet bloc state changes.
  DerivConnectionCubit() : super(InitialDerivConnectionState()) {
    _initialize();
  }






  // Todo(farzin): It seems that this key is always the same so we can get rid
  // of it, It's better to make `BinaryAPI` a singleton instead of handling it
  // this way.
  // A unique key to identified that the `onDone` function that is called by the
  // WebSocket connection is from a same instance.
  final UniqueKey _uniqueKey = UniqueKey();
  final Future<void> _delay = Future<void>.delayed(const Duration(seconds: 5));
  final internet_bloc.InternetCubit _internetBloc =
      internet_bloc.InternetCubit();
  late BinaryAPIWrapper _api;
  late final StreamSubscription<internet_bloc.InternetState>
      _internetBlocSubscription;

  // Todo(farzin): It can be removed once the ping method in the
  // ConnectionService is re-implemented in the right way.
  /// Exposes binary API, it is mainly used in the ping method at
  /// ConnectionService.
  BinaryAPIWrapper get binaryApi => _api;

  void _initialize() {
    _api = BinaryAPIWrapper(
      uniqueKey: _uniqueKey,
      
    );

    connectToWebSocket();

    _internetBlocSubscription = _internetBloc.stream
        .startWith(_internetBloc.state)
        .listen((internet_bloc.InternetState state) {
      if (state is internet_bloc.Disconnected) {
        Reset();
      } else if (state is internet_bloc.Connected) {
        Reconnect();
      }
    });
  }

  // Todo(farzin): It is possible to set it private once the ConnectionService
  // is refactored.
  /// Connects to WebSocket.
  Future<void> connectToWebSocket() async {
    await _api.close();
    await _api.run(
      onDone: (UniqueKey? uniqueKey) {
        // Try to reconnect to the WebSocket when the connection gets closed.
        if (_uniqueKey == uniqueKey) {
          ConnectionService().checkConnectivity();
          Reconnect(
            isInternetLost: !ConnectionService().isConnectedToInternet,
          );
        }
      },
      onOpen: (UniqueKey? uniqueKey) {
        if (_uniqueKey == uniqueKey) {
          Connect(api: _api);
        }
      },
      onError: (UniqueKey? uniqueKey) {
        // Try to reconnect to the WebSocket when the connection gets closed.
        ConnectionService().checkConnectivity();
        Reconnect(
          isInternetLost: !ConnectionService().isConnectedToInternet,
        );
      },
    );
  }

  @override
  Stream<DerivConnectionState> mapEventToState(
    DerivConnectionEvent event,
  ) async* {
    if (event is Connect) {
      yield* _handleConnect(event);
    } else if (event is Reconnect) {
      yield* _handleReconnect(event);
    } else if (event is Reconfigure) {
      yield* _handleReconfigure();
    } else if (event is ConnectionDisableAccountEvent) {
      yield* _handleConnectionDisableAccountEvent(event);
    } else if (event is Reset) {
      yield* _handleReset();
    } else if (event is ConnectionAPIErrorEvent) {
      yield* _handleConnectionAPIErrorEvent(event);
    } else if (event is ConnectionReconnectEvent) {
      yield* _handleConnectionReconnectEvent();
    }
  }

  // Todo(farzin): Maybe that's not a good idea to emit the `api` inside the
  // Connected state, We should use the `BinaryAPI` directly and let it care
  // about the connection state itself and handle the requests.
  Stream<DerivConnectionState> _handleConnect(Connect event) async* {
    final DerivConnectionState currentState = state;

    if (currentState is Disconnected && currentState.shouldShowErrorPage) {
      return;
    } else if (currentState is! Connected) {
      // Todo(farzin): Investigate using `equatable` helps to avoid emitting the
      // same state again.
      yield Connected(event.api);
    }
  }

  // Todo(farzin): `Reset` makes more sense here instead of `Reconfigure`.
  Stream<DerivConnectionState> _handleReconfigure() async* {
    await _api.close();
    // Resets state after changing the endpoint from the settings page.
    yield InitialDerivConnectionState();
  }

  Stream<DerivConnectionState> _handleReconnect(Reconnect event) async* {
    await _api.close();
    // Todo(farzin): The`isConnectedToInternet` uses the WebSocket itself to
    // ping which is closed so it will be false, Need to change the logic inside
    // the ConnectionService and update the code here.
    if (ConnectionService().isConnectedToInternet) {
      if (state is! Reconnecting) {
        yield Reconnecting(
       
          isInternetLost: event.isInternetLost,
        );
        await _delay;
        await connectToWebSocket();
      }
    } else {
      if (state is! Disconnected) {
        yield Disconnected(
      
          isInternetLost: event.isInternetLost,
        );
      }
    }
  }

  // Todo(farzin): This should be done in the AccountBloc, And AccountBloc
  // should reconnect the WebSocket when it finishes cleaning up users data.
  Stream<DerivConnectionState> _handleConnectionDisableAccountEvent(
    ConnectionDisableAccountEvent event,
  ) async* {
    await _api.close();
    yield ConnectionForcedLogoutState(error: event.error);
    await _delay;
    await connectToWebSocket();
  }

  // Todo(farzin): Seems like this will disconnect the connection instead of
  // resetting, Should investigate and if true change the name of the event.
  Stream<DerivConnectionState> _handleReset() async* {
    await _api.close();

    if (state is! Disconnected) {
      yield Disconnected(
        isInternetLost: !ConnectionService().isConnectedToInternet,
      );
    }
  }

  // Todo(farzin): Would be better to be part of the WebsiteStatusBloc maybe,
  // Connection should not care about anything other than the network itself.
  Stream<DerivConnectionState> _handleConnectionAPIErrorEvent(
    ConnectionAPIErrorEvent event,
  ) async* {
    yield Disconnected(error: event.error);
  }

  // Todo(farzin): Would be better to be part of the WebsiteStatusBloc maybe,
  // Connection should not care about anything other than the network itself.
  Stream<DerivConnectionState> _handleConnectionReconnectEvent() async* {
    Reconnect();
  }

  @override
  Future<void> close() async {
    await _internetBlocSubscription.cancel();
    return super.close();
  }
}
