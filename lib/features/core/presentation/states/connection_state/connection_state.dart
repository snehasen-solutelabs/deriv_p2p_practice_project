import 'package:deriv_p2p_practice_project/api/binary_api_wrapper.dart';
import 'package:flutter_deriv_api/api/common/active_symbols/active_symbols.dart';

///Selected Symbol base State
abstract class ConnectionState {}

/// Selected Symbol initial state
class ConnectionStateInitialState extends ConnectionState {}

/// Selected Symbol change state
class ConnectionStateStable extends ConnectionState {
  /// Initialises Selected Symbol change state
  ConnectionStateStable({required this.api});

  /// Selected Symbol details.
  final BinaryAPIWrapper api;
}
