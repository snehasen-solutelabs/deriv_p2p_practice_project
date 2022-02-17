import 'package:bloc_test/bloc_test.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_cubit.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/pingService/ping_state.dart';
import 'package:flutter_test/flutter_test.dart';

class MockPingCubitBloc extends MockBloc<PingCubit, PingState>
    implements PingCubit {}

void main() {
  late PingCubit mockAdvertListBloc;

  setUp(() {
    mockAdvertListBloc = MockPingCubitBloc();
    // searchSortCubit = SearchCubit(mockAdvertListBloc);
  });

  group('Test SearchSortCubit ', () {});

  tearDown(() {
    mockAdvertListBloc.close();
  });
}
