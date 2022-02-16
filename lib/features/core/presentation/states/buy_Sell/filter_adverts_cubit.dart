// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:deriv_p2p_practice_project/features/core/presentation/states/advert_list/advert_list_cubit.dart';
// import 'package:deriv_p2p_practice_project/features/core/presentation/states/buy_Sell/adverts_filter_pref_helper.dart';
// import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
// import 'package:rxdart/rxdart.dart';

// part 'filter_adverts_state.dart';

// /// [FilterAdvertsCubit] is used for filter option. It will filter the Advert
// /// list with @useClientLimits parameter.
// class FilterAdvertsCubit extends Cubit<FilterAdvertsState> {
//   /// It listens to the [advertListBloc] and emits `FilterAdvertsState` if the
//   /// AdvertState is AdvertLoaded.
//   /// It will also stash the value of the useClientLimits if useClientLimits is
//   /// not null. (when user is tapping the useClientLimits switch button).
//   FilterAdvertsCubit(this.advertListBloc)
//       : super(const FilterAdvertsInitialState()) {
//     advertBlocSubscription = advertListBloc.stream
//         .startWith(AdvertListInitialState())
//         .listen((AdvertListState state) async {
//       if (state is AdvertListLoadedState) {
//         emit(FilterAdvertsLoadedState(
//           filterByClientLimits:
//               state.filterByClientLimits ?? await getFilterByClientLimits(),
//         ));
//       }
//     });
//   }

//   /// AdvertListBloc instance.
//   final AdvertListCubit advertListBloc;

//   /// AdvertList subscription.
//   StreamSubscription<AdvertListState>? advertBlocSubscription;

//   /// Send a fetch request for getting advert list.
//   /// It just emits [FilterAdvertsLoadingState] when [filterByClientLimits]
//   /// parameter is not null (means user is tapping the useClientLimits switch
//   /// button).
//   Future<void> filterAdverts({
//     bool? filterByClientLimits,
//   }) async {
//     emit(const FilterAdvertsLoadingState());

//     advertListBloc.fetchAdverts(
//       shouldRefresh: true,
//       shouldSort: true,
//       filterByClientLimits: filterByClientLimits,
//     );
//   }

//   @override
//   Future<void> close() async {
//     await advertBlocSubscription?.cancel();

//     return super.close();
//   }
// }
