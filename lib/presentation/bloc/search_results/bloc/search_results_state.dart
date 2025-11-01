part of 'search_results_bloc.dart';

abstract class SearchResultsState extends Equatable {
  const SearchResultsState();
  @override
  List<Object> get props => [];
}

class SearchResultsInitial extends SearchResultsState {}

class SearchResultsLoading extends SearchResultsState {}

class SearchResultsLoaded extends SearchResultsState {
  final List<Hotel> hotels;
  final bool hasReachedMax;

  const SearchResultsLoaded({required this.hotels, this.hasReachedMax = false});

  SearchResultsLoaded copyWith({List<Hotel>? hotels, bool? hasReachedMax}) {
    return SearchResultsLoaded(hotels: hotels ?? this.hotels, hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  List<Object> get props => [hotels, hasReachedMax];
}

class SearchResultsError extends SearchResultsState {
  final String message;
  const SearchResultsError(this.message);
  @override
  List<Object> get props => [message];
}
