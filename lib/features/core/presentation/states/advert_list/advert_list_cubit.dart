import 'dart:developer' as dev;

import 'package:deriv_p2p_practice_project/api/binary_api_wrapper.dart';
import 'package:deriv_p2p_practice_project/api/response/advert.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'advert_list_state.dart';

/// Adverts cubit for managing active symbol state.
class AdvertListCubit extends Cubit<AdvertListState> {
  /// Initializes Adverts state.
  AdvertListCubit() : super(AdvertListInitialState());

  late BinaryAPIWrapper _api;

  /// fetch limit for pagination
  final int defaultDataFetchLimit = 10;

  /// list of adverts
  final List<Advert> _adverts = <Advert>[];
  BinaryAPIWrapper get binaryApi => _api;

  /// fetch list of adverts
  ///
  ///
  Future<void> fetchAdverts() async {
    try {
      emit(AdvertListLoadingState());

      final Map<String, dynamic>? advertListResponse = await _api.p2pAdvertList(
          offset: 0, counterpartyType: 'buy', limit: 10);
      if (advertListResponse?['error'] != null) {
        print("error");
        emit(AdvertListErrorState(advertListResponse?['error']));
      }
    } on Exception catch (e) {
      emit(AdvertListErrorState('$e'));
    }
  }

  ///
  // Future<void> fetchAdverts() async {
  //   try {
  //     final int offset = _adverts.length ~/ defaultDataFetchLimit;
  //     // if (offset == 0) {
  //     //   print("error1");
  //     //   emit(AdvertListLoadingState());
  //     // }

  //     dev.log('_binaryAPIWrapper : $_api');

  //     final Map<String, dynamic>? advertListResponse = await _api.p2pAdvertList(
  //         offset: 0, counterpartyType: 'buy', limit: 10);

  //     if (advertListResponse?['error'] != null) {
  //       print("error");
  //       emit(AdvertListErrorState(advertListResponse?['error']));
  //     }

  //     final List<dynamic> list = advertListResponse?['p2p_advert_list']['list'];
  //     if (list.isNotEmpty) {
  //       for (final Map<String, dynamic> response in list) {
  //         _adverts.add(Advert.fromMap(response));
  //       }
  //     }

  //     dev.log('_adverts : ${_adverts.length}');
  //     emit(AdvertListLoadedState(
  //         adverts: _adverts,
  //         hasRemaining: list.length >= defaultDataFetchLimit));
  //   } on Exception catch (e) {
  //     dev.log('$AdvertListCubit fetchAdverts() error: $e');

  //     emit(AdvertListErrorState('$e'));
  //   }
  // }
}
