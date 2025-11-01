part of 'autocomplete_bloc.dart';

abstract class AutocompleteState extends Equatable {
  const AutocompleteState();
  @override
  List<Object> get props => [];
}

class AutocompleteInitial extends AutocompleteState {}

class AutocompleteLoading extends AutocompleteState {}

class AutocompleteLoaded extends AutocompleteState {
  final AutoCompleteResponse response;
  const AutocompleteLoaded(this.response);
  @override
  List<Object> get props => [response];
}

class AutocompleteError extends AutocompleteState {
  final String message;
  const AutocompleteError(this.message);
  @override
  List<Object> get props => [message];
}
