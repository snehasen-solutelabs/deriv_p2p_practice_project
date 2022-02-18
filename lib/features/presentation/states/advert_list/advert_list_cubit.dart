// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math' as math;
import 'package:deriv_p2p_practice_project/api/models/advert.dart';
import 'package:deriv_p2p_practice_project/core/states/pingService/ping_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'advert_list_state.dart';

/// Adverts cubit for managing active symbol state.
class AdvertListCubit extends Cubit<AdvertListState> {
  /// Initializes Adverts state.
  Timer? timer;
  // ignore: public_member_api_docs
  final PingCubit pingCubit;
  // ignore: public_member_api_docs

//1 for rate and 2 for completion rate
  int _sortType = 0;

  /// get selected sort type
  int get sortType => _sortType;

  String _counterType = 'buy';

  /// get selected sort type
  String get counterType => _counterType;

  bool _istabChanged = false;

  /// get selected sort type
  bool get istabChanged => _istabChanged;

  void toggleSortOption(int index) {
    _sortType = index;

    fetchAdverts(isPeriodic: false);
  }

  void toggleCounterTypeOption(String type) {
    _counterType = type;
    _istabChanged = true;
  }

  // ignore: sort_constructors_first
  AdvertListCubit({required this.pingCubit}) : super(AdvertListInitialState()) {
    timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      // print('Timer');
      fetchAdverts(isPeriodic: true);
      emit(AdvertListLoadedState(
          adverts: _adverts,
          hasRemaining: _adverts.length >= defaultDataFetchLimit));
    });
  }

  /// fetch limit for pagination
  final int defaultDataFetchLimit = 10;

  /// list of adverts
  final List<Advert> _adverts = <Advert>[];

  // ignore: public_member_api_docs
  Future<void> fetchAdverts({required bool isPeriodic}) async {
    try {
      // print("pageCount $pageCount");
      final int offset =
          _istabChanged == true ? 0 : _adverts.length ~/ defaultDataFetchLimit;
      if (offset == 0) {
        emit(AdvertListLoadingState());
      }
      // final int limit = isPeriodic
      //     ? math.max(_adverts.length, defaultDataFetchLimit)
      //     : defaultDataFetchLimit;
      // final int offset = isPeriodic || _istabChanged ? 0 : _adverts.length;
      //dev.log('advert_list_cubit_req : offset = $offset : limit = $limit : '
      // 'isPeriodic = $isPeriodic : list = ${_adverts.length}');

      if (offset == 0) {
        emit(AdvertListLoadingState());
      }

      final Map<String, dynamic>? advertListResponse = await pingCubit.binaryApi
          .p2pAdvertList(
            offset: offset,
            counterpartyType: _counterType,
            limit: 10,
            sortBy: _sortType == 0 ? 'rate' : 'completion',
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
      emit(AdvertListErrorState('$e'));
    }
  }
}
