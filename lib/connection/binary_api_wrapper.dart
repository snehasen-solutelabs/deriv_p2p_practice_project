// Todo(farzin): This is a workaround to use `flutter_deriv_api` in the app, We
// need to migrate gradually for each method and eventually remove this wrapper.
// Therefor there is no need to refactor or clean up this file.

import 'dart:async';
import 'dart:developer' as dev;


import 'package:deriv_p2p_practice_project/features/core/helpers/json_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deriv_api/basic_api/generated/api.dart';
import 'package:flutter_deriv_api/basic_api/request.dart';
import 'package:flutter_deriv_api/basic_api/response.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/binary_api.dart'
    as deriv_api;
import 'package:flutter_deriv_api/services/connection/api_manager/connection_information.dart';

import 'package:web_socket_channel/io.dart';

/// A wrapper around `flutter_deriv_api` package.
class BinaryAPIWrapper {
  /// Constructs a new BinaryAPIWrapper.
  BinaryAPIWrapper({
    required UniqueKey uniqueKey,
   
  }) {
    _derivAPI = deriv_api.BinaryAPI(uniqueKey);
  }

  late final deriv_api.BinaryAPI _derivAPI;


  /// Connects to API
  Future<IOWebSocketChannel?> run({
    void Function(UniqueKey? uniqueKey)? onError,
    void Function(UniqueKey? uniqueKey)? onDone,
    void Function(UniqueKey? uniqueKey)? onOpen,
  }) async {
    final ConnectionInformation connectionInformation = ConnectionInformation(
      appId: "1089",
      brand: 'deriv',
      endpoint: 'frontend.binaryws.com',
    );

    await _derivAPI.connect(
      connectionInformation,
      onOpen: onOpen?.call,
      onDone: onDone?.call,
      onError: onError?.call,
    );
    return null;
  }

  /// Disconnects from API
  Future<void> close() async {
    await _derivAPI.disconnect();
  }

  Future<Map<String, dynamic>> _derivAPICall(Request request) async {
   // interceptor?.onRequest(request.toJson());

    final Response response = await _derivAPI.call<Response>(request: request);

    return _normalizeErrorObject(response);
  }

  Future<AuthorizeResponse> authorize(String? token) async {
    AuthorizeResponse authObj;
    try {
      authObj = AuthorizeResponse.fromJson(
        await _derivAPICall(AuthorizeRequest(authorize: "nmvjJ0udMuFBr0d")),
      );
    } on Exception catch (e, stackTrace) {
      dev.log('Authorize request failed', error: e, stackTrace: stackTrace);
      throw Exception(e);
    }

    return authObj;
  }

  Future<Map<String, dynamic>> p2pAdvertList({
    // String? accountCurrency,
    // String? advertiserId,
    // double? amount,
    // String? country,
    // String? counterpartyType,
    // int? limit,
   
    //AdvertSortType? sortBy,
    String? searchQuery,
  }) =>
      _derivAPICall(P2pAdvertListRequest(
        // advertiserId: advertiserId,
        // counterpartyType: counterpartyType,
        // limit: limit,
        // offset: offset,
        // amount: amount,
        // // sortBy: sortBy?.stringValue(),
        // useClientLimits: filterByClientLimits,
        // paymentMethod: (paymentMethods != null && paymentMethods.isNotEmpty)
        //     ? paymentMethods
        //     : null,
        // localCurrency: accountCurrency,
        // advertiserName: searchQuery,
        // country: country,
        // targetCurrency: targetCurrency,
      )); 
  /// Get account status.
  Future<Map<String, dynamic>> fetchAccountStatus() => _derivAPICall(
        const GetAccountStatusRequest(),
      );

  Future<Map<String, dynamic>> ping() => _derivAPICall(const PingRequest());

  Future<Map<String, dynamic>> time() => _derivAPICall(const TimeRequest());

  Map<String, dynamic> _normalizeErrorObject(Response response) {
    final Map<String, dynamic> rawResponse = JSONHelper.decode(
      JSONHelper.encode(response.toJson()),
      convertObjectToArrayKeys: <String>[
        'p2p_payment_methods',
        'p2p_advertiser_payment_methods',
        'payment_method_details',
        'fields',
        // Todo(farzin): Uncomment following line when WebsiteStatusBloc is
        // replaced with WebsiteStatusCubit.
        // 'currencies_config',
      ],
    );

    if (rawResponse['error'] == null) {
      rawResponse.remove('error');
    }

    //interceptor?.handleResponse(rawResponse);

    return rawResponse;
  }
}
