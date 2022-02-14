import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity? connectivity;
  // ignore: cancel_subscriptions
  StreamSubscription? internetConnectionTypeStreamSubscription;

  InternetCubit({required this.connectivity})
      : super(InternetConnectionTypeLoading()) {
    monitorConnectionType();
  }

  void monitorConnectionType() async {
    internetConnectionTypeStreamSubscription =
        connectivity!.onConnectivityChanged.listen((connectivityResult) async {
      if (connectivityResult == ConnectivityResult.wifi) {
        emitConnectionType(ConnectionType.wifi);
      } else if (connectivityResult == ConnectivityResult.mobile) {
        emitConnectionType(ConnectionType.mobile);
      }
    });
  }

  void emitConnectionType(ConnectionType _connectionType) =>
      emit(InternetConnectionType(connectionType: _connectionType));

  @override
  Future<void> close() async {
    internetConnectionTypeStreamSubscription!.cancel();
    return super.close();
  }
}
