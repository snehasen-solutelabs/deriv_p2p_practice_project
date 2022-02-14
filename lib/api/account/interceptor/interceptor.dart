// Todo(farzin): This module needs refactoring.
// - It should be part of BinaryAPI, Not account.
// - Anyone should be able to define interceptor, currently BinaryAPI supports
// just one.
// - Interceptors should be able to transform the outgoing request and incoming
// response.

import 'dart:convert';
import 'dart:developer' as dev;

import 'package:deriv_p2p_practice_project/api/account/interceptor/base_interceptor.dart';
import 'package:deriv_p2p_practice_project/api/api_error.dart';
import 'package:deriv_p2p_practice_project/connection/deriv_connection_bloc.dart';

/// This class will intercept all web socket communications and raise the
/// relevant callback.
class Interceptor extends BaseInterceptor {
  /// Constructs a new Interceptor with the given parameter.
  Interceptor(
    this._connectionBloc,
  );

  final DerivConnectionBloc _connectionBloc;

  @override
  bool handleResponse(Map<String, dynamic> response) {
    if (response['error'] != null) {
      return onError(APIError.fromMap(response['error']));
    } else {
      return onSuccess(response);
    }
  }

  @override
  void onRequest(Map<String, dynamic> req) {
    dev.log('Queuing outgoing request: ${jsonEncode(req)}');
  }

  @override
  bool onError(APIError error) {
    // Todo(farzin): These two if statements can be merged into one condition
    // after refactoring DerivConnectionBloc and removing
    // ConnectionDisableAccountEvent and ConnectionForcedLogoutState.
    if (error.isP2PDisabled || error.isUserUnwelcome || error.isUserDisabled) {
      _connectionBloc.add(ConnectionAPIErrorEvent(error: error));
      return false;
    } else if (error.isUserAccessDenied) {
      _connectionBloc.add(ConnectionDisableAccountEvent(error: error));
      return false;
    }

    return true;
  }
}
