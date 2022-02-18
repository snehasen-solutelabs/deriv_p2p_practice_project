import 'package:bloc_test/bloc_test.dart';
import 'package:deriv_p2p_practice_project/api/binary_api_wrapper.dart';

import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_cubit.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_state.dart';

import 'package:flutter_test/flutter_test.dart';

class MockPingCubit extends MockCubit<PingCubit> implements PingState {
  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    // TODO: implement addError
  }

  @override
  // TODO: implement binaryApi
  BinaryAPIWrapper get binaryApi => throw UnimplementedError();

  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  Future<void> initWebSocket() {
    // TODO: implement initWebSocket
    throw UnimplementedError();
  }

  @override
  // TODO: implement isClosed
  bool get isClosed => throw UnimplementedError();

  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: implement onError
  }

  void main() {
    late PingCubit mockAdvertListBloc;

    setUp(() {
      mockAdvertListBloc = MockPingCubit() as PingCubit;
    });

    group('Test SearchSortCubit ', () {});

    tearDown(() {
      mockAdvertListBloc.close();
    });
  }
}
