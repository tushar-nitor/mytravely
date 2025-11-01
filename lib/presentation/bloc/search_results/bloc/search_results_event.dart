part of 'search_results_bloc.dart';

abstract class SearchResultsEvent extends Equatable {
  const SearchResultsEvent();
  @override
  List<Object> get props => [];
}

class SearchHotels extends SearchResultsEvent {
  final List<String> searchQuery;
  final String searchType;
  const SearchHotels({required this.searchQuery, required this.searchType});
  @override
  List<Object> get props => [searchQuery, searchType];
}

class LoadMoreHotels extends SearchResultsEvent {
  final List<String> searchQuery;
  final String searchType;
  const LoadMoreHotels({required this.searchQuery, required this.searchType});
  @override
  List<Object> get props => [searchQuery, searchType];
}
