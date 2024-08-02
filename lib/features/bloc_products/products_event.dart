part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();
}

final class LoadProductsEvent extends ProductsEvent {
  const LoadProductsEvent({
    required this.limit,
    required this.token,
  });

  final int limit;
  final String token;

  @override
  List<Object?> get props => [limit, token];
}

final class OwnerProductsEvent extends ProductsEvent {
  const OwnerProductsEvent({
    required this.limit,
    required this.token,
    required this.owner,
  });

  final String limit;
  final String token;
  final String owner;

  @override
  List<Object?> get props => [limit, token, owner];
}

final class FindProductEvent extends ProductsEvent {
  FindProductEvent({
    required this.token,
    required this.searchText,
  });

  final String token;
  String searchText;

  @override
  List<Object?> get props => [token, searchText];
}

final class SelectCategoryEvent extends ProductsEvent {
  SelectCategoryEvent({
    required this.limit,
    required this.token,
    required this.category,
  });

  final String token;
  final int limit;
  String category;

  @override
  List<Object?> get props => [token, category];
}
