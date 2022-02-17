import 'dart:async';
import 'dart:developer' as dev;
import 'package:deriv_p2p_practice_project/api/binary_api_wrapper.dart';
import 'package:deriv_p2p_practice_project/api/models/advert.dart';
import 'package:deriv_p2p_practice_project/enums.dart';
import 'package:deriv_p2p_practice_project/features/core/helpers/advert_list_cubit_pref_helper.dart';
import 'package:deriv_p2p_practice_project/features/core/helpers/sort_pref_helper.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'advert_list_state.dart';

/// Adverts cubit for managing active symbol state.
class AdvertListCubit extends Cubit<AdvertListState> {
  /// Initializes Adverts state.
  Timer? timer;
  final PingCubit pingCubit;

  AdvertListCubit({required this.pingCubit}) : super(AdvertListInitialState()) {
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      print('Timer');
      fetchAdverts(true, false);
      emit(AdvertListLoadedState(
          adverts: _adverts,
          hasRemaining: _adverts.length >= defaultDataFetchLimit));
    });
  }

  /// fetch limit for pagination
  final int defaultDataFetchLimit = 10;

  /// list of adverts
  final List<Advert> _adverts = <Advert>[];

  Future<void> fetchAdverts(bool isTabChanged, bool isPeriodic) async {
    try {
      final int offset =
          isTabChanged == true ? 0 : _adverts.length ~/ defaultDataFetchLimit;
      if (offset == 0) {
        emit(AdvertListLoadingState());
      }
      String counterpartyType = 'buy';
      if (await isCounterpartyTypeSell()) {
        counterpartyType = 'sell';
      } else {
        counterpartyType = 'buy';
      }
      final Map<String, dynamic>? advertListResponse = await pingCubit.binaryApi
          .p2pAdvertList(
            offset: isPeriodic ? 0 : offset,
            counterpartyType: counterpartyType,
            limit: 10,
          )
          .timeout(const Duration(seconds: 50));
      if (advertListResponse?['error'] != null) {
        emit(AdvertListErrorState(advertListResponse?['error']));
      }

      final List<dynamic> list = advertListResponse?['p2p_advert_list']['list'];
      if (list.isNotEmpty) {
        if (offset == 0) {
          _adverts.clear();
        }
        for (final Map<String, dynamic> response in list) {
          _adverts.add(Advert.fromMap(response));
        }

        dev.log('_adverts : ${_adverts.length}');

        emit(AdvertListLoadedState(
            adverts: _adverts,
            hasRemaining: list.length >= defaultDataFetchLimit));
      } else {
        emit(AdvertListErrorState('Something went wrong.'));
      }
    } on Exception catch (e) {
      dev.log('$AdvertListCubit fetchAdverts() error: $e');

      emit(AdvertListErrorState('$e'));
    }
  }
}
