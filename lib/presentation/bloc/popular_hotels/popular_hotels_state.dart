part of 'popular_hotels_bloc.dart';

abstract class PopularHotelsState extends Equatable {
  const PopularHotelsState();
  @override
  List<Object> get props => [];
}

class PopularHotelsInitial extends PopularHotelsState {}

class PopularHotelsLoading extends PopularHotelsState {}

class PopularHotelsLoaded extends PopularHotelsState {
  final List<Hotel> hotels;
  const PopularHotelsLoaded(this.hotels);
  @override
  List<Object> get props => [hotels];
}

class PopularHotelsError extends PopularHotelsState {
  final String message;
  const PopularHotelsError(this.message);
  @override
  List<Object> get props => [message];
}
