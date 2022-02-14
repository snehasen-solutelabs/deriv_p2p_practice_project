// Todo(farzin): This is a workaround to use `flutter_deriv_api` in the app, We
// need to migrate gradually for each method and eventually remove this wrapper.
// Therefor there is no need to refactor or clean up this file.

import 'dart:async';
import 'dart:developer' as dev;

import 'dart:convert';
import 'package:deriv_p2p_practice_project/api/account/interceptor/interceptor.dart';
import 'package:deriv_p2p_practice_project/features/core/helpers/json_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deriv_api/api/models/enums.dart';
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
    required this.interceptor,
  }) {
    _derivAPI = deriv_api.BinaryAPI(uniqueKey);
  }

  late final deriv_api.BinaryAPI _derivAPI;

  /// The interceptor to intercept the request and response.
  final Interceptor? interceptor;

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
  }

  /// Disconnects from API
  Future<void> close() async {
    await _derivAPI.disconnect();
  }

  Future<Map<String, dynamic>> _derivAPICall(Request request) async {
    interceptor?.onRequest(request.toJson());

    final Response response = await _derivAPI.call<Response>(request: request);

    return _normalizeErrorObject(response);
  }

  Future<AuthorizeResponse> authorize(String? token) async {
    AuthorizeResponse authObj;
    try {
      authObj = AuthorizeResponse.fromJson(
        await _derivAPICall(AuthorizeRequest(authorize: token)),
      );
    } on Exception catch (e, stackTrace) {
      dev.log('Authorize request failed', error: e, stackTrace: stackTrace);
      throw Exception(e);
    }

    return authObj;
  }

  Future<BalanceResponse> balance() async {
    BalanceResponse balanceResponse;
    try {
      balanceResponse = BalanceResponse.fromJson(
        await _derivAPICall(const BalanceRequest()),
      );
    } on Exception catch (e, stackTrace) {
      dev.log('Get balance failed', error: e, stackTrace: stackTrace);
      throw Exception(e);
    }

    return balanceResponse;
  }

  Future<WebsiteStatusResponse> fetchWebsiteStatus() async =>
      WebsiteStatusResponse.fromJson(
        await _derivAPICall(const WebsiteStatusRequest()),
      );

  Future<Map<String, dynamic>> getAccountSettings() =>
      _derivAPICall(const GetSettingsRequest());

  Future<Map<String, dynamic>> getServiceToken(String service) =>
      _derivAPICall(ServiceTokenRequest(server: null, service: service));

  Future<Map<String, dynamic>> logout() => _derivAPICall(const LogoutRequest());

  /// Create P2P advert.
  // Future<Map<String, dynamic>> p2pAdvertCreate({
  //   required Advert advert,
  // }) {
  //   final bool isBuy = advert.type == AdvertType.buy;

  //   // Todo(waqas): Get rid of advert entity and pass data in params.

  //   return _derivAPICall(
  //     P2pAdvertCreateRequest(
  //       paymentMethodIds: isBuy ? null : advert.paymentMethodDetails?.ids(),
  //       paymentMethodNames: isBuy ? advert.paymentMethodNames : null,
  //       type: isBuy ? 'buy' : 'sell',
  //       amount: advert.amount,
  //       maxOrderAmount: advert.maxOrderAmount,
  //       minOrderAmount: advert.minOrderAmount,
  //       description: advert.description,
  //       rate: advert.rate,
  //       paymentInfo: advert.paymentDetails,
  //       contactInfo: advert.contactDetails,
  //       // Todo(farzin): Should be handled in the UI.
  //       paymentMethod: (advert.paymentMethodNames?.isEmpty ?? true) &&
  //               (advert.paymentMethodDetails?.isEmpty ?? true)
  //           ? 'bank_transfer'
  //           : null,
  //     ),
  //   );
  // }

  Future<Map<String, dynamic>> p2pAdvertInfo(
    String? id, {
    bool useClientLimits = true,
    bool subscribe = false,
  }) =>
      _derivAPICall(
        P2pAdvertInfoRequest(id: id, useClientLimits: useClientLimits),
      );

  Future<Map<String, dynamic>> p2pAdvertList({
    String? accountCurrency,
    String? advertiserId,
    double? amount,
    String? country,
    String? counterpartyType,
    int? limit,
    int? offset,
    String? targetCurrency,
    bool? filterByClientLimits,
    List<String>? paymentMethods,
    //AdvertSortType? sortBy,
    String? searchQuery,
  }) =>
      _derivAPICall(P2pAdvertListRequest(
        advertiserId: advertiserId,
        counterpartyType: counterpartyType,
        limit: limit,
        offset: offset,
        amount: amount,
        // sortBy: sortBy?.stringValue(),
        useClientLimits: filterByClientLimits,
        paymentMethod: (paymentMethods != null && paymentMethods.isNotEmpty)
            ? paymentMethods
            : null,
        localCurrency: accountCurrency,
        advertiserName: searchQuery,
        // country: country,
        // targetCurrency: targetCurrency,
      ));

  Future<Map<String, dynamic>> p2pAdvertiserAdverts({
    int? limit,
    int? offset,
  }) =>
      _derivAPICall(P2pAdvertiserAdvertsRequest(limit: limit, offset: offset));

  Future<Map<String, dynamic>> p2pAdvertiserCreate(
    Map<String, dynamic> advertiser,
  ) =>
      _derivAPICall(P2pAdvertiserCreateRequest.fromJson(advertiser));

  Future<Map<String, dynamic>> p2pAdvertiserInfo({Map<String, dynamic>? req}) =>
      _derivAPICall(
        req != null
            ? P2pAdvertiserInfoRequest.fromJson(req)
            : const P2pAdvertiserInfoRequest(),
      );

  Future<Map<String, dynamic>> p2pOrderDispute({
    required String? orderId,
    required String? reason,
  }) =>
      _derivAPICall(P2pOrderDisputeRequest(
        id: orderId!,
        disputeReason: reason,
      ));

  Future<Map<String, dynamic>> p2pOrderInfo({String? id}) =>
      _derivAPICall(P2pOrderInfoRequest(id: id));

  Future<Map<String, dynamic>> p2pOrderList({
    int? advertId,
    int? offset,
    int? limit,
    bool? isActive,
  }) =>
      _derivAPICall(
        P2pOrderListRequest(
          advertId: advertId != null ? advertId.toString() : null,
          offset: offset,
          limit: limit,
          active: isActive != null
              ? isActive
                  ? 1
                  : 0
              : null,
        ),
      );

  /// Get account status.
  Future<Map<String, dynamic>> fetchAccountStatus() => _derivAPICall(
        const GetAccountStatusRequest(),
      );

  Future<Map<String, dynamic>> ping() => _derivAPICall(const PingRequest());

  Future<Map<String, dynamic>> time() => _derivAPICall(const TimeRequest());

  Stream<Map<String, dynamic>?> subscribeAdvertiserInfo({String? id}) =>
      _derivAPI
          .subscribe(request: P2pAdvertiserInfoRequest(id: id))!
          .map((Response response) => _normalizeErrorObject(response));

  Stream<BalanceResponse> subscribeBalance() => _derivAPI
      .subscribe(request: const BalanceRequest())!
      .map((Response response) =>
          BalanceResponse.fromJson(_normalizeErrorObject(response)));

  Stream<Map<String, dynamic>?> subscribeOrderInfo({String? id}) => _derivAPI
      .subscribe(request: P2pOrderInfoRequest(id: id))!
      .map((Response response) => _normalizeErrorObject(response));

  Stream<Map<String, dynamic>?> subscribeP2pOrderList({
    int? advertId,
    int? offset,
    int? limit,
  }) =>
      _derivAPI
          .subscribe(
            request: P2pOrderListRequest(
              advertId: advertId != null ? advertId.toString() : null,
              offset: offset,
              limit: limit,
            ),
          )!
          .map((Response response) => _normalizeErrorObject(response));

  Stream<WebsiteStatusResponse> subscribeWebsiteStatus() => _derivAPI
      .subscribe(request: const WebsiteStatusRequest())!
      .map((Response response) =>
          WebsiteStatusResponse.fromJson(_normalizeErrorObject(response)));

  Future<Map<String, dynamic>?> unsubscribe(
    String? subscriptionId, {
    bool shouldForced = false,
  }) async {
    final ForgetResponse response = await _derivAPI.unsubscribe(
      subscriptionId: subscriptionId,
    );

    return _normalizeErrorObject(response);
  }

  Future<ForgetAllResponse> unsubscribeAll(
    String method, {
    bool shouldForced = false,
  }) {
    late ForgetStreamType _method;

    switch (method) {
      case 'balance':
        _method = ForgetStreamType.balance;
        break;
      case 'candles':
        _method = ForgetStreamType.candles;
        break;
      case 'p2p_advertiser':
        _method = ForgetStreamType.p2pAdvertiser;
        break;
      case 'p2p_order':
        _method = ForgetStreamType.p2pOrder;
        break;
      case 'proposal':
        _method = ForgetStreamType.proposal;
        break;
      case 'proposal_array':
        _method = ForgetStreamType.proposalArray;
        break;
      case 'proposal_open_contract':
        _method = ForgetStreamType.proposalOpenContract;
        break;
      case 'ticks':
        _method = ForgetStreamType.ticks;
        break;
      case 'transaction':
        _method = ForgetStreamType.transaction;
        break;
      case 'websiteStatus':
        _method = ForgetStreamType.websiteStatus;
        break;
      default:
        throw Exception(
          'method should be one of the following:'
          'balance, candles, p2p_advertiser, p2p_order, proposal, '
          'proposal_array, proposal_open_contract, ticks, '
          'transaction, websiteStatus,',
        );
    }

    return _derivAPI.unsubscribeAll(method: _method);
  }

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

    interceptor?.handleResponse(rawResponse);

    return rawResponse;
  }
}
