part of 'advert_list_cubit.dart';

/// Base state for adverts
abstract class AdvertListState {}

/// adverts initial state
class AdvertListInitialState extends AdvertListState {}

/// adverts loading state
class AdvertListLoadingState extends AdvertListState {}

/// adverts loaded state
class AdvertListLoadedState extends AdvertListState {
  /// Init State
  AdvertListLoadedState(
      {required this.adverts,
      required this.hasRemaining,
      required this.isPeriodic});

  /// adverts list
  final List<Advert> adverts;

  /// hasRemaining
  bool hasRemaining;

  // ignore: public_member_api_docs
  bool isPeriodic;
}

/// adverts error state
class AdvertListErrorState extends AdvertListState {
  /// Initializes
  AdvertListErrorState(this.errorMessage);

  /// Error message
  final String errorMessage;
}
