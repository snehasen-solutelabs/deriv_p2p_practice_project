import 'package:deriv_p2p_practice_project/features/core/helpers/shared_preferences_helper.dart';

/// Helper that contains helper functions for saving @counterpartyType value
/// in the user device in order to use it in the following situation:
/// User is on the Sell tab in the `Buy/Sell` page and clicks on the Search button.
/// Then after she send a query for search, we should show her sell adverts. As
/// we use different instances of `AdvertListBloc` in the `SearchPage` and `Buy/Sell`
/// page, we should use this approach.

/// Key for counterparty type.
const String isCounterpartyTypeSellKey = 'IS_COUNTERPARTY_TYPE_SELL';

/// Get a boolean that indicates counterpartyType is sell or not.
Future<bool> isCounterpartyTypeSell() => getBool(isCounterpartyTypeSellKey);

/// Save a boolean that shows counterparty type is sell or not.
Future<void> setCounterpartyType({required bool isCounterpartyTypeSell}) =>
    setBool(isCounterpartyTypeSellKey, isCounterpartyTypeSell);

/// she should see sell adverts.
/// Key for initial counterparty type.
const String isInitCounterpartyTypeSellKey = 'IS_INIT_COUNTERPARTY_TYPE_SELL';

/// Get a boolean that indicates initial counterpartyType is sell or not.
Future<bool> isInitCounterpartyTypeSell() =>
    getBool(isInitCounterpartyTypeSellKey);

/// Save a boolean that shows initial counterparty type is sell or not.
Future<void> setInitCounterpartyType(
        {required bool isInitCounterpartyTypeSell}) =>
    setBool(isInitCounterpartyTypeSellKey, isInitCounterpartyTypeSell);

// ignore: public_member_api_docs
const String initPageTotalCountKey = 'INIT_PAGE_TOTAL_COUNT';

/// Get a int that count total page loaded
Future<int> initPageTotalCount() => getInt(initPageTotalCountKey);

/// save a int that count total page loaded
Future<void> setPageCount({required int initPageTotalCount}) =>
    setInt(initPageTotalCountKey, initPageTotalCount);
