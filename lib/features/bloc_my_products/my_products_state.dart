part of 'my_products_bloc.dart';

sealed class MyProductsState extends Equatable {
  const MyProductsState();

  @override
  List<Object?> get props => throw UnimplementedError();
}

final class MyProductsInitial extends MyProductsState {}

final class MyProductsLoading extends MyProductsState {}

final class MyProductsLoaded extends MyProductsState {
  const MyProductsLoaded({required this.resultProducts});

  final List<ResultProducts> resultProducts;

  @override
  List<Object?> get props => [resultProducts];
}


final class MyProductsErrorState extends MyProductsState {
  const MyProductsErrorState(this.exception);

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
