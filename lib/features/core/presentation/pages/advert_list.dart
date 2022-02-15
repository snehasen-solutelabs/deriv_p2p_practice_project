import 'package:deriv_p2p_practice_project/api/response/advert.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/advert_list/advert_list_cubit.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Advert Listing Page
class AdvertListPage extends StatefulWidget {
  /// Initialise AdvertListPage
  const AdvertListPage({Key? key}) : super(key: key);

  /// Route Page route name.
  static const String routeName = 'advert_list_page';

  @override
  _AdvertListPageState createState() => _AdvertListPageState();
}

class _AdvertListPageState extends State<AdvertListPage> {
  final ScrollController _scrollController = ScrollController();
  final advertListCubit = AdvertListCubit();
  final pingCubit = DerivPingCubit();
  void _onScroll() {
    if (_scrollController.position.maxScrollExtent !=
        _scrollController.offset) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    print("pingCubit.binaryApi");
    // print(pingCubit.binaryApi);

    advertListCubit.fetchAdverts();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Deriv p2p Practice Project')),
      body: BlocBuilder<AdvertListCubit, AdvertListState>(
        bloc: advertListCubit,
        builder: (BuildContext context, AdvertListState state) {
          if (state is AdvertListLoadedState) {
            return listViewUsers(state.adverts);
          } else if (state is AdvertListLoadingState) {
            return CircularProgressIndicator();
          } else if (state is AdvertListErrorState) {
            return CircularProgressIndicator();
          } else {
            return CircularProgressIndicator();
          }
        },
      ));
  // Scaffold(
  //     body: BlocBuilder(

  //       bloc:cubit,

  //         child: BlocConsumer<AdvertListCubit, AdvertListState>(
  //           listener: (context, state) {
  //             if (state is AdvertListLoadingState) {
  //               print("getting users ...");
  //             } else if (state is AdvertListLoadedState) {
  //               print(state.adverts);
  //             } else if (state is AdvertListErrorState) {
  //               print(state.errorMessage);
  //             }
  //           },
  //           builder: (BuildContext context, AdvertListState state) {
  //             return Stack(
  //               children: [
  //                 (state is AdvertListLoadedState)
  //                     ? listViewUsers(state.adverts)
  //                     : CircularProgressIndicator(),
  //               ],
  //             );
  //           },
  //         )));
}

Widget listViewUsers(List<Advert> adverts) {
  return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: adverts.length,
      //controller: _scrollController,
      itemBuilder: (BuildContext context, int index) {
        if (index >= adverts.length) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final Advert item = adverts[index];

          return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item.advertiserDetails?.name ?? ''),
                  const SizedBox(height: 8),
                  Text(item.description ?? ''),
                  const SizedBox(height: 8),
                  Text('$index : ID : ${item.id}'),
                  const SizedBox(height: 8),
                  Text('Amount : ${item.amountDisplay}'),
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey, blurRadius: 6, spreadRadius: 2)
                  ]));
        }
      });

  // )}}

  // BlocProvider(
  //   create: (context) {
  //     final cubit = AdvertListCubit();
  //     cubit.fetchAdverts();
  //     return cubit;
  //   },
  //   child: Builder(builder: (context) {
  //     return BlocBuilder<AdvertListCubit, AdvertListState>(
  //         builder: (BuildContext context, AdvertListState state) {

  //       dev.log('currentstate : $state');
  //     if (state is AdvertListLoadingState) {
  //       return const Center(child: CircularProgressIndicator());
  //     } else if (state is AdvertListLoadedState) {
  //       return ListView.builder(
  //           shrinkWrap: true,
  //           physics: const BouncingScrollPhysics(),
  //           itemCount: state.hasRemaining
  //               ? state.adverts.length + 1
  //               : state.adverts.length,
  //           controller: _scrollController,
  //           itemBuilder: (BuildContext context, int index) {
  //             if (index >= state.adverts.length) {
  //               return const Center(child: CircularProgressIndicator());
  //             } else {
  //               final Advert item = state.adverts[index];

  //               return Container(
  //                   margin: const EdgeInsets.symmetric(
  //                       horizontal: 16, vertical: 8),
  //                   padding: const EdgeInsets.symmetric(
  //                       horizontal: 16, vertical: 12),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       Text(item.advertiserDetails?.name ?? ''),
  //                       const SizedBox(height: 8),
  //                       Text(item.description ?? ''),
  //                       const SizedBox(height: 8),
  //                       Text('$index : ID : ${item.id}'),
  //                       const SizedBox(height: 8),
  //                       Text('Amount : ${item.amountDisplay}'),
  //                     ],
  //                   ),
  //                   decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(4),
  //                       boxShadow: const <BoxShadow>[
  //                         BoxShadow(
  //                             color: Colors.grey,
  //                             blurRadius: 6,
  //                             spreadRadius: 2)
  //                       ]));
  //               // _buildAdvertListItems(state.adverts, index, context)
  //             }

  //         });
  //   }}
  // );

  //     BlocBuilder<AdvertListCubit, AdvertListState>(
  //   bloc: _advertListCubit,
  //   builder: (BuildContext context, AdvertListState state) {
  //     dev.log('currentstate : $state');
  //     if (state is AdvertListLoadingState) {
  //       return const Center(child: CircularProgressIndicator());
  //     } else if (state is AdvertListLoadedState) {
  //       return ListView.builder(
  //           shrinkWrap: true,
  //           physics: const BouncingScrollPhysics(),
  //           itemCount: state.hasRemaining
  //               ? state.adverts.length + 1
  //               : state.adverts.length,
  //           controller: _scrollController,
  //           itemBuilder: (BuildContext context, int index) {
  //             if (index >= state.adverts.length) {
  //               return const Center(child: CircularProgressIndicator());
  //             } else {
  //               final Advert item = state.adverts[index];

  //               return Container(
  //                   margin: const EdgeInsets.symmetric(
  //                       horizontal: 16, vertical: 8),
  //                   padding: const EdgeInsets.symmetric(
  //                       horizontal: 16, vertical: 12),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       Text(item.advertiserDetails?.name ?? ''),
  //                       const SizedBox(height: 8),
  //                       Text(item.description ?? ''),
  //                       const SizedBox(height: 8),
  //                       Text('$index : ID : ${item.id}'),
  //                       const SizedBox(height: 8),
  //                       Text('Amount : ${item.amountDisplay}'),
  //                     ],
  //                   ),
  //                   decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(4),
  //                       boxShadow: const <BoxShadow>[
  //                         BoxShadow(
  //                             color: Colors.grey,
  //                             blurRadius: 6,
  //                             spreadRadius: 2)
  //                       ]));
  //               // _buildAdvertListItems(state.adverts, index, context)
  //             }
  //           });
  //       // return const Center(child: Text('Advert List'));
  //     } else {
  //       return Center(child: Text('connecting... : $state'));
  //     }
  //   },
  // )
}
