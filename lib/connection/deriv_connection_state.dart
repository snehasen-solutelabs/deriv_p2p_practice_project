// Todo(farzin): Should follow same naming convention as other blocs.
// Todo(farzin): Use equatable.

part of 'deriv_connection_cubit.dart';

@immutable
abstract class DerivConnectionState {}

class InitialDerivConnectionState extends DerivConnectionState {
  @override
  String toString() => 'DerivConnectionState(InitialDerivConnectionState)';
}

class Connecting extends DerivConnectionState {
  final BinaryAPIWrapper api;

  Connecting(this.api);

  @override
  String toString() => 'DerivConnectionState(Connecting)';
}

class Connected extends DerivConnectionState {
  final BinaryAPIWrapper api;

  Connected(this.api);

  @override
  String toString() => 'DerivConnectionState(Connected)';
}

/// This state represents that the WebSocket is disconnect.
class Disconnected extends DerivConnectionState {
  /// Will emit `Disconnected` state with given parameters.
  Disconnected({
   
    this.isInternetLost = false,
    this.error,
  });

  /// If true, Than means the connection was closed because user has changed the
 

  /// If true, That means the connection was closed because the device is not
  /// connected to a Wi-Fi or MobileData.
  final bool isInternetLost;

  /// The error object returned from the server.
  final APIError? error;

  /// Returns true if we need to show an error page.
  bool get shouldShowErrorPage =>
      error != null &&
      (error!.isP2PDisabled || error!.isUserUnwelcome || error!.isUserDisabled);

  @override
  String toString() => 'DerivConnectionState(Disconnected('
      
      'isInternetLost: $isInternetLost'
      'error: $error'
      '))';
}

/// This state represents that the WebSocket is trying to reconnect.
class Reconnecting extends DerivConnectionState {
  /// Will emit `Reconnecting` state with given parameters.
  Reconnecting({
  
    this.isInternetLost = false,
  });

  /// If true, Than means the connection was closed because user has changed the
  /// app language.


  /// If true, That means the connection was closed because the device is not
  /// connected to a Wi-Fi or MobileData.
  final bool isInternetLost;

  @override
  String toString() => 'DerivConnectionState(Reconnecting('
      'isInternetLost: $isInternetLost'
      '))';
}

/// This even is used to perform a force logout.
class ConnectionForcedLogoutState extends DerivConnectionState {
  /// Constructs a new ConnectionForcedLogoutState with the given error.
  ConnectionForcedLogoutState({
    required this.error,
  });

  /// The error object returned from the server.
  final APIError error;

  @override
  String toString() =>
      'DerivConnectionState(ConnectionForcedLogoutState($error))';
}
