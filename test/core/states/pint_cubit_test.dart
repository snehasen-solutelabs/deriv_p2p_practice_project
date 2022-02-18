import 'package:bloc_test/bloc_test.dart';
import 'package:deriv_p2p_practice_project/api/binary_api_wrapper.dart';
import 'package:deriv_p2p_practice_project/core/states/pingService/ping_cubit.dart';
import 'package:deriv_p2p_practice_project/core/states/pingService/ping_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_deriv_api/api/api_initializer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPingCubit extends MockCubit<PingState> implements PingCubit {}

class FakePingState extends Mock implements PingState {}

void main() {
  late MockPingCubit mockPingCubit;
  setUpAll(() {
    registerFallbackValue(FakePingState());

    mockPingCubit = MockPingCubit();
  });

  group('Ping cubit Connection test', () {
    final Exception connectionException = Exception('ping cubit exception.');

    blocTest<PingCubit, PingState>(
      ' ping cubit captures all exceptions => (ping_cubit).',
      build: () => PingCubit(),
      act: (PingCubit cubit) => cubit.addError(connectionException),
      errors: () => <Matcher>[equals(connectionException)],
    );
    test('test Mock Ping Cubit', () async {
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
      'should fetch deriv ping with expect states () =>',
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
