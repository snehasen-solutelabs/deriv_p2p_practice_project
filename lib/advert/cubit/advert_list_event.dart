// part of 'advert_list_cubit.dart';

// /// Advert list events.
// @immutable
// abstract class AdvertListEvent {}

// /// When the user is in the Sell tab on `SearchPage` and she sends a new search request. The
// /// sell page should be shown to the user. [shouldNavigate] is used to figure out this situation
// /// and navigates to the sell tab.
// ///
// /// In some situation we need sort adverts without the user changes sort option in the
// /// `Buy/Sell` page. Or sometimes we need to use latest search query to get adverts without
// /// the user sends new search query. In these cases [sortBy], [searchQuery], or [filterByClientLimits]
// /// will be null. So we should figure out whether we should use latest sort, search, or filter option
// /// or not. [shouldSort], [isSearching], and [shouldFilter] variables are used for that purpose.
// ///
// /// [sortBy] shows the order that user wants to see adverts.
// ///
// /// [searchQuery] shows the name that user is searching for.
// ///
// /// [filterByClientLimits] shows whether the user wants to see adverts by her or his limits or not.
// class FetchAdvertListEvent extends AdvertListEvent {
//   final bool? isSell;
//   final bool isPeriodic;
//   final bool onlyFetchAdvertiserAdverts;
//   final double? initAmount;
//   final bool shouldRefresh;
//   final String? advertiserId;
//   final bool shouldFilter;
//   final bool? filterByClientLimits;

//   final bool shouldSort;

//   final bool? isSearching;
//   final String? searchQuery;
//   final bool shouldNavigate;

//   FetchAdvertListEvent({
//     this.isSell,
//     this.isPeriodic = false,
//     this.onlyFetchAdvertiserAdverts = false,
//     this.initAmount,
//     this.shouldRefresh = false,
//     this.advertiserId,
//     this.shouldFilter = false,
//     this.filterByClientLimits,
//     this.shouldSort = false,
//     this.isSearching = false,
//     this.searchQuery,
//     this.shouldNavigate = false,
//   });

//   @override
//   String toString() => 'AdvertListEvent(FetchAdvertListEvent)';
// }

// /// Fetch advert list error event.
// class FetchAdvertListErrorEvent extends AdvertListEvent {
//   final String error;

//   FetchAdvertListErrorEvent({required this.error});

//   @override
//   String toString() => 'AdvertListEvent(FetchAdvertListErrorEvent($error))';
// }

// /// Fetch advert stats error event.
// class FetchAdvertStatsErrorEvent extends AdvertListEvent {
//   final String? error;

//   FetchAdvertStatsErrorEvent({this.error});

//   @override
//   String toString() => 'AdvertListEvent(FetchAdvertStatsErrorEvent($error))';
// }

// /// Advert list uninitialized event.
// class AdvertListUninitializedEvent extends AdvertListEvent {
//   @override
//   String toString() => 'AdvertListEvent(AdvertListUninitializedEvent())';
// }
