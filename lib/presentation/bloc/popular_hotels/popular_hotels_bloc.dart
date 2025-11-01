import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mytravaly/data/repositories/hotel_repo.dart';
import 'package:mytravaly/model/hotel_model.dart';

part 'popular_hotels_event.dart';
part 'popular_hotels_state.dart';

class PopularHotelsBloc extends Bloc<PopularHotelsEvent, PopularHotelsState> {
  final HotelRepository hotelRepository;

  PopularHotelsBloc({required this.hotelRepository}) : super(PopularHotelsInitial()) {
    on<FetchPopularHotels>(_onFetchPopularHotels);
  }

  Future<void> _onFetchPopularHotels(FetchPopularHotels event, Emitter<PopularHotelsState> emit) async {
    emit(PopularHotelsLoading());
    try {
      final List<Hotel> hotels = await hotelRepository.fetchPopularHotels();
      emit(PopularHotelsLoaded(hotels));
    } catch (e) {
      emit(PopularHotelsError(e.toString()));
    }
  }
}
