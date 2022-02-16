// import 'package:flutter_deriv_api/helpers/helpers.dart';

// /// Helper that contains helper functions for saving @userClientLimits value
// /// in the user device in order to use it in the next api calls.

// /// Key for filter adverts by client limits.
// const String filterByClientLimitsKey =
//     'SHOULD_SHOW_MATCHED_CLIENT_LIMIT_ADVERT';

// /// Key for payment methods filter lsit.
// const String paymentMethodsFilterKey = 'PAYMENT_METHODS_FILTER';

// /// Get a boolean that indicates if adverts should filter by client limits or
// /// not.
// Future<bool> getFilterByClientLimits() => getBool(filterByClientLimitsKey);

// /// Save the user input that is a boolean that indicates if adverts should
// /// filter by client limits or not.
// Future<void> setFilterByClientLimits({required bool filterByClientLimits}) =>
//     setBool(filterByClientLimitsKey, filterByClientLimits);

// /// Get a list of `PaymentMethod` as a String that list of adverts will be
// /// filtered by them.
// Future<List<String>?> getPaymentMethodsFilter() =>
//     getStringList(paymentMethodsFilterKey);

// /// Save a list of `PaymentMethod` as a String that list of adverts will be
// /// filtered by them.
// Future<void> setPaymentMethodsFilter(List<String> paymentMethodsFilter) =>
//     setStringList(paymentMethodsFilterKey, paymentMethodsFilter);
