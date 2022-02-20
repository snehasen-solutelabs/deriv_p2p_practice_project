// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:math' as math;
import 'package:deriv_p2p_practice_project/api/models/advert.dart';
import 'package:deriv_p2p_practice_project/core/states/pingService/ping_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'advert_list_state.dart';

/// Adverts cubit for managing active symbol state.
class AdvertListCubit extends Cubit<AdvertListState> {
  /// Initializes Adverts state.
  Timer? timer;

  final PingCubit pingCubit;

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

  // ignore: sort_constructors_first
  AdvertListCubit({required this.pingCubit}) : super(AdvertListInitialState()) {
    timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      fetchAdverts(isPeriodic: true);
      emit(AdvertListLoadedState(
          adverts: _adverts,
          hasRemaining: _adverts.length >= defaultDataFetchLimit,
          isPeriodic: true));
    });
  }
  void toggleSortOption(int index) {
    _sortType = index;
    _adverts.clear();
    fetchAdverts(isPeriodic: false);
  }

  void toggleCounterTypeOption(String type) {
    _counterType = type;
    //update tab chnage for advert list size
    _istabChanged = true;
    //remove sort type
    _sortType = 0;
    _adverts.clear();
    fetchAdverts(isPeriodic: false);
  }

  /// fetch limit for pagination
  final int defaultDataFetchLimit = 5;

  /// list of adverts
  final List<Advert> _adverts = <Advert>[];

  Future<void> fetchAdverts({required bool isPeriodic}) async {
    try {
      final int limit = isPeriodic
          ? math.max(_adverts.length, defaultDataFetchLimit)
          : defaultDataFetchLimit;
      final int offset = isPeriodic || _istabChanged ? 0 : _adverts.length;
      _istabChanged = false;
      if (offset == 0 || isPeriodic == false) {
        //off the indicator loader for piriodic fetch
        emit(AdvertListLoadingState());
      }

      final Map<String, dynamic>? advertListResponse = await pingCubit.binaryApi
          .p2pAdvertList(
            offset: offset,
            counterpartyType: _counterType,
            limit: limit,
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
// adding paging data
        emit(AdvertListLoadedState(
            adverts: _adverts,
            hasRemaining: list.length >= defaultDataFetchLimit,
            isPeriodic: isPeriodic));
      } else if (list.isEmpty) {
        //showing last added data
        emit(AdvertListLoadedState(
            adverts: _adverts,
            hasRemaining: list.length >= defaultDataFetchLimit,
            isPeriodic: isPeriodic));
      } else {
        emit(AdvertListErrorState('Something went wrong.'));
      }
    } on Exception catch (e) {
      emit(AdvertListErrorState('$e'));
    }
  }
}
