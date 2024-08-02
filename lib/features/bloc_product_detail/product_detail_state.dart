part of 'product_detail_bloc.dart';

sealed class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => throw UnimplementedError();
}

final class ProductDetailInitial extends ProductDetailState {}

final class ProductDetailLoading extends ProductDetailState {}

final class ProductDetailLoaded extends ProductDetailState {
  const ProductDetailLoaded({required this.resultProducts});

  final ResultProducts resultProducts;

  @override
  List<Object?> get props => [resultProducts];
}

final class ProductDetailErrorState extends ProductDetailState {
  const ProductDetailErrorState(this.exception);

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
