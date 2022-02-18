// ignore_for_file: avoid_positional_boolean_parameters

import 'package:deriv_p2p_practice_project/api/models/advert.dart';
import 'package:deriv_p2p_practice_project/api/models/selectable_item_model.dart';
import 'package:deriv_p2p_practice_project/enums.dart';
import 'package:deriv_p2p_practice_project/features/core/helpers/advert_list_cubit_pref_helper.dart';
import 'package:deriv_p2p_practice_project/features/core/helpers/sort_pref_helper.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/sort/sort_controller.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/advert_list/advert_list_cubit.dart';

import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_cubit.dart';

import 'package:deriv_p2p_practice_project/features/selectable_items/presentation/widgets/radio_list_sheet.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// RootPage which manages connection listening point
class AdvertList extends StatefulWidget {
  /// Initialise RootPage
  const AdvertList({Key? key}) : super(key: key);

  @override
  _AdvertListPageState createState() => _AdvertListPageState();
}

class _AdvertListPageState extends State<AdvertList>
    with SingleTickerProviderStateMixin {
  int pageCount = 0;
  // ignore: unused_field
  bool _shouldShowSortAlert = false;
  final ScrollController _scrollController = ScrollController();

  final SortController _sortController = SortController();
  late final AdvertListCubit _advertListCubit;

  int selectedTabIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_setActiveTabIndex);
    _advertListCubit = AdvertListCubit(
        pingCubit: BlocProvider.of<PingCubit>(context), pageCount: 10);
    onRefreshPage(false);
    _scrollController.addListener(_onScrollLoadMore);
    _checkSortValue();
    super.initState();
  }

  void _setActiveTabIndex() {
    selectedTabIndex = _tabController.index;
    setCounterpartyType(
        // ignore: avoid_bool_literals_in_conditional_expressions
        isCounterpartyTypeSell: selectedTabIndex == 0 ? false : true);
  }

  void _onScrollLoadMore() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        setState(() {
          pageCount += 1;
        });

        onRefreshPage(false);
        //add api for load the more data according to new page
      });
    }
  }

  void onRefreshPage(bool isloadMore) {
    _advertListCubit.fetchAdverts(isloadMore, false, pageCount);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: _buildAppBar(),
          body: TabBarView(controller: _tabController, children: <Widget>[
            buildAdvertListView(),
            buildAdvertListView(),
          ])));

  // ignore: prefer_expression_function_bodies
  Widget buildAdvertListView() {
    return BlocBuilder<AdvertListCubit, AdvertListState>(
      bloc: _advertListCubit,
      builder: (BuildContext context, AdvertListState state) {
        if (state is AdvertListLoadedState) {
          return listViewAdvert(state.adverts, state.hasRemaining);
        } else if (state is AdvertListLoadingState) {
          return progressIndicator();
        } else if (state is AdvertListErrorState) {
          return progressIndicator();
        } else {
          return progressIndicator();
        }
      },
    );
  }

  AppBar _buildAppBar() => AppBar(
        title: const Text('P2P Practice Project'),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          // ignore: prefer_const_literals_to_create_immutables
          tabs: <Widget>[
            const Tab(text: 'Buy'),
            const Tab(text: 'Sell'),
          ],
          onTap: (int value) {
            setState(() {
              pageCount = 0;
            });
            onRefreshPage(true);
          },
        ),
        actions: <Widget>[_buildSortAction()],
      );
  Widget _buildSortAction() => IconButton(
        icon: Stack(
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            const Icon(Icons.sort),
          ],
        ),
        tooltip: 'Sort',
        onPressed: _openSortOptions,
      );
  Future<void> _checkSortValue() async {
    final bool isSortDefault =
        await getUserAdvertSortTypeIndex() == AdvertSortType.rate.index;

    setState(() {
      _shouldShowSortAlert = !isSortDefault;
    });
  }

  Future<void> _openSortOptions() async {
    CupertinoAlertDialog(
        title: const Text('Sort'),
        actions: <Widget>[
          CupertinoDialogAction(
              onPressed: () {
                onRefreshPage(false);
              },
              child: const Text('Exchange rate (Default)')),
          CupertinoDialogAction(
              onPressed: () {
                onRefreshPage(false);
              },
              child: const Text('Completion rate')),
        ],
        content: const Text('Saved successfully'));

    // final int userStashedSortIndex = await getUserAdvertSortTypeIndex();

    // await showModalBottomSheet<void>(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   builder: (BuildContext context) => RadioListSheet(
    //     title: 'Sort by',
    //     data: _getFilters(
    //       context: context,
    //       userStashedSortIndex: userStashedSortIndex,
    //     ),
    //     onChanged: (int index) {
    //       _sortController.onSortSelected != null
    //           // ignore: unnecessary_statements
    //           ? (AdvertSortType.values[index])
    //           // ignore: unnecessary_statements
    //           : (AdvertSortType.values[index]);

    //       setState(() {
    //         _shouldShowSortAlert = index != AdvertSortType.rate.index;
    //       });
    //       onRefreshPage(false);
    //     },
    //   ),
    // );
  }

  // List<SelectableItemModel> _getFilters({
  //   required BuildContext context,
  //   int? userStashedSortIndex,
  // }) =>
  //     <SelectableItemModel>[
  //       SelectableItemModel(
  //         id: AdvertSortType.rate.index,
  //         title: 'Exchange rate (Default)',
  //         selected: userStashedSortIndex == AdvertSortType.rate.index,
  //       ),
  //       SelectableItemModel(
  //         id: AdvertSortType.completion.index,
  //         title: 'Completion rate',
  //         selected: userStashedSortIndex == AdvertSortType.completion.index,
  //       ),
  //     ];

  // ignore: avoid_positional_boolean_parameters
  Widget listViewAdvert(List<Advert> adverts, bool loadMore) =>
      ListView.builder(
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: loadMore ? adverts.length + 1 : adverts.length,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            if (index >= adverts.length) {
              return progressIndicator();
            } else {
              final Advert item = adverts[index];

              return Card(
                color: Colors.grey.shade900,
                elevation: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    textWidget(
                      'Advertise Name : ${item.advertiserDetails?.name ?? item.advertiserDetails?.firstName}',
                    ),
                    textWidget(
                      'Account Currency : ${item.accountCurrency}',
                    ),
                    textWidget(
                      'Completion Rate : ${item.advertiserDetails!.totalCompletionRate == null ? '' : item.advertiserDetails!.totalCompletionRate}',
                    ),
                    textWidget(
                      'Price : ${item.price}',
                    ),
                    textWidget(
                      'Description : ${item.description}',
                    ),
                  ],
                ),
              );
            }
          });

  // ignore: prefer_expression_function_bodies
  Widget progressIndicator() => const Center(
        child:
            SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
      );

  Widget textWidget(String text) => Padding(
      padding: const EdgeInsets.all(8),
      // ignore: lines_longer_than_80_chars
      child: Text(text,
          style: const TextStyle(fontSize: 14, color: Colors.white)));
}
