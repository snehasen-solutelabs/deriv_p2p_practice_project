enum AdvertType {
  buy,
  sell,
}

enum APIErrorType {
  serverError,
  restrictedCountry,
  disableAccount,
  unwelcomeAccount,
  expiredAccount,
  unsupportedCurrency,
  notAvailableCountry,
  accountNotLoaded,
  unknownError,
}

enum AdvertSortType {
  rate,
  completion,
}

/// The payment method type.
enum PaymentMethodEnum {
  /// The payment method type is bank transfer.
  bank,

  /// The payment method type is ewallet.
  ewallet,

  /// The payment method type is other.
  other,
}
