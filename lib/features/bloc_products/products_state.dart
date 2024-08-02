part of 'products_bloc.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => throw UnimplementedError();
}

final class ProductsInitial extends ProductsState {}

final class ProductsLoading extends ProductsState {}

final class ProductsFind extends ProductsState {
  const ProductsFind({required this.productsModel});

  final ProductsModel productsModel;

  @override
  List<Object?> get props => [productsModel];
}

final class ProductsLoaded extends ProductsState {
  const ProductsLoaded({required this.productsModel});

  final ProductsModel productsModel;

  @override
  List<Object?> get props => [productsModel];
}

final class ProductsErrorState extends ProductsState {
  const ProductsErrorState(this.exception);

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
