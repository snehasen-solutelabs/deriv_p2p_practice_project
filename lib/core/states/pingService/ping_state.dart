import 'package:deriv_p2p_practice_project/api/binary_api_wrapper.dart';

/// Base state for web ping connect
abstract class PingState {}

/// web ping connect initial state
class PingInitialState extends PingState {}

/// web ping connect loading state
class PingLoadingState extends PingState {}

/// web ping connect loaded state
class PingLoadedState extends PingState {
  /// init state
  PingLoadedState({required this.api});

  /// BinaryAPIWrapper instance
  BinaryAPIWrapper api;
}

/// web ping connect error state
class PingErrorState extends PingState {
  /// Initializes
  PingErrorState(this.errorMessage);

  /// Error message
  final String errorMessage;
}
