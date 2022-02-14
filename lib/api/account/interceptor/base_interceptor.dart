import 'package:deriv_p2p_practice_project/api/api_error.dart';

/// Base abstract class for interceptor.
abstract class BaseInterceptor {
  // Todo(farzin): Investigate what the boolean return value actually means here
  // and add documentation for clarification.
  /// This callback will be called when the response is received.
  bool handleResponse(Map<String, dynamic> response);

  /// This callback will be called before the request is sent.
  void onRequest(Map<String, dynamic> req);

  /// This callback will be called when the response does not contain errors.
  bool onSuccess(Map<String, dynamic> success) => true;

  /// This callback will be called when the response contains an error.
  bool onError(APIError error) => true;
}
