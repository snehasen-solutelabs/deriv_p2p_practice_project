import 'package:deriv_p2p_practice_project/api/models/advertiser.dart';
import 'package:deriv_p2p_practice_project/enums.dart';

/// Advert Model
class Advert {
  final String? accountCurrency;
  final Advertiser? advertiserDetails;
  final double? amount;
  final String? amountDisplay;
  final double? remainingAmount;
  final String? remainingAmountDisplay;
  final String? country;
  final AdvertType? counterpartyType;
  final int? createdTime;

  /// Days until automatic inactivation of this ad, if no activity occurs.
  final int? daysUntilArchive;

  final String? description;
  final String? id;
  final bool? isActive;

  /// Indicates that this advert will appear on the main advert list.
  final bool? isVisible;

  final String? localCurrency;
  final double? maxOrderAmount;
  final String? maxOrderAmountDisplay;
  final double? maxOrderAmountLimit;
  final String? maxOrderAmountLimitDisplay;
  final double? minOrderAmount;
  final String? minOrderAmountDisplay;
  final double? minOrderAmountLimit;
  final String? minOrderAmountLimitDisplay;

  final double? price;
  final String? priceDisplay;
  final double? rate;
  final String? rateDisplay;
  final AdvertType? type;
  final String? paymentDetails;
  final String? contactDetails;
  final AdvertSortType? sortBy;
  final bool? useClientLimits;

  /// It will be false if the remaining amount of the advert is less than the minAmount.
  bool get isPurchasable => remainingAmount! >= minOrderAmountLimit!;

  Advert({
    this.counterpartyType,
    this.accountCurrency,
    this.advertiserDetails,
    this.amount,
    this.amountDisplay,
    this.remainingAmount,
    this.remainingAmountDisplay,
    this.country,
    this.createdTime,
    this.daysUntilArchive,
    this.isActive,
    this.isVisible,
    this.localCurrency,
    this.maxOrderAmountLimit,
    this.maxOrderAmountLimitDisplay,
    this.maxOrderAmount,
    this.maxOrderAmountDisplay,
    this.minOrderAmountLimit,
    this.minOrderAmountLimitDisplay,
    this.minOrderAmount,
    this.minOrderAmountDisplay,
    this.description,
    this.id,
    this.price,
    this.priceDisplay,
    this.rate,
    this.rateDisplay,
    this.type,
    this.paymentDetails,
    this.contactDetails,
    this.sortBy,
    this.useClientLimits,
  });

  factory Advert.fromMap(Map<String, dynamic> advert) => Advert(
        accountCurrency: advert['account_currency'],
        advertiserDetails: Advertiser.fromMap(
            advert['advertiser_details'] ?? <String, dynamic>{}),
        amount: advert['amount']?.toDouble(),
        amountDisplay: advert['amount_display'],
        country: advert['country'],
        counterpartyType: advert['counterparty_type'] == 'sell'
            ? AdvertType.sell
            : AdvertType.buy,
        createdTime: advert['created_time'],
        daysUntilArchive: advert['days_until_archive'],
        description: advert['description'],
        id: advert['id'],
        isActive: advert['is_active'] == 1,
        isVisible: advert['is_visible'] == 1,
        localCurrency: advert['local_currency'],
        maxOrderAmount: advert['max_order_amount']?.toDouble(),
        maxOrderAmountDisplay: advert['max_order_amount_display'],
        maxOrderAmountLimit: advert['max_order_amount_limit']?.toDouble(),
        maxOrderAmountLimitDisplay: advert['max_order_amount_limit_display'],
        minOrderAmount: advert['min_order_amount']?.toDouble(),
        minOrderAmountDisplay: advert['min_order_amount_display'],
        minOrderAmountLimit: advert['min_order_amount_limit']?.toDouble(),
        minOrderAmountLimitDisplay: advert['min_order_amount_limit_display'],
        price: advert['price']?.toDouble(),
        priceDisplay: advert['price_display'],
        rate: advert['rate']?.toDouble(),
        rateDisplay: advert['rate_display'],
        remainingAmount: advert['remaining_amount']?.toDouble(),
        remainingAmountDisplay: advert['remaining_amount_display'],
        type: advert['type'] == 'sell' ? AdvertType.sell : AdvertType.buy,
        paymentDetails: advert['payment_info'],
        contactDetails: advert['contact_info'],
        sortBy: _getAdvertSortType(advert['sort_by']),
        useClientLimits: advert['use_client_limits'] == 1,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'amount': amount,
        'description': description,
        'max_order_amount': maxOrderAmount,
        'min_order_amount': minOrderAmount,
        'rate': rate,
        'type': type == AdvertType.sell ? 'sell' : 'buy',
        'payment_info': paymentDetails,
        'contact_info': contactDetails,
      };

