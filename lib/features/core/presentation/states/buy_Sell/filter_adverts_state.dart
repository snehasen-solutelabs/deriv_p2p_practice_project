// part of 'filter_adverts_cubit.dart';

// /// Filter adverts states.
// @immutable
// abstract class FilterAdvertsState extends Equatable {
//   const FilterAdvertsState();

//   @override
//   List<Object?> get props => [];
// }

// /// Filter adverts initial state
// class FilterAdvertsInitialState extends FilterAdvertsState {
//   const FilterAdvertsInitialState();

//   @override
//   String toString() => 'FilterAdvertsState(FilterAdvertsInitialState)';
// }

// /// Filter adverts loading state
// class FilterAdvertsLoadingState extends FilterAdvertsState {
//   const FilterAdvertsLoadingState();

//   @override
//   String toString() => 'FilterAdvertsState(FilterAdvertsLoadingState)';
// }

// /// Filter adverts loaded state
// class FilterAdvertsLoadedState extends FilterAdvertsState {
//   final bool? filterByClientLimits;

//   const FilterAdvertsLoadedState({this.filterByClientLimits});

//   @override
//   String toString() =>
//       'FilterAdvertsState(FilterAdvertsLoadedState(use client limits: $filterByClientLimits))';

//   @override
//   List<bool?> get props => [filterByClientLimits];
// }

// /// UseClientLimits failed state.
// class FilterAdvertsFailedState extends FilterAdvertsState {
//   final String error;

//   const FilterAdvertsFailedState(this.error);

//   @override
//   List<String> get props => [error];

//   @override
//   String toString() => 'FilterAdvertsState(FilterAdvertsFailedState($error))';
// }
