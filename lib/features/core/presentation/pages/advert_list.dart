import 'package:deriv_p2p_practice_project/api/models/advert.dart';
import 'package:deriv_p2p_practice_project/api/models/selectable_item_model.dart';
import 'package:deriv_p2p_practice_project/enums.dart';
import 'package:deriv_p2p_practice_project/features/core/helpers/advert_list_cubit_pref_helper.dart';
import 'package:deriv_p2p_practice_project/features/core/helpers/sort_pref_helper.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/sort/sort_controller.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/advert_list/advert_list_cubit.dart';

import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_cubit.dart';

import 'package:deriv_p2p_practice_project/features/selectable_items/presentation/widgets/radio_list_sheet.dart';

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
  bool _shouldShowSortAlert = false;
  final ScrollController _scrollController = ScrollController();

  final SortController _sortController = SortController();
  late final AdvertListCubit _advertListCubit;

  int selectedTabIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_setActiveTabIndex);
    _advertListCubit =
        AdvertListCubit(pingCubit: BlocProvider.of<PingCubit>(context));
    onRefreshPage(false);
    _scrollController.addListener(_onScrollLoadMore);
    _checkSortValue();
    super.initState();
  }

  void _setActiveTabIndex() {
    selectedTabIndex = _tabController.index;
    setCounterpartyType(
        isCounterpartyTypeSell: selectedTabIndex == 0 ? false : true);
  }

  void _onScrollLoadMore() {
    if (_scrollController.position.maxScrollExtent !=
        _scrollController.offset) {
      return;
    }
    onRefreshPage(false);
  }

  onRefreshPage(bool isloadMore) {
    _advertListCubit..fetchAdverts(isloadMore, false);
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

  Widget buildAdvertListView() {
    return BlocBuilder<AdvertListCubit, AdvertListState>(
      bloc: _advertListCubit,
      builder: (BuildContext context, AdvertListState state) {
        if (state is AdvertListLoadedState) {
          return listViewAdvert(state.adverts, state.hasRemaining);
        } else if (state is AdvertListLoadingState) {
          return ProgressIndicator();
        } else if (state is AdvertListErrorState) {
          return ProgressIndicator();
        } else {
          return ProgressIndicator();
        }
      },
    );
  }

  AppBar _buildAppBar() => AppBar(
        title: Text("P2P Practice Project"),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Buy"),
            Tab(text: "Sell"),
          ],
          onTap: (value) {
            onRefreshPage(true);
          },
        ),
        actions: <Widget>[_buildSortAction()],
      );
  Widget _buildSortAction() => IconButton(
        icon: Stack(
          children: <Widget>[
            const Icon(Icons.sort),
          ],
        ),
        tooltip: "Sort",
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
    final int userStashedSortIndex = await getUserAdvertSortTypeIndex();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => RadioListSheet(
        title: 'Sort by',
        data: _getFilters(
          context: context,
          userStashedSortIndex: userStashedSortIndex,
        ),
        onChanged: (int index) {
          _sortController.onSortSelected != null
              ? (AdvertSortType.values[index])
              : (AdvertSortType.values[index]);

          setState(() {
            _shouldShowSortAlert = index != AdvertSortType.rate.index;
          });
          onRefreshPage(false);
        },
      ),
    );
  }

  List<SelectableItemModel> _getFilters({
    required BuildContext context,
    int? userStashedSortIndex,
  }) =>
      <SelectableItemModel>[
        SelectableItemModel(
          id: AdvertSortType.rate.index,
          title: "Exchange rate (Default)",
          selected: userStashedSortIndex == AdvertSortType.rate.index,
        ),
        SelectableItemModel(
          id: AdvertSortType.completion.index,
          title: 'Completion rate',
          selected: userStashedSortIndex == AdvertSortType.completion.index,
        ),
      ];

  Widget listViewAdvert(List<Advert> adverts, bool loadMore) =>
      ListView.builder(
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: loadMore ? adverts.length + 1 : adverts.length,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            if (index >= adverts.length) {
              return ProgressIndicator();
            } else {
              final Advert item = adverts[index];

              return Card(
                color: Colors.grey.shade900,
                elevation: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      "Advertise Name : ${item.advertiserDetails?.name ?? item.advertiserDetails?.firstName}",
                    ),
                    TextWidget(
                      'Account Currency : ${item.accountCurrency}',
                    ),
                    TextWidget(
                      'Completion Rate : ${item.advertiserDetails!.totalCompletionRate == null ? "" : item.advertiserDetails!.totalCompletionRate}',
                    ),
                    TextWidget(
                      'Price : ${item.price}',
                    ),
                    TextWidget(
                      'Description : ${item.description}',
                    ),
                  ],
                ),
              );
            }
          });

  Widget ProgressIndicator() {
    return Center(
      child:
          SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
    );
  }

  Widget TextWidget(String text) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: TextStyle(fontSize: 14, color: Colors.white)),
      );
}
