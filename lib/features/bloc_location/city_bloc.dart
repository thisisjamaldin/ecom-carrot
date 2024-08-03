// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:russsia_carrot/repository/abstract_repository.dart';

// part 'city_event.dart';
// part 'city_state.dart';

// class CityBloc extends Bloc<CityEvent, CityState> {
//   CityBloc(this.repository) : super(CityInitial()) {
//     on<FetchCity>(_fetchCity);
//   }

//   final AbstractRepository repository;

//   Future<void> _fetchCity(
//       FetchCity event,
//       Emitter<CityState> emit,
//       ) async {
//     emit(CityLoading());

//     try {
//       final city = await repository.getCityName(event.position);
//       emit(CityLoaded(city));
//     } catch (e) {
//       emit(CityError('Ошибка при получении города: $e'));
//     }
//   }
// }
