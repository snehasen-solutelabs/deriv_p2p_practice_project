import 'package:deriv_p2p_practice_project/api/models/advert.dart';
import 'package:deriv_p2p_practice_project/core/states/pingService/ping_cubit.dart';
import 'package:deriv_p2p_practice_project/features/presentation/states/advert_list/advert_list_cubit.dart';
import 'package:deriv_p2p_practice_project/features/presentation/widget/list_items.dart';
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
  final ScrollController _scrollController = ScrollController();

  late final AdvertListCubit _advertListCubit;

  int selectedTabIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    //tab controller sell and buy initialization
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_setActiveTabIndex);

    //init advert cubit
    _advertListCubit =
        AdvertListCubit(pingCubit: BlocProvider.of<PingCubit>(context));

    onRefreshPage();
    //adding listner to perform pagination by list view
    _scrollController.addListener(_onScrollLoadMore);
    super.initState();
  }

//get selected tab
  void _setActiveTabIndex() {
    selectedTabIndex = _tabController.index;
    _advertListCubit
        .toggleCounterTypeOption(selectedTabIndex == 1 ? 'buy' : 'sell');
    onRefreshPage();
  }

//pagination on scroll state
  void _onScrollLoadMore() {
    if (_scrollController.position.maxScrollExtent !=
        _scrollController.offset) {
      return;
    }
    onRefreshPage();
  }

  /// call advert cubit fetch function
  void onRefreshPage() {
    //caling advert list
    _advertListCubit.fetchAdverts(isPeriodic: false);
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

  ///advert list block builder and communicate with advert Cubit
  Widget buildAdvertListView() => BlocBuilder<AdvertListCubit, AdvertListState>(
        bloc: _advertListCubit,
        builder: (BuildContext context, AdvertListState state) {
          if (state is AdvertListLoadedState) {
            return listViewAdvert(
                adverts: state.adverts,
                loadMore: state.hasRemaining,
                isPeriodic: state.isPeriodic);
          } else if (state is AdvertListLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdvertListErrorState) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );

//App bar
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
            _setActiveTabIndex();
          },
        ),
        actions: <Widget>[_buildSortAction()],
      );

  //Sort button
  Widget _buildSortAction() => IconButton(
        icon: const Icon(Icons.sort),
        tooltip: 'Sort',
        onPressed: onClickSortOption,
      );

// list view for showing buy and sell adverts
  Future<void> onClickSortOption() async {
    await showDialog<bool>(
        context: context,
        // ignore: prefer_expression_function_bodies
        builder: (BuildContext context) {
          return Center(
            child: CupertinoAlertDialog(
                title: const Text('Sort'),
                actions: <Widget>[
                  CupertinoDialogAction(
                      onPressed: () {
                        // exchange rate selection
                        _advertListCubit.toggleSortOption(0);
                        Navigator.pop(context);
                      },
                      child: const Text('Exchange rate (Default)')),
                  CupertinoDialogAction(
                      onPressed: () {
                        // completion rate selection
                        _advertListCubit.toggleSortOption(1);

                        Navigator.pop(context);
                      },
                      child: const Text('Completion rate')),
                ],
                content: const Text('Select an option')),
          );
        });
  }

  // list view for showing buy and sell adverts
  Widget listViewAdvert(
          {required List<Advert> adverts,
          required bool loadMore,
          required bool isPeriodic}) =>
      ListView.builder(
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: loadMore ? adverts.length + 1 : adverts.length,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            if (index >= adverts.length) {
              return isPeriodic
                  ? const Text('')
                  : const Center(child: CircularProgressIndicator());
            } else {
              final Advert item = adverts[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[ListItems(item: item)],
              );
            }
          });

  @override
  void dispose() {
    _advertListCubit.close();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
