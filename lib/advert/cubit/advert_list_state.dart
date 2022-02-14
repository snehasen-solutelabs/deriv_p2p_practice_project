part of 'advert_list_cubit.dart';

/// Advert list states.
abstract class AdvertListState {}

/// Advert list initial state.
class AdvertListInitialState extends AdvertListState {
  @override
  String toString() => 'AdvertListState(AdvertListInitialState)';
}

/// Advert list fetch failed state.
class AdvertListFetchFailedState extends AdvertListState {
  final String error;

  AdvertListFetchFailedState({required this.error});

  @override
  String toString() =>
      'AdvertListState(AdvertListFetchFailedState(Error: $error))';
}

/// ??
class NotAdvertiserErrorState extends AdvertListState {
  @override
  String toString() => 'AdvertListState(NotAdvertiserErrorState)';
}

/// When the user is in the Sell tab on `SearchPage` and she sends a new search request. The
/// sell page should be shown to the user. [shouldNavigate] is used to figure out this situation
/// and navigates to the sell tab.
///
/// [sortBy] shows the order of showing [adverts].
///
/// [searchQuery] shows the name that user has just searched.
///
/// [filterByClientLimits] shows whether the app should shows [adverts] by client limits or not.
class AdvertListLoadedState extends AdvertListState {
  final List<Advert> adverts;
  final bool isSell;
  final bool hasRemaining;

  final APIError? error;
  final String? advertiserStatsId;
  final bool? filterByClientLimits;

  final String? searchQuery;
  final bool shouldNavigate;

  AdvertListLoadedState({
    required this.adverts,
    required this.isSell,
    required this.hasRemaining,
    this.advertiserStatsId,
    this.error,
    this.filterByClientLimits,
    this.searchQuery,
    this.shouldNavigate = false,
  });

  AdvertListLoadedState copyWith({
    List<Advert>? adverts,
    bool? isSell,
    bool? hasRemaining,
    APIError? error,
    String? advertiserStatsId,
    bool? filterByClientLimits,
    String? searchQuery,
  }) =>
      AdvertListLoadedState(
        adverts: adverts ?? this.adverts,
        isSell: isSell ?? this.isSell,
        hasRemaining: hasRemaining ?? this.hasRemaining,
        error: error,
        advertiserStatsId: advertiserStatsId ?? this.advertiserStatsId,
        filterByClientLimits: filterByClientLimits ?? this.filterByClientLimits,
        searchQuery: searchQuery ?? this.searchQuery,
      );

  @override
  String toString() =>
      'AdvertListState(AdvertListLoadedState(adverts: ${adverts.length}, isSell: $isSell, hasRemaining: $hasRemaining, error: $error))';
}

/// Updating advert type state (when user move between buy/sell tabs).
class UpdatingAdvertTypeState extends AdvertListState {
  final bool isSell;
  final String? advertiserStatId;

  UpdatingAdvertTypeState({
    required this.isSell,
    required this.advertiserStatId,
  });

  @override
  String toString() =>
      ' isSell: $isSell, advertiserRatingId: $advertiserStatId))';
}

/// ??
class AdvertRatingErrorState extends AdvertListState {
  final String? error;

  AdvertRatingErrorState({
    this.error,
  });

  @override
  String toString() => 'AdvertListState(AdvertRatingErrorState(error: $error))';
}
