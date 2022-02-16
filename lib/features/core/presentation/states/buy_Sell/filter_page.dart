// import 'package:collection/collection.dart';
// import 'package:deriv_theme/text_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:otc_cashier/buy_sell/filter_adverts/adverts_filter_pref_helper.dart';
// import 'package:otc_cashier/buy_sell/filter_adverts/filter_controller.dart';
// import 'package:otc_cashier/core/assets.dart';
// import 'package:otc_cashier/features/core/presentation/widgets/check_box_tile.dart';
// import 'package:otc_cashier/features/features.dart';
// import 'package:otc_cashier/widget/divider.dart';

// // Todo(Havir): This page should refactor and go under feature directory when
// // whole Buy/Sell feature is refactored.
// /// FilterPage that is responsible for showing filters for advert list on the
// /// `BuySellPage`.
// class FilterPage extends StatefulWidget {
//   /// Constructs `FilterPage`.
//   const FilterPage({
//     @required this.filterController,
//     Key? key,
//   }) : super(key: key);

//   final FilterController? filterController;

//   @override
//   _FilterPageState createState() => _FilterPageState();
// }

// class _FilterPageState extends State<FilterPage> {
//   final List<PaymentMethod> _selectedPaymentMethods = <PaymentMethod>[];
//   final List<PaymentMethod> _savedPaymentMethodsFilter = <PaymentMethod>[];
//   bool _matchAdsFilter = false;
//   bool _savedMatchAdsFilter = false;

//   @override
//   void initState() {
//     super.initState();

//     context.read<PaymentMethodsCubit>().fetch();

//     _getSavedFilters();
//   }

//   Future<void> _getSavedFilters() async {
//     final List<String>? savedPaymentMethods = await getPaymentMethodsFilter();
//     final List<PaymentMethod>? selectedPaymentMethods =
//         PaymentMethodHelper.convertPaymentMethodNamesToModel(
//       context,
//       savedPaymentMethods,
//     );

//     if (selectedPaymentMethods != null) {
//       _savedPaymentMethodsFilter
//         ..clear()
//         ..addAll(selectedPaymentMethods);
//     }

//     _savedMatchAdsFilter = await getFilterByClientLimits();

//     setState(() {
//       _selectedPaymentMethods
//         ..clear()
//         ..addAll(_savedPaymentMethodsFilter);

//       _matchAdsFilter = _savedMatchAdsFilter;
//     });
//   }

//   @override
//   Widget build(BuildContext context) => _buildBody();

//   Widget _buildBody() => Scaffold(
//         backgroundColor: context.theme.colors.primary,
//         appBar: _buildAppBar(),
//         body: Column(
//           children: <Widget>[
//             Expanded(
//               child: Column(
//                 children: <Widget>[
//                   FeatureFlag(
//                     feature: FeaturesEnum.paymentMethod,
//                     child: Column(
//                       children: <Widget>[
//                         _buildPaymentMethods(context),
//                         const BaseDivider(),
//                       ],
//                     ),
//                   ),
//                   _buildMatchingAds(context),
//                   const BaseDivider(),
//                 ],
//               ),
//             ),
//             BottomActionBar(
//               primary: ActionButton(
//                 label: context.localization.apply_627484285,
//                 onPress: _canUpdateFilters() ? _onApplyPressed : null,
//               ),
//             ),
//           ],
//         ),
//       );

//   bool _canUpdateFilters() {
//     final Function equality = const DeepCollectionEquality.unordered().equals;

//     return (!equality(_savedPaymentMethodsFilter, _selectedPaymentMethods)) ||
//         _matchAdsFilter != _savedMatchAdsFilter;
//   }

//   void _onApplyPressed() {
//     widget.filterController!.onFilterApplied!(
//       filterByClientLimits: _matchAdsFilter,
//       paymentMethods: _selectedPaymentMethods,
//     );

//     Navigator.pop(
//       context,
//       _matchAdsFilter || _selectedPaymentMethods.isNotEmpty,
//     );
//   }

//   Widget _buildMatchingAds(BuildContext context) => CheckboxTile(
//         title: context.localization.matching_ads_504540367,
//         subtitle: context.localization.ads_that_match_your_70796554,
//         value: _matchAdsFilter,
//         onChanged: (bool? updatedValue) => setState(() {
//           _matchAdsFilter = updatedValue ?? false;
//         }),
//       );

//   Widget _buildPaymentMethods(BuildContext context) =>
//       BlocBuilder<PaymentMethodsCubit, BaseState<List<PaymentMethod>>>(
//         builder: (
//           BuildContext context,
//           BaseState<List<PaymentMethod>> state,
//         ) {
//           final String paymentMethodsName = _paymentMethods(state.data?.length);

//           return ActionTile(
//             title: context.localization.payment_methods_339713993,
//             titleStyle: context.theme.textStyle(
//               textStyle: TextStyles.body1,
//               color: context.theme.colors.prominent,
//             ),
//             subtitleText:
//                 paymentMethodsName.isEmpty ? null : paymentMethodsName,
//             subtitleStyle: context.theme.textStyle(
//               textStyle: TextStyles.caption,
//               color: context.theme.colors.lessProminent,
//             ),
//             isExtended: true,
//             backgroundColor: context.theme.colors.primary,
//             onTap: _onPaymentMethodTap,
//           );
//         },
//       );

//   String _paymentMethods(int? paymentMethodsLength) {
//     if (paymentMethodsLength == null) {
//       return '';
//     }

//     if (_selectedPaymentMethods.length == paymentMethodsLength) {
//       return context.localization.all_911417976;
//     }

//     return _selectedPaymentMethods
//         .map((PaymentMethod item) => item.displayName)
//         .join(', ');
//   }

//   Future<void> _onPaymentMethodTap() async {
//     final List<PaymentMethod>? selectedPaymentMethods =
//         await Navigator.of(context).push(
//       MaterialPageRoute<List<PaymentMethod>>(
//         builder: (BuildContext context) => PaymentMethodSelector(
//           isMultiSelector: true,
//           isPage: true,
//           backgroundColor: context.theme.colors.primary,
//           appBarTitle: context.localization.payment_methods_339713993,
//           selectedItems: _selectedPaymentMethods.toList(),
//           hasLimitedSelection: false,
//         ),
//       ),
//     );

//     if (selectedPaymentMethods != null) {
//       setState(() {
//         _selectedPaymentMethods
//           ..clear()
//           ..addAll(selectedPaymentMethods);
//       });
//     }
//   }

//   AppBar _buildAppBar() => AppBar(
//         elevation: 0,
//         centerTitle: false,
//         title: Text(context.localization.filter_253508699),
//         backgroundColor: context.theme.colors.secondary,
//         actions: <Widget>[_buildResetAction()],
//       );

//   Widget _buildResetAction() => IconButton(
//         icon: Image.asset(Assets.resetIcon),
//         tooltip: context.localization.reset_733807558,
//         onPressed: () {
//           setState(() {
//             _selectedPaymentMethods.clear();
//             _matchAdsFilter = false;
//           });
//         },
//       );
// }
