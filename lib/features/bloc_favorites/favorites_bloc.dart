import 'package:bloc/bloc.dart';
import 'package:russsia_carrot/data/model/favorites_model.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:equatable/equatable.dart';

part 'favorites_event.dart';

part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc(this.repository) : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>(_loadFavorites);
    on<DeleteFavoriteEvent>(_deleteFavorite);
    on<AddFavoriteEvent>(_addFavorite);
  }

  final AbstractRepository repository;

  Future<void> _addFavorite(
    AddFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      if (state is! FavoritesLoaded) {
        emit(FavoritesLoading());
      }
      await repository.addFavorites(event.productId, event.token);
      final FavoritesModel favoritesProducts = await repository.fetchFavorites(
        event.limit,
        event.token,
      );
      emit(FavoritesLoaded(favoritesProducts: favoritesProducts));
    } catch (e) {
      emit(FavoritesErrorState(e));
    }
  }

  Future<void> _deleteFavorite(
    DeleteFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      if (state is! FavoritesLoaded) {
        emit(FavoritesLoading());
      }

      await repository.deleteFavorites(event.id, event.token);
      final FavoritesModel favoritesProducts = await repository.fetchFavorites(
        event.limit,
        event.token,
      );

      emit(FavoritesLoaded(favoritesProducts: favoritesProducts));
    } catch (e) {
      emit(FavoritesErrorState(e));
    }
  }

  Future<void> _loadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      if (state is! FavoritesLoaded) {
        emit(FavoritesLoading());
      }
      final FavoritesModel favoritesProducts = await repository.fetchFavorites(
        event.limit,
        event.token,
      );
      emit(FavoritesLoaded(favoritesProducts: favoritesProducts));
    } catch (e) {
      emit(FavoritesErrorState(e));
    }
  }
}
