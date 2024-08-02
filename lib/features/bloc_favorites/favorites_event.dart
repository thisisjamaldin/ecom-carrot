part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();
}

final class LoadFavoritesEvent extends FavoritesEvent {
  const LoadFavoritesEvent({
    required this.limit,
    required this.token,
  });

  final String limit;
  final String token;

  @override
  List<Object?> get props => [
        limit,
        token,
      ];
}

final class DeleteFavoriteEvent extends FavoritesEvent {
  const DeleteFavoriteEvent({
    required this.limit,
    required this.token,
    required this.id,
  });

  final String limit;
  final String token;
  final String id;

  @override
  List<Object?> get props => [
        limit,
        token,
        id,
      ];
}

final class AddFavoriteEvent extends FavoritesEvent {
  const AddFavoriteEvent({
    required this.limit,
    required this.token,
    required this.productId,
  });

  final String limit;
  final String token;
  final String productId;

  @override
  List<Object?> get props => [
    limit,
    token,
    productId,
  ];
}