  Advert copyWith({
    String? accountCurrency,
    Advertiser? advertiserDetails,
    double? amount,
    double? amountUsed,
    String? country,
    AdvertType? type,
    int? createdTime,
    bool? isActive,
    String? localCurrency,
    double? maxAmount,
    double? maxAmountLimit,
    List<PaymentMethodEnum>? paymentMethods,
    double? minAmount,
    double? minAmountLimit,
    String? orderDescription,
    double? price,
    double? rate,
    bool? isDeleted,
    String? paymentDetails,
    String? contactDetails,
  }) =>
      Advert(
        type: type ?? this.type,
        accountCurrency: accountCurrency ?? this.accountCurrency,
        advertiserDetails: advertiserDetails ?? this.advertiserDetails,
        amount: amount ?? this.amount,
        remainingAmount: amountUsed ?? remainingAmount,
        country: country ?? this.country,
        createdTime: createdTime ?? this.createdTime,
        isActive: isActive ?? this.isActive,
        localCurrency: localCurrency ?? this.localCurrency,
        maxOrderAmount: maxAmount ?? maxOrderAmount,
        maxOrderAmountLimit: maxAmountLimit ?? maxOrderAmountLimit,
        minOrderAmount: minAmount ?? minOrderAmount,
        minOrderAmountLimit: minAmountLimit ?? minOrderAmountLimit,
        description: orderDescription ?? description,
        id: id,
        price: price ?? this.price,
        rate: rate ?? this.rate,
        paymentDetails: paymentDetails ?? this.paymentDetails,
        contactDetails: contactDetails ?? this.contactDetails,
      );

  static AdvertSortType _getAdvertSortType(String? sortBy) {
    switch (sortBy) {
      case 'rate':
        return AdvertSortType.rate;
      case 'completion':
        return AdvertSortType.completion;
      default:
        return AdvertSortType.rate;
    }
  }

  @override
  String toString() => 'Advert { id: $id name: ${advertiserDetails?.name} }';

  // Todo(farzin): Should be moved to an extension class after refactoring this
  // model.
  /// Returns a list of [PaymentMethod] based on the given list of
  /// [PaymentMethodEnum].

}
/// 
// class Advert {
//   /// Advert Const
//   Advert(
//       {this.counterpartyType,
//       this.accountCurrency,
//       this.amountDisplay,
//       this.remainingAmountDisplay,
//       this.country,
//       this.isActive,
//       this.description,
//       this.id,
//       this.advertiserDetails});

//   /// Advert Const
//   factory Advert.fromMap(Map<String, dynamic> advert) => Advert(
//       accountCurrency: advert['account_currency'],
//       advertiserDetails: Advertiser.fromMap(
//           advert['advertiser_details'] ?? <String, dynamic>{}),
//       amountDisplay: advert['amount_display'],
//       country: advert['country'],
//       counterpartyType: advert['counterparty_type'] == 'sell'
//           ? AdvertType.sell
//           : AdvertType.buy,
//       description: advert['description'],
//       id: advert['id'],
//       isActive: advert['is_active'] == 1,
//       remainingAmountDisplay: advert['remaining_amount_display']);

//   /// accountCurrency val
//   final String? accountCurrency;

//   /// amountDisplay val
//   final String? amountDisplay;

//   /// remainingAmountDisplay val
//   final String? remainingAmountDisplay;

//   /// country val
//   final String? country;

//   /// counterpartyType val
//   final AdvertType? counterpartyType;

//   /// description val
//   final String? description;

//   /// id val
//   final String? id;

//   /// isActive val
//   final bool? isActive;

//   /// advertiserDetails val
//   final Advertiser? advertiserDetails;
// }