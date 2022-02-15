import 'package:deriv_p2p_practice_project/features/states/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_deriv_api/basic_api/generated/ping_receive.dart';
import 'package:flutter_deriv_api/basic_api/generated/ping_send.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/binary_api.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/connection_information.dart';

class ApiConnectionCubit extends Cubit<BaseState<bool>> {
  ApiConnectionCubit() : super(const BaseState<bool>());

  Future<void> adverts() async {
    final BinaryAPI api = BinaryAPI(UniqueKey());

    ConnectionInformation _connectionInformation = ConnectionInformation(
        appId: "1089", brand: "deriv", endpoint: "frontend.binaryws.com");

    await api.connect(
      _connectionInformation,
      onDone: (_) => print("done"),
      onOpen: (_) => print("done"),
      onError: (_) => print("done"),
    );

    final PingResponse response =
        await api.call<PingResponse>(request: PingRequest());
    print(response.toJson());
  }
}
