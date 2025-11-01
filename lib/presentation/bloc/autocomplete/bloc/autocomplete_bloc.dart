import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mytravaly/data/repositories/hotel_repo.dart';
import 'package:mytravaly/model/autocomplete_model.dart';
import 'package:rxdart/rxdart.dart';

part 'autocomplete_event.dart';
part 'autocomplete_state.dart';

class AutocompleteBloc extends Bloc<AutocompleteEvent, AutocompleteState> {
  final HotelRepository hotelRepository;

  AutocompleteBloc({required this.hotelRepository}) : super(AutocompleteInitial()) {
    on<FetchAutocompleteSuggestions>(
      _onFetchSuggestions,
      transformer: (events, mapper) => events.debounceTime(const Duration(milliseconds: 300)).switchMap(mapper),
    );
    on<ClearAutocomplete>(_onClear);
  }

  Future<void> _onFetchSuggestions(FetchAutocompleteSuggestions event, Emitter<AutocompleteState> emit) async {
    if (event.query.isEmpty) {
      emit(AutocompleteInitial());
      return;
    }
    emit(AutocompleteLoading());
    try {
      final response = await hotelRepository.searchHotels(query: event.query, page: 1);
      emit(AutocompleteLoaded(response));
    } catch (e) {
      emit(AutocompleteError(e.toString()));
    }
  }

  void _onClear(ClearAutocomplete event, Emitter<AutocompleteState> emit) {
    emit(AutocompleteInitial());
  }
}
