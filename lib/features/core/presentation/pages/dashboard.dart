import 'package:deriv_p2p_practice_project/api/models/advert.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/advert_list/advert_list_cubit.dart';

import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_cubit.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// RootPage which manages connection listening point
class Dashboard extends StatefulWidget {
  /// Initialise RootPage
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("Deriv P2P Practice"),
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(create: (context) {
        final cubit = DerivPingCubit();
        cubit.initWebSocket();
        return cubit;
      }, child: BlocBuilder<DerivPingCubit, PingState>(
        builder: (BuildContext context, PingState state) {
          if (state is PingLoadedState) {
            return advertWidget(context.read<DerivPingCubit>());
          } else if (state is PingLoadingState) {
            return ProgressIndicator();
          } else if (state is PingErrorState) {
            return ProgressIndicator();
          } else {
            return ProgressIndicator();
          }
        },
      )));
}

Widget advertWidget(DerivPingCubit pingCubit) {
  return BlocProvider(create: (context) {
    final cubit = AdvertListCubit(pingCubit: pingCubit);
    cubit.fetchAdverts();
    return cubit;
  }, child: BlocBuilder<AdvertListCubit, AdvertListState>(
    builder: (BuildContext context, AdvertListState state) {
      if (state is AdvertListLoadedState) {
        return listViewAdvert(state.adverts);
      } else if (state is AdvertListLoadingState) {
        return ProgressIndicator();
      } else if (state is AdvertListErrorState) {
        return ProgressIndicator();
      } else {
        return ProgressIndicator();
      }
    },
  ));
}

Widget listViewAdvert(List<Advert> adverts) {
  return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: adverts.length,
      //controller: _scrollController,
      itemBuilder: (BuildContext context, int index) {
        if (index >= adverts.length) {
          return ProgressIndicator();
        } else {
          final Advert item = adverts[index];

          return Container(
              // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${item.advertiserDetails?.firstName ?? item.advertiserDetails?.name} ${item.advertiserDetails?.lastName ?? ''}",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Account Currency : ${item.accountCurrency}',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
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
}

Widget ProgressIndicator() {
  return Center(
    child: CircularProgressIndicator(),
  );
}
