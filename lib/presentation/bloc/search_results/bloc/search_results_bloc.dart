import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mytravaly/data/repositories/hotel_repo.dart';
import 'package:mytravaly/model/hotel_model.dart';

part 'search_results_event.dart';
part 'search_results_state.dart';

class SearchResultsBloc extends Bloc<SearchResultsEvent, SearchResultsState> {
  final HotelRepository hotelRepository;
  int _page = 1;

  SearchResultsBloc({required this.hotelRepository}) : super(SearchResultsInitial()) {
    on<SearchHotels>(_onSearchHotels);
    on<LoadMoreHotels>(_onLoadMoreHotels);
  }

  Future<void> _onSearchHotels(SearchHotels event, Emitter<SearchResultsState> emit) async {
    _page = 1;
    emit(SearchResultsLoading());
    try {
      final hotels = await hotelRepository.getHotelSearchResults(
        searchQuery: event.searchQuery,
        searchType: event.searchType,
        page: _page,
      );
      emit(SearchResultsLoaded(hotels: hotels, hasReachedMax: hotels.isEmpty));
    } catch (e) {
      emit(SearchResultsError(e.toString()));
    }
  }

  Future<void> _onLoadMoreHotels(LoadMoreHotels event, Emitter<SearchResultsState> emit) async {
    final currentState = state;
    if (currentState is SearchResultsLoaded && !currentState.hasReachedMax) {
      _page++;
      try {
        final newHotels = await hotelRepository.getHotelSearchResults(
          searchQuery: event.searchQuery,
          searchType: event.searchType,
          page: _page,
        );
        if (newHotels.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(currentState.copyWith(hotels: List.of(currentState.hotels)..addAll(newHotels)));
        }
      } catch (e) {
        emit(SearchResultsError(e.toString()));
      }
    }
  }
}
