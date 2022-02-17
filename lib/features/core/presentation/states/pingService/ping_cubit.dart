import 'dart:developer' as dev;

import 'package:deriv_p2p_practice_project/api/binary_api_wrapper.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Deriv ping cubit for managing active symbol state.
class PingCubit extends Cubit<PingState> {
  /// Initializes ping cubit.
  PingCubit() : super(PingInitialState()) {}
  final UniqueKey _uniqueKey = UniqueKey();
  late BinaryAPIWrapper _api;

  BinaryAPIWrapper get binaryApi => _api;

  /// init web socket
  Future<void> initWebSocket() async {
    try {
      emit(PingLoadingState());

      _api = BinaryAPIWrapper(uniqueKey: UniqueKey());

      await _api.close();
      await _api.run(onOpen: (UniqueKey? uniqueKey) {
        dev.log('onOpen : $uniqueKey');
      }, onDone: (UniqueKey? uniqueKey) {
        if (_uniqueKey == uniqueKey) {
          emit(PingLoadedState(api: _api));
        }
      }, onError: (UniqueKey? uniqueKey) {
        dev.log('onError : $uniqueKey');
        emit(PingErrorState('Ping connection failed...'));
      });

      final Map<String, dynamic> response =
          await _api.ping().timeout(const Duration(seconds: 15));
      if (response['ping'] != 'pong') {
        /// not connected
        emit(PingErrorState('Ping connection failed...'));
      }

      final Map<String, dynamic> authResponse = await _api
          .authorize('uqYHus0dKB1pOAF')
          .timeout(const Duration(seconds: 15));
      if (authResponse['error'] == null) {
        emit(PingErrorState('Authorisation error...'));
      }

      emit(PingLoadedState(api: _api));
    } on Exception catch (e) {
      emit(PingErrorState('$e'));
    }
  }
}
