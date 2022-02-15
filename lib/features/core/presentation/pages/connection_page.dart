import 'package:deriv_p2p_practice_project/features/core/presentation/states/connection_state/connection_cubit.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_cubit.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'advert_list.dart';

/// RootPage which manages connection listening point
class ConnectionPage extends StatefulWidget {
  /// Initialise RootPage
  const ConnectionPage({Key? key}) : super(key: key);

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final pingCubit = DerivPingCubit();
  final connectionCubit = ConnectionCubit();
  @override
  void initState() {
    pingCubit.initWebSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: BlocBuilder<DerivPingCubit, PingState>(
        bloc: pingCubit,
        builder: (BuildContext context, PingState state) {
          if (state is PingLoadedState) {
            connectionCubit.onConnectionSetup(state.api);
            return const AdvertListPage();
          } else if (state is PingLoadingState) {
            return _buildCenterText('Connecting...');
          } else if (state is PingErrorState) {
            return _buildCenterText(state.errorMessage);
          } else {
            return _buildCenterText('connection lost');
          }
        },
      ));
  //   BlocProvider(
  // create: (context) {
  //       final cubit = DerivPingCubit();
  //       cubit.initWebSocket();
  //       return cubit;
  //     },
  // child:
  //  Builder(builder: (context) {
  //       return BlocBuilder<DerivPingCubit, PingState>(
  //         builder: (context, state) {
  //           return BlocListener<DerivPingCubit, PingState>(
  //                     listener: (context, state) {
  //                       if (state is PingLoadingState) {
  //                         print("getting users ...");
  //                       } else if (state is PingLoadedState) {
  //                         return
  //                       } else if (state is PingErrorState) {
  //                         print(state.errorMessage);
  //                       }
  //                       else{
  //                       print(state);
  //                       }
  //                   });
  //         },
  //       );
  //  })
  //   ));
  //  MaterialApp(
  //   title: 'Flutter Demo',
  //   theme: ThemeData(
  //     primarySwatch: Colors.blue,
  //   ),
  //   home: UsersPage(),
  // ),
  //));

  // BlocProvider(
  //   create: (context) {
  //     final cubit = DerivPingCubit();
  //     cubit.initWebSocket();
  //     return cubit;
  //   },
  //   child: Builder(builder: (context) {
  //     return BlocConsumer<DerivPingCubit, PingState>(
  //       listener: (context, state) {
  //         if (state is PingLoadingState) {
  //           print("getting users ...");
  //         } else if (state is PingLoadedState) {
  //           print("loaded");
  //         } else if (state is PingErrorState) {
  //           print(state.errorMessage);
  //         }
  //       },
  //       builder: (context, state) {
  //         return const AdvertListPage();
  //       },
  //     );
  //   }),
  // ),
  // body: BlocBuilder<DerivPingCubit, DerivPingState>(
  //   bloc: _derivPingCubit,
  //   builder: (BuildContext context, DerivPingState state) {
  //     if (state is DerivPingLoadedState) {
  //       return const AdvertListPage();
  //     } else if (state is DerivPingLoadingState) {
  //       return const CenterTextWidget(title: 'Connecting...');
  //     } else if (state is DerivPingErrorState) {
  //       return CenterTextWidget(title: 'State\n${state.errorMessage}');
  //     }

  //     return Container();
  //   },
  // ),
  // );
}

Widget _buildCenterText(String text) => Center(
      child: Text(text),
    );
