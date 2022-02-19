import 'package:bloc_test/bloc_test.dart';
import 'package:deriv_p2p_practice_project/api/models/advert.dart';
import 'package:deriv_p2p_practice_project/core/states/pingService/ping_cubit.dart';
import 'package:deriv_p2p_practice_project/features/presentation/states/advert_list/advert_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAdvertListCubit extends MockCubit<AdvertListState>
    implements AdvertListCubit {}

class FakeAdvertListState extends Fake implements AdvertListState {}

void main() {
  late PingCubit pingCubit;
  late AdvertListCubit advertListCubit;

  setUpAll(() async {
    registerFallbackValue(FakeAdvertListState());

    pingCubit = PingCubit();
    await pingCubit.initWebSocket();
    advertListCubit = AdvertListCubit(pingCubit: pingCubit);
  });

  group('advert list cubit test () => ', () {
    final Exception exception = Exception('advert list cubit exception.');
    blocTest<AdvertListCubit, AdvertListState>(
        'captures exceptions => (advert_list_cubit).',
        build: () => AdvertListCubit(pingCubit: pingCubit),
        act: (AdvertListCubit cubit) => cubit.addError(exception),
        errors: () => <Matcher>[equals(exception)]);

    blocTest<AdvertListCubit, AdvertListState>(
      'should fetch advert list with these states () =>',
      build: () => advertListCubit,
      verify: (AdvertListCubit cubit) async {
        expect(cubit.state, isA<AdvertListLoadingState>());
        await expectLater(cubit.state, isA<AdvertListLoadedState>());
        final AdvertListLoadedState currentState =
            cubit.state as AdvertListLoadedState;
        expect(currentState, isA<AdvertListLoadedState>());

        expect(currentState.adverts, isNotNull);
        expect(currentState.adverts, isA<List<Advert>>());
      },
      act: (AdvertListCubit a) => a.fetchAdverts(isPeriodic: false),
      expect: () => <dynamic>[
        isA<AdvertListLoadingState>(),
        isA<AdvertListLoadedState>(),
      ],
    );
  });
}
