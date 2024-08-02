part of 'city_bloc.dart';

abstract class CityEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCity extends CityEvent {
  final Position position;

  FetchCity(this.position);

  @override
  List<Object> get props => [position];
}
