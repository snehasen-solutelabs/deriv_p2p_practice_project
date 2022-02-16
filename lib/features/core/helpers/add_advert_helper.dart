
// import 'package:flutter/material.dart';

// /// Helper class for maintaining the helper functions
// class AddAdvertHelper {
//   /// Returns the starting text based on advert type or ad
//   /// is creating or editing.
//   static String getStartingText(
//     BuildContext context, {
//     bool isSell = false,
//     bool isDefault = true,
//   }) =>
//       isDefault
//           ? context.localization
//               .you_re_creating_an_a_803038633(getAdvertTypeText(
//               context,
//               isSell: isSell,
//             ))
//           : context.localization
//               .you_re_editing_an_ad_103994194(getAdvertTypeText(
//               context,
//               isSell: isSell,
//             ));

//   /// Return text based on type advert
//   static String getAdvertTypeText(
//     BuildContext context, {
//     bool isSell = false,
//   }) =>
//       isSell
//           ? context.localization.sell_62706519.toLowerCase()
//           : context.localization.buy_558958195.toLowerCase();

//   /// Returns custom header text when user is creating or editing ad.
//   static RichText getHeaderCustomText(
//     BuildContext context,
//     Map<AddAdvertPageTextField, TextEditingController> _textControllers,
//     String accountCurrency,
//     String localCurrency, {
//     bool isSell = false,
//     bool isDefault = true,
//   }) {
//     final String _amount =
//         _textControllers[AddAdvertPageTextField.amountKey]!.text;
//     final String _fixRate =
//         _textControllers[AddAdvertPageTextField.fixRateKey]!.text;

//     return RichText(
//       text: TextSpan(
//         style: TextStyles.body1.copyWith(color: context.theme.colors.general),
//         children: <TextSpan>[
//           TextSpan(
//             text: '${getStartingText(
//               context,
//               isSell: isSell,
//               isDefault: isDefault,
//             )}${_amount.isNotEmpty ? ' ' : '...'}',
//           ),
//           if (_amount.isNotEmpty)
//             TextSpan(
//               text: '${double.tryParse(_amount)?.formatAccountCurrency(
//                     websiteStatus: WebsiteStatus.of(context),
//                     currency: accountCurrency,
//                     showSymbol: false,
//                   ) ?? _amount}',
//               style: TextStyles.body1.copyWith(fontWeight: FontWeight.bold),
//             ),
//           if (_amount.isNotEmpty && _fixRate.isNotEmpty) ...<TextSpan>[
//             TextSpan(text: ' ${context.localization.for_487365240}'),
//             TextSpan(
//                 text: ' ${getCalculatedAmount(
//                   context,
//                   _fixRate,
//                   _amount,
//                   localCurrency,
//                 )}',
//                 style: TextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
//             TextSpan(
//                 text: ' (${double.tryParse(
//                           _fixRate,
//                         )?.formatLocalCurrency(
//                           websiteStatus: WebsiteStatus.of(context),
//                           currency: localCurrency,
//                           showSymbol: false,
//                         ) ?? _fixRate}'
//                     '/$accountCurrency)'),
//           ]
//         ],
//       ),
//     );
//   }

//   /// Returns the calculated amount as [String].
//   static String getCalculatedAmount(
//     BuildContext context,
//     String rate,
//     String totalAmount,
//     String localCurrency,
//   ) {
//     final double dRate = double.parse(rate);
//     final double dTotalAmount = double.parse(totalAmount);

//     final double calculatedAmount = dTotalAmount * dRate;

//     return calculatedAmount.formatLocalCurrency(
//           websiteStatus: WebsiteStatus.of(context),
//           currency: localCurrency,
//           showSymbol: false,
//         ) ??
//         calculatedAmount.toStringAsFixed(2);
//   }

//   /// Returns formatted text of available string
//   static String formatAvailableBalance(
//     BuildContext context,
//     Advertiser advertiser,
//     String accountCurrency,
//   ) =>
//       advertiser.balanceAvailable.formatAccountCurrency(
//         websiteStatus: WebsiteStatus.of(context),
//         currency: accountCurrency,
//         showSymbol: false,
//       ) ??
//       '';

