part of 'splash_screen_cubit.dart';

enum DerivConnectionStateEnum {
  Initial,
  CheckingToken,
  TokenValid,
  TokenInvalid,
  Error,
  Reconnect,
}

abstract class DerivConnectionState {
  final DerivConnectionStateEnum connectionScreenStateEnum;

  const DerivConnectionState(this.connectionScreenStateEnum);
}

class DerivConnectionStateInitial extends DerivConnectionState {
  const DerivConnectionStateInitial() : super(DerivConnectionStateEnum.Initial);
}

class DerivConnectionStateReconnect extends DerivConnectionState {
  const DerivConnectionStateReconnect()
      : super(DerivConnectionStateEnum.Reconnect);
}

class DerivConnectionStateCheckingToken extends DerivConnectionState {
  const DerivConnectionStateCheckingToken()
      : super(DerivConnectionStateEnum.CheckingToken);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DerivConnectionStateCheckingToken &&
        o.connectionScreenStateEnum == DerivConnectionStateEnum;
  }

  @override
  int get hashCode => connectionScreenStateEnum.hashCode;
}

class DerivConnectionStateTokenValid extends DerivConnectionState {
  const DerivConnectionStateTokenValid()
      : super(DerivConnectionStateEnum.TokenValid);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DerivConnectionStateTokenValid &&
        o.connectionScreenStateEnum == connectionScreenStateEnum;
  }

  @override
  int get hashCode => connectionScreenStateEnum.hashCode;
}

class DerivConnectionTokenInvalid extends DerivConnectionState {
  const DerivConnectionTokenInvalid()
      : super(DerivConnectionStateEnum.TokenInvalid);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DerivConnectionTokenInvalid &&
        o.connectionScreenStateEnum == connectionScreenStateEnum;
  }

  @override
  int get hashCode => connectionScreenStateEnum.hashCode;
}

class DerivConnectionError extends DerivConnectionState {
  const DerivConnectionError() : super(DerivConnectionStateEnum.Error);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DerivConnectionError &&
        o.connectionScreenStateEnum == connectionScreenStateEnum;
  }

  @override
  int get hashCode => connectionScreenStateEnum.hashCode;
}








// // Todo(farzin): Should follow same naming convention as other blocs.
// // Todo(farzin): Use equatable.

// part of 'deriv_connection_cubit.dart';

// @immutable
// abstract class DerivConnectionState {}

// class InitialDerivConnectionState extends DerivConnectionState {
//   @override
//   String toString() => 'DerivConnectionState(InitialDerivConnectionState)';
// }

// class Connecting extends DerivConnectionState {
//   final BinaryAPIWrapper api;

//   Connecting(this.api);

//   @override
//   String toString() => 'DerivConnectionState(Connecting)';
// }

// class Connected extends DerivConnectionState {
//   final BinaryAPIWrapper api;

//   Connected(this.api);

//   @override
//   String toString() => 'DerivConnectionState(Connected)';
// }

// /// This state represents that the WebSocket is disconnect.
// class Disconnected extends DerivConnectionState {
//   /// Will emit `Disconnected` state with given parameters.
//   Disconnected({
   
//     this.isInternetLost = false,
//     this.error,
//   });

//   /// If true, Than means the connection was closed because user has changed the
 

//   /// If true, That means the connection was closed because the device is not
//   /// connected to a Wi-Fi or MobileData.
//   final bool isInternetLost;

//   /// The error object returned from the server.
//   final APIError? error;

//   /// Returns true if we need to show an error page.
//   bool get shouldShowErrorPage =>
//       error != null &&
//       (error!.isP2PDisabled || error!.isUserUnwelcome || error!.isUserDisabled);

//   @override
//   String toString() => 'DerivConnectionState(Disconnected('
      
//       'isInternetLost: $isInternetLost'
//       'error: $error'
//       '))';
// }

// /// This state represents that the WebSocket is trying to reconnect.
// class Reconnecting extends DerivConnectionState {
//   /// Will emit `Reconnecting` state with given parameters.
//   Reconnecting({
  
//     this.isInternetLost = false,
//   });

//   /// If true, Than means the connection was closed because user has changed the
//   /// app language.


//   /// If true, That means the connection was closed because the device is not
//   /// connected to a Wi-Fi or MobileData.
//   final bool isInternetLost;

//   @override
//   String toString() => 'DerivConnectionState(Reconnecting('
//       'isInternetLost: $isInternetLost'
//       '))';
// }

// /// This even is used to perform a force logout.
// class ConnectionForcedLogoutState extends DerivConnectionState {
//   /// Constructs a new ConnectionForcedLogoutState with the given error.
//   ConnectionForcedLogoutState({
//     required this.error,
//   });

//   /// The error object returned from the server.
//   final APIError error;

//   @override
//   String toString() =>
//       'DerivConnectionState(ConnectionForcedLogoutState($error))';
// }
