import 'package:deriv_p2p_practice_project/api/models/advert.dart';
import 'package:deriv_p2p_practice_project/api/models/selectable_item_model.dart';
import 'package:deriv_p2p_practice_project/enums.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/advert_list/advert_list_cubit.dart';

import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_cubit.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_state.dart';
import 'package:deriv_p2p_practice_project/widget/tab_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// RootPage which manages connection listening point
class Dashboard extends StatefulWidget {
  /// Initialise RootPage
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<Dashboard>
    with TickerProviderStateMixin {
  bool isSell = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<State<StatefulWidget>>? _searchPageTabBarKey = GlobalKey();
  late final PingCubit _pingCubit;
  late final AdvertListCubit _advertListCubit;
  int selectedTabIndex = 0;
  late TabController tabController;
  bool _shouldShowSortAlert = false;
  bool _shouldShowFilterAlert = false;
  @override
  void initState() {
    _pingCubit = PingCubit();
    _pingCubit.initWebSocket();

    _advertListCubit = AdvertListCubit(pingCubit: _pingCubit);

    _scrollController.addListener(_onScrollLoadMore);

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {
        selectedTabIndex = tabController.index;
      });
    });

    super.initState();
  }

  void _updateSwitchEvent(int value) {
    setState(() {
      isSell = value == AdvertType.sell.index;
    });
  }

  void _onScrollLoadMore() {
    if (_scrollController.position.maxScrollExtent !=
        _scrollController.offset) {
      return;
    }
    _advertListCubit..fetchAdverts();
  }

  @override
  void dispose() {
    _pingCubit.close();
    _advertListCubit.close();
    super.dispose();
  }

  Widget advertWidget() => BlocBuilder<AdvertListCubit, AdvertListState>(
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
        // )
      );

  Widget _buildBuySellTab(bool isSell) => Center(
        child: DefaultTabBar(
          color: Colors.blue,
          length: 2,
          tabBarKey: _searchPageTabBarKey,
          tabs: [
            Tab(
              text: "Buy",
            ),
            Tab(
              text: "Sell",
            ),
          ],
          onTap: (int value) => _updateSwitchEvent(value),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("Deriv P2P Practice"),
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<PingCubit, PingState>(
        bloc: _pingCubit,
        builder: (BuildContext context, PingState state) {
          if (state is PingLoadedState) {
            _advertListCubit..fetchAdverts();
            return advertWidget();
          } else if (state is PingLoadingState) {
            return ProgressIndicator();
          } else if (state is PingErrorState) {
            return ProgressIndicator();
          } else {
            return ProgressIndicator();
          }
        },
      ));

  Widget listViewAdvert(List<Advert> adverts, bool loadMore) => Column(
        children: <Widget>[
          _buildBuySellTab(isSell),
          Expanded(
              child: ListView.builder(
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
                              'Country : ${item.country}',
                            ),
                            TextWidget(
                              'Type : ${item.counterpartyType}',
                            ),
                            TextWidget(
                              'Description : ${item.description}',
                            ),
                          ],
                        ),
                      );
                    }
                  }))
        ],
      );

  Widget ProgressIndicator() {
    return Center(
      child:
          SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
    );
  }

  Widget TextWidget(String text) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: TextStyle(fontSize: 12, color: Colors.black)),
      );

  // void _setSelectedPageIndex(int index) {
  //   setState(() {
  //     _selectedPageIndex = index;
  //   });
  // }

  // AppBar _buildAppBar() => AppBar(
  //       elevation: 0,
  //       centerTitle: false,
  //       actions: _selectedPageIndex == 0
  //           ? <Widget>[_buildFilterAction(), _buildSortAction()]
  //           : null,
  //     );

  // Widget _buildFilterAction() => IconButton(
  //       icon: Stack(
  //         children: <Widget>[
  //           const Icon(Icons.filter_list),
  //         ],
  //       ),

  //       // onPressed: _openFilterOptions,
  //       onPressed: () => _onFilterTapped(),
  //     );

  // Future<void> _onFilterTapped() async {
  //   final bool? shouldFilter = await Navigator.of(context).push(
  //     MaterialPageRoute<bool>(
  //       builder: (BuildContext context) => FilterPage(
  //         filterController: _filterController,
  //       ),
  //     ),
  //   );

  //   if (shouldFilter != null) {
  //     setState(() => _shouldShowFilterAlert = shouldFilter);
  //   }
  // }

  // Widget _buildSortAction() => IconButton(
  //       icon: Stack(
  //         children: <Widget>[
  //           // const Icon(Icons.filter_list),
  //           Icon(Icons.sort),
  //         ],
  //       ),
  //       onPressed: _openSortOptions,
  //     );

  // Future<void> _openSortOptions() async {
  //   final int userStashedSortIndex = await getUserAdvertSortTypeIndex();

  //   await showModalBottomSheet<void>(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) => RadioListSheet(
  //       title: Localization.of(context).sort_by_795061793,
  //       data: _getFilters(
  //         context: context,
  //         userStashedSortIndex: userStashedSortIndex,
  //       ),
  //       onChanged: (int index) {
  //         _sortController.onSortSelected!(AdvertSortType.values[index]);

  //         setState(() {
  //           _shouldShowSortAlert = index != AdvertSortType.rate.index;
  //         });
  //       },
  //     ),
  //   );
  // }

  //   List<SelectableItemModel> _getFilters({
  //     required BuildContext context,
  //     int? userStashedSortIndex, }) =>
  //       <SelectableItemModel>[
  //         SelectableItemModel(
  //           id: AdvertSortType.rate.index,
  //           title: "Exchange rate (Default)",
  //           selected: userStashedSortIndex == AdvertSortType.rate.index,
  //         ),
  //         SelectableItemModel(
  //           id: AdvertSortType.completion.index,
  //           title: 'Completion rate',
  //           selected: userStashedSortIndex == AdvertSortType.completion.index,
  //         ),
  //       ];
  // }

}