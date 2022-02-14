import 'dart:async';
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:deriv_p2p_practice_project/internet_connection/connection_service.dart';

part 'internet_event.dart';

part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  StreamSubscription<bool>? _connectivityListener;

  InternetBloc() : super(InitialState()) {
    _connectivityListener = ConnectionService().state.listen(
      (state) {
        if (state) {
          if (this.state is! Connected) add(Online());
        } else {
          if (this.state is! Disconnected) add(Offline());
        }
      },
    );
  }

  @override
  Stream<InternetState> mapEventToState(InternetEvent event) async* {
    dev.log(event.toString());
    if (event is Offline) {
      yield Disconnected();
    } else if (event is SocketDisconnected) {
      yield Disconnected(isWebSocketClosed: true);
    } else if (event is Online || event is SocketConnected) {
      yield Connected();
    }
  }

  @override
  Future<void> close() async {
    await _connectivityListener?.cancel();
    return super.close();
  }
}
