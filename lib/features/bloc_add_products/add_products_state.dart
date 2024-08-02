part of 'add_products_bloc.dart';

sealed class AddProductsState extends Equatable {
  const AddProductsState();
}

final class AddProductsInitial extends AddProductsState {
  @override
  List<Object> get props => [];
}

final class LoadingAddProductsState extends AddProductsState {
  @override
  List<Object?> get props => [];
}


final class LoadedAddProductsState extends AddProductsState {
  const LoadedAddProductsState();

  @override
  List<Object?> get props => [];
}

final class ErrorAddProductsState extends AddProductsState {
  final Object exception;

  const ErrorAddProductsState({required this.exception});

  @override
  List<Object?> get props => [exception];
}
