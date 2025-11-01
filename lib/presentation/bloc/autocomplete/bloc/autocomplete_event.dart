part of 'autocomplete_bloc.dart';

abstract class AutocompleteEvent extends Equatable {
  const AutocompleteEvent();
  @override
  List<Object> get props => [];
}

class FetchAutocompleteSuggestions extends AutocompleteEvent {
  final String query;
  const FetchAutocompleteSuggestions(this.query);
  @override
  List<Object> get props => [query];
}

class ClearAutocomplete extends AutocompleteEvent {}
