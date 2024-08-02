part of 'city_bloc.dart';

abstract class CityState extends Equatable {
  @override
  List<Object> get props => [];
}

class CityInitial extends CityState {}

class CityLoading extends CityState {}

class CityLoaded extends CityState {
  final String city;

  CityLoaded(this.city);

  @override
  List<Object> get props => [city];
}

class CityError extends CityState {
  final String errorMessage;

  CityError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
