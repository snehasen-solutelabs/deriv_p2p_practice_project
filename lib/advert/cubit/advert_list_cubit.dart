import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:deriv_p2p_practice_project/advert/cubit/advert.dart';
import 'package:deriv_p2p_practice_project/api/api_error.dart';
import 'package:deriv_p2p_practice_project/connection/deriv_connection_cubit.dart';
import 'package:meta/meta.dart';

import 'package:rxdart/rxdart.dart';

part 'advert_list_event.dart';

part 'advert_list_state.dart';

/// This class handles business logic related to the advert list (e.g.
/// `Fetching advert list` and `removing item from advert list`).
class AdvertListCubit extends Cubit<AdvertListState> {
  final DerivConnectionCubit connectioncubit;
  
  StreamSubscription? _streamSubscription;
  

  static const int _itemsPerPage = 50;

  AdvertListCubit({
    required this.connectioncubit,

   
  }) : super(AdvertListInitialState()) {
   
    if (advertiserBloc != null) {
      _streamSubscription = advertiserBloc!.stream
          .startWith(advertiserBloc!.state)
          .listen((AdvertiserState advertiserState) {
        if (advertiserState is AdvertiserLoaded &&
            state is! AdvertListLoadedState) {
          _advertiser = advertiserState.advertiser;
          emit(FetchAdvertListEvent(
            onlyFetchAdvertiserAdverts: true,
            shouldRefresh: true,
          ));
        }
      });
    } else {
      _streamSubscription = accountBloc.stream
          .startWith(accountBloc.state)
          .listen((AccountState accountState) {
        if (accountState is AccountLoaded && state is! AdvertListLoadedState) {
          add(FetchAdvertListEvent(
            shouldRefresh: true,
            shouldSort: true,
            shouldFilter: true,
          ));
        }
      });
    }

    

  @override
  Stream<Transition<AdvertListEvent, AdvertListState>> transformEvents(
    Stream<AdvertListEvent> events,
    TransitionFunction<AdvertListEvent, AdvertListState> next,
  ) =>
      super.transformEvents(
        events.debounceTime(const Duration(milliseconds: 50)),
        next,
      );

  @override
  Stream<AdvertListState> mapEventToState(
    AdvertListEvent event,
  ) async* {
    dev.log('Event $event with currently remaining as ${_hasRemaining(state)}');

    // Check connection status before fetching adverts because when connection
    // status is disconnected this event will be called and because some of
    // needed data are null (like advertiser) it goes to improper states.

    if (event is FetchAdvertListEvent && connectionCubit.state is Connected) {
      dev.log('fetch requested.');

      if (event.onlyFetchAdvertiserAdverts) {
        yield NotAdvertiserErrorState();
      }

      try {
        if (state is AdvertListInitialState || event.shouldRefresh) {
          bool _isSell;
        
          if (event.shouldRefresh && state is AdvertListLoadedState) {
           
            _isSell = event.isSell ?? (state as AdvertListLoadedState).isSell;
          } else {
            _isSell = event.isSell ?? false;
          }

        
          final List<Advert>? adverts = await _fetchAdverts(
            isSell: _isSell,
            onlyFetchAdvertiserAdverts: event.onlyFetchAdvertiserAdverts,
            start: 0,
            advertiserId: event.advertiserId,
            count: _itemsPerPage,
            shouldFilter: event.shouldFilter,
            filterByClientLimits: event.filterByClientLimits,
          
            isSearching: event.isSearching,
            searchQuery: event.searchQuery,
          );

          if (adverts != null) {
            yield AdvertListLoadedState(
             
              adverts: adverts,
              hasRemaining: adverts.length >= _itemsPerPage,
              isSell: _isSell,
              advertiserStatsId: event.advertiserId,
              filterByClientLimits: event.filterByClientLimits,
             
              searchQuery: event.searchQuery,
              shouldNavigate:
                  event.searchQuery != null && isSavedCounterpartySell,
            );
          }
        } else if (state is AdvertListLoadedState &&
            (_hasRemaining(state) || event.isPeriodic)) {
          final AdvertListLoadedState state =
              this.state as AdvertListLoadedState;

          if (event.advertiserId == state.advertiserStatsId) {
            final List<Advert>? adverts = await _fetchAdverts(
             
              count: event.isPeriodic
                  ? math.max(state.adverts.length, _itemsPerPage)
                  : _itemsPerPage,
              onlyFetchAdvertiserAdverts: event.onlyFetchAdvertiserAdverts,
              advertiserId: event.advertiserId,
              shouldFilter: event.shouldFilter,
              filterByClientLimits: event.filterByClientLimits,
             
              isSearching: event.isSearching,
              searchQuery: event.searchQuery,
            );
            if (adverts != null) {
              yield adverts.isEmpty
                  ? state.copyWith(hasRemaining: false)
                  : state.copyWith(
                      adverts:
                          event.isPeriodic ? adverts : state.adverts + adverts,
                      hasRemaining: adverts.length % _itemsPerPage == 0,
                      isSell: event.isSell,
                      filterByClientLimits: event.filterByClientLimits,
                      paymentMethods: event.paymentMethods,
                      sortBy: event.sortBy,
                      searchQuery: event.searchQuery,
                    );
            }
          }
        }
      } on Exception catch (error) {
        dev.log('Fetch adverts error', error: error);
        yield AdvertListInitialState();
      }
    } else if (event is SwitchAdvertType) {
      final AdvertListState advertState = state;

      if (advertState is AdvertListLoadedState &&
          advertState.isSell != event.isSell) {
        try {
          // If user navigates to the sell tab in Buy/Sell page, we should save
          // the counterparty type in order to search by correct counterparty type
          // when user wants to search.
          if (event.advertiserStatsId == null) {
          
          }

      
          final List<Advert>? adverts = await _fetchAdverts(
            isSell: event.isSell,
            start: 0,
            count: _itemsPerPage,
            onlyFetchAdvertiserAdverts: event.onlyFetchAdvertiserAdverts,
            advertiserId: (state as UpdatingAdvertTypeState).advertiserStatId,
            
            shouldFilter: event.shouldFilter,
            filterByClientLimits: advertState.filterByClientLimits,
           
            isSearching: event.isSearching,
            searchQuery: advertState.searchQuery,
          );

          if (adverts != null) {
            yield AdvertListLoadedState(
              adverts: adverts,
              hasRemaining: adverts.length % _itemsPerPage == 0,
              isSell: event.isSell,
             
              advertiserStatsId: event.advertiserStatsId,
              filterByClientLimits: event.filterByClientLimits,
              
              searchQuery: advertState.searchQuery,
            );
          }
        } on Exception catch (error) {
          dev.log('Switch type of advert error', error: error);
          yield AdvertListInitialState();
        }
      }
    }  else if (event is FetchAdvertListErrorEvent) {
      yield AdvertListFetchFailedState(error: event.error);
    } else if (event is FetchAdvertStatsEvent) {
      yield (state as AdvertListLoadedState)
          .copyWith(advertiser: event.advertiser);

      emit(FetchAdvertListEvent);
    } else if (event is FetchAdvertStatsErrorEvent) {
      yield AdvertRatingErrorState(error: event.error);
    }  else if (event is AdvertListUninitializedEvent) {
      yield AdvertListInitialState();
    }
  }

  bool _hasRemaining(AdvertListState state) =>
      state is AdvertListInitialState ||
      (state is AdvertListLoadedState && state.hasRemaining);

  Future<List<Advert>?> _fetchAdverts({
    required bool isSell,
    int? start,
    int? count,
    bool onlyFetchAdvertiserAdverts = false,
    String? advertiserId,
    bool? shouldFilter,
    bool? filterByClientLimits,
  
    bool? isSearching,
    String? searchQuery,
  }) async {
    dev.log('asking for $count adverts from $start.');

    List<Advert> adverts = <Advert>[];
    final DerivConnectionState connectionState = ConnectionCubit.state;
    final AccountState accountState = accountBloc.state;

    try {
      if (connectionState is Connected && accountState is AccountLoaded) {
        final String responseKey = onlyFetchAdvertiserAdverts
            ? 'p2p_advertiser_adverts'
            : 'p2p_advert_list';
        Map<String, dynamic> response;

        if (onlyFetchAdvertiserAdverts) {
          response = await connectionState.api
              .p2pAdvertiserAdverts(limit: count, offset: start)
              .timeout(const Duration(seconds: 15));
        } else {
          String counterpartyType = 'buy';

          if (isSearching! && await isCounterpartyTypeSell()) {
            counterpartyType = 'sell';
          } else {
            counterpartyType = isSell ? 'sell' : 'buy';
          }

   
          response = await connectionState.api
              .p2pAdvertList(
               
              )
              .timeout(const Duration(seconds: 15));
        }

        if (response['error'] == null) {
          response[responseKey]['list'].forEach(
            (dynamic response) => adverts.add(Advert.fromMap(response)),
          );


          if (sortBy != null) await setUserAdvertSortTypeIndex(sortBy.index);

          if (searchQuery != null && searchQuery.isNotEmpty) {
            await setUserSearchedHistory(searchQuery);
          }

          if (filterByClientLimits != null) {
            await setFilterByClientLimits(
                filterByClientLimits: filterByClientLimits);
          }

         

          return adverts;
        }

        emit(FetchAdvertListErrorEvent(error: response['error']['message']));
      }

      return adverts;
    } on Exception catch (_) {
      emit(AdvertListUninitializedEvent());
    }
  }


  /// Get the latest user sort option.
  Future<AdvertSortType> get _latestSortOption async =>
      AdvertSortType.values[await getUserAdvertSortTypeIndex()];

  /// Get the saved value of filter adverts by client limits.
  Future<bool> get _savedFilterByClientLimits => getFilterByClientLimits();

 

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
  
    return super.close();
  }
}
}