part of 'popular_hotels_bloc.dart';

abstract class PopularHotelsEvent extends Equatable {
  const PopularHotelsEvent();
  @override
  List<Object> get props => [];
}

class FetchPopularHotels extends PopularHotelsEvent {}
