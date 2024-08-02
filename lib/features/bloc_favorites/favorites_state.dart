part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => throw UnimplementedError();
}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded({required this.favoritesProducts});

  final FavoritesModel favoritesProducts;

  @override
  List<Object?> get props => [favoritesProducts];
}

final class FavoritesErrorState extends FavoritesState {
  const FavoritesErrorState(this.exception);

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
