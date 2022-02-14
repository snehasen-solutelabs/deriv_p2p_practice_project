// Todo(farzin): Should follow same naming convention as other blocs.
// Todo(farzin): Use equatable.

part of 'deriv_connection_cubit.dart';

@immutable
abstract class DerivConnectionEvent {}

class Connect extends DerivConnectionEvent {
  final BinaryAPIWrapper api;

  Connect({required this.api});

  @override
  String toString() => 'DerivConnectionEvent(Connect)';
}

class Reconfigure extends DerivConnectionEvent {
  @override
  String toString() => 'DerivConnectionEvent(Reconfigure)';
}

/// This state represents that we are trying to reconnect to the WebSocket
class Reconnect extends DerivConnectionEvent {
  /// Will emit `Reconnect` state with given parameters.
  Reconnect({
  
    this.isInternetLost = false,
  });

  

  /// If true, That means the connection was closed because the device is not
  /// connected to a Wi-Fi or MobileData.
  final bool isInternetLost;

  @override
  String toString() => 'DerivConnectionEvent(Reconnect('
      ' isInternetLost: $isInternetLost'
      '))';
}

class Reset extends DerivConnectionEvent {
  @override
  String toString() => 'DerivConnectionEvent(Reset)';
}

class FetchServerTime extends DerivConnectionEvent {
  @override
  String toString() => 'DerivConnectionEvent(FetchServerTime)';
}

/// This event is used for when user account is disabled.
class ConnectionDisableAccountEvent extends DerivConnectionEvent {
  /// Constructs a new ConnectionDisableAccountEvent with the given error.
  ConnectionDisableAccountEvent({
    required this.error,
  });

  /// The error object returned from the server.
  final APIError error;

  @override
  String toString() =>
      'DerivConnectionEvent(ConnectionDisableAccountEvent($error))';
}

// Todo(farzin): `ConnectionDisableAccountEvent` and `ConnectionAPIErrorEvent`
// can be merged together for simplicity.
/// This event will simulate connection disconnect state when there is an
/// API error.
class ConnectionAPIErrorEvent extends DerivConnectionEvent {
  /// Constructs a new ConnectionAPIErrorEvent with the given error.
  ConnectionAPIErrorEvent({
    required this.error,
  });

  /// The error object returned from the server.
  final APIError error;

  @override
  String toString() => 'DerivConnectionEvent(ConnectionAPIErrorEvent($error))';
}

/// This event will reconnect the connection bloc.
class ConnectionReconnectEvent extends DerivConnectionEvent {
  @override
  String toString() => 'DerivConnectionEvent(ConnectionReconnectEvent)';
}
