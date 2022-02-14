import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:deriv_p2p_practice_project/connection/deriv_connection_bloc.dart';

class ConnectionService {
  static final ConnectionService _instance = ConnectionService._internal();
  static const int _pingTimeout = 5;

  bool _hasConnection = true;

  StreamController connectionChangeController =
      StreamController<bool>.broadcast();

  final Connectivity _connectivity = Connectivity();

  factory ConnectionService() => _instance;

  ConnectionService._internal();

  Stream<bool> get state => connectionChangeController.stream as Stream<bool>;

  bool get isConnectedToInternet => _hasConnection;

  final int _connectivityCheckInterval = 5;

  late DerivConnectionBloc _connectionBloc;
  Timer? _connectivityTimer;

  // Todo(farzin): On Android, when the application is in the background and the
  // phone is locked for a while the result of the `Connectivity` will be `none`
  // even if the device is connected to Wi-Fi or MobileData.
  // We need to find a way to fix this.
  Future<bool> _checkConnection(ConnectivityResult result) async {
    final bool previousConnection = _hasConnection;
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        if (_connectionBloc.state is! Connected) {
          await _connectionBloc.connectToWebSocket();
        }

        _hasConnection = await _ping();
        break;
      case ConnectivityResult.none:
        _hasConnection = false;
        break;
      default:
        _hasConnection = false;
        break;
    }

    if (previousConnection != _hasConnection) {
      connectionChangeController.add(_hasConnection);
    }

    return _hasConnection;
  }

  void dispose() {
    connectionChangeController.close();
    _connectivityTimer?.cancel();
  }

  Future<void> initialize(
    DerivConnectionBloc connectionBloc,
  ) async {
    _connectionBloc = connectionBloc;
    await _connectivity.checkConnectivity();
    _connectivity.onConnectivityChanged.listen(_checkConnection);

    _startConnectivityTimer();
  }

  Future<bool> checkConnectivity() async {
    final ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    return _checkConnection(connectivityResult);
  }

  // Checks for change to connectivity to internet every [_connectivityCheckInterval] seconds
  void _startConnectivityTimer() {
    if (_connectivityTimer == null || !_connectivityTimer!.isActive) {
      _connectivityTimer = Timer.periodic(
          Duration(seconds: _connectivityCheckInterval), (Timer timer) async {
        await checkConnectivity();
      });
    }
  }

  Future<bool> _ping() async {
    try {
      final Map<String, dynamic> response = await _connectionBloc.binaryApi
          .ping()
          .timeout(const Duration(seconds: _pingTimeout));

      if (response['ping'] != 'pong') {
        return false;
      }
    } on Exception catch (_) {
      // To ensure not returning 'no connection' when connection is back and ping
      // has just being called.
      if (!_hasConnection) {
        return false;
      }
    }

    return true;
  }
}
