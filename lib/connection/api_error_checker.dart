import 'package:deriv_p2p_practice_project/api/api_error.dart';
import 'package:deriv_p2p_practice_project/connection/deriv_connection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This wrapper listens to the connection state and shows an error page if the
/// connection state is [Disconnected] with an [APIError].
// ignore: must_be_immutable
class APIErrorChecker extends StatelessWidget {
  /// Constructs a new P2PDisabledChecker.
  APIErrorChecker({
    required this.child,
  });

  /// The child widget this widget will wrap.
  final Widget child;

  // Since we can't know if we are already have navigated to an error page, to
  // prevent pushing the same page again, We use this flag variable to disable
  // listener when we navigate to the error page and enable it again when we
  // close it.
  bool _shouldListen = true;

  Future<void> _setConnectionListener(
    BuildContext context,
    DerivConnectionState state,
  ) async {
    if (state is Disconnected) {
      _shouldListen = false;
      await _handleAPIError(context, state);
      _shouldListen = true;
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<DerivConnectionCubit, DerivConnectionState>(
        listenWhen: (_, __) => _shouldListen,
        listener: _setConnectionListener,
        child: child,
      );

  Future<void> _handleAPIError(
    BuildContext context,
    Disconnected state,
  ) async {
    if (state.shouldShowErrorPage) {
      final APIError error = state.error!;

      // if (error.isP2PDisabled) {
      //   return NavigationHelper.navigateToP2PDisabledPage(context, error);
      // } else if (error.isUserUnwelcome || error.isUserDisabled) {
      //   return NavigationHelper.navigateToAccountBlockedPage(context);
      // }
    } else if (state.error != null) {
      final String? message = state.error!.isLocal
          ? state.error!.fromLocal(context).message
          : state.error!.message;

      if (message != null) {
        // OverlayManager().snackbar?.show(message);
      }
    }
  }
}