//   /// Make advert using fields
//   static Advert makeAdvert(
//           Map<AddAdvertPageTextField, TextEditingController> _textControllers,
//           List<PaymentMethod>? paymentMethodList,
//           List<AdvertiserPaymentMethod>? advertiserPaymentMethodList,
//           Advert? advert,
//           {bool isSell = false}) =>
//       Advert(
//         id: advert?.id,
//         type: isSell ? AdvertType.sell : AdvertType.buy,
//         amount: parseDouble(
//             _textControllers[AddAdvertPageTextField.amountKey]!.text),
//         rate: parseDouble(
//             _textControllers[AddAdvertPageTextField.fixRateKey]!.text),
//         minOrderAmount:
//             parseDouble(_textControllers[AddAdvertPageTextField.minKey]!.text),
//         maxOrderAmount:
//             parseDouble(_textControllers[AddAdvertPageTextField.maxKey]!.text),
//         paymentMethodNames: !isSell
//             ? paymentMethodList
//                 ?.map((PaymentMethod item) => item.method)
//                 .toList()
//             : null,
//         paymentMethodDetails: isSell ? advertiserPaymentMethodList : null,
//         paymentDetails: isSell &&
//                 _textControllers[AddAdvertPageTextField.paymentDetails]!.text !=
//                     ''
//             ? _textControllers[AddAdvertPageTextField.paymentDetails]!
//                 .text
//                 .xTrim()
//             : null,
//         contactDetails: isSell &&
//                 _textControllers[AddAdvertPageTextField.contactDetailsKey]!
//                         .text
//                         .xTrim() !=
//                     ''
//             ? _textControllers[AddAdvertPageTextField.contactDetailsKey]!
//                 .text
//                 .xTrim()
//             : null,
//         description: _textControllers[AddAdvertPageTextField.instruction]!
//                     .text
//                     .xTrim() !=
//                 ''
//             ? _textControllers[AddAdvertPageTextField.instruction]!.text.xTrim()
//             : advert != null
//                 ? ''
//                 : null,
//         isActive: advert?.isActive,
//       );

//   /// Provides text controller with default text usable for editing ads.
//   static TextEditingController textEditingControllerWithDefaultText(
//       AddAdvertPageTextField key, Advert? advert) {
//     switch (key) {
//       case AddAdvertPageTextField.amountKey:
//         return TextEditingController(text: advert?.amountDisplay);
//       case AddAdvertPageTextField.fixRateKey:
//         return TextEditingController(text: advert?.rateDisplay);
//       case AddAdvertPageTextField.minKey:
//         return TextEditingController(text: advert?.minOrderAmountDisplay);
//       case AddAdvertPageTextField.maxKey:
//         return TextEditingController(text: advert?.maxOrderAmountDisplay);
//       case AddAdvertPageTextField.paymentDetails:
//         return TextEditingController(text: advert?.paymentDetails);
//       case AddAdvertPageTextField.contactDetailsKey:
//         return TextEditingController(text: advert?.contactDetails);
//       case AddAdvertPageTextField.instruction:
//         return TextEditingController(text: advert?.description);
//       default:
//         return TextEditingController();
//     }
//   }

//   /// Displays a confirmation dialog for discarding the edited ad.
//   static Future<void> openCancelAlertDialogue(BuildContext context) async {
//     context.dismissKeyboard();

//     final bool? result = await OverlayManager().dialog?.show<bool>(
//           title: context.localization.cancel_your_edits_qu_239228918,
//           message: context.localization.if_you_choose_to_can_392133055,
//           negative: ActionButton(
//             label: context.localization.cancel_869476574,
//             onPress: () => OverlayManager().dialog?.hide<bool>(true),
//           ),
//           positive: ActionButton(
//             label: context.localization.do_not_cancel_684825744,
//             onPress: () => OverlayManager().dialog?.hide<bool>(false),
//           ),
//         );

//     if (result ?? false) {
//       Navigator.of(context).pop();
//     }
//   }

//   /// It validates the error should be displayed in a dialog or not.
//   static bool errorShouldBeDialog(APIError error) =>
//       error.isAdvertSameLimits || error.isDuplicateAdvert;
// }
