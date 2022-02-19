import 'package:bloc_test/bloc_test.dart';
import 'package:deriv_p2p_practice_project/api/binary_api_wrapper.dart';
import 'package:deriv_p2p_practice_project/core/states/pingService/ping_cubit.dart';
import 'package:deriv_p2p_practice_project/core/states/pingService/ping_state.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPingCubit extends MockCubit<PingState> implements PingCubit {}

class FakePingState extends Fake implements PingState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePingState());
  });

  group('ping cubit test1 () => ', () {
    final Exception exception = Exception('ping cubit exception.');
    blocTest<PingCubit, PingState>(
      ' ping cubit captures exceptions => (ping_cubit).',
      build: () => PingCubit(),
      act: (PingCubit cubit) => cubit.addError(exception),
      errors: () => <Matcher>[equals(exception)],
    );

    test('test2 with mock data', () async {
      final MockPingCubit pingCubit = MockPingCubit();

      whenListen(
          pingCubit,
          Stream<PingState>.fromIterable(<PingState>[
            PingInitialState(),
            PingLoadingState(),
            PingLoadedState(api: BinaryAPIWrapper(uniqueKey: UniqueKey()))
          ]));

      await expectLater(
          pingCubit.stream,
          emitsInOrder(<dynamic>[
            isA<PingInitialState>(),
            isA<PingLoadingState>(),
            isA<PingLoadedState>(),
          ]));

      final PingLoadedState currentState = pingCubit.state as PingLoadedState;
      expect(currentState, isA<PingLoadedState>());

      expect(currentState.api, isNotNull);
      expect(currentState.api, isA<BinaryAPIWrapper>());
    });

    final MockPingCubit mockPingCubit = MockPingCubit();
    blocTest<MockPingCubit, PingState>(
      'should fetch ping with expect states () =>',
      build: () => mockPingCubit,
      verify: (MockPingCubit cubit) async {
        expect(cubit.state, isA<PingLoadingState>());
        await expectLater(cubit.state, isA<PingLoadedState>());
        final PingLoadedState currentState = cubit.state as PingLoadedState;
        expect(currentState, isA<PingLoadedState>());

        expect(currentState.api, isNotNull);
        expect(currentState.api, isA<BinaryAPIWrapper>());
      },
      act: (PingCubit a) => a.initWebSocket(),
      expect: () => <dynamic>[
        isA<PingLoadingState>(),
        isA<PingLoadedState>(),
      ],
    );
  });
}
