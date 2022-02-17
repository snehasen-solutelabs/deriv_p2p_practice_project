import 'package:deriv_p2p_practice_project/features/core/presentation/pages/advert_list.dart';

import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_cubit.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// RootPage which manages connection listening point
class Connection extends StatefulWidget {
  /// Initialise RootPage
  const Connection({Key? key}) : super(key: key);

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<Connection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,

        // Here connecting to Ping cubit (ping cubit will initialize Binary api and also authorize user token)
        body: MultiBlocProvider(
          providers: [
            BlocProvider<PingCubit>(
                create: (BuildContext context) => PingCubit()..initWebSocket())
          ],
          child: BlocBuilder<PingCubit, PingState>(
            builder: (BuildContext context, PingState state) {
              if (state is PingLoadedState) {
                // if connection established then move to advert palistge widget
                return AdvertList();
              } else if (state is PingLoadingState) {
                return ProgressIndicator();
              } else if (state is PingErrorState) {
                // if error return text with message
                return Text(state.errorMessage);
              } else {
                return ProgressIndicator();
              }
            },
          ),
        ),
      );

  Widget ProgressIndicator() {
    return Center(
      child:
          SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
    );
  }
}