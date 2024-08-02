part of 'category_product_bloc.dart';

sealed class CategoryProductState extends Equatable {
  const CategoryProductState();

  @override
  List<Object?> get props => throw UnimplementedError();
}

final class CategoryProductInitial extends CategoryProductState {}

final class CategoryProductLoading extends CategoryProductState {}

final class CategoryProductLoaded extends CategoryProductState {
  const CategoryProductLoaded({required this.categoryModel});

  final CategoryModel categoryModel;

  @override
  List<Object?> get props => [categoryModel];
}

final class CategoryProductErrorState extends CategoryProductState {
  const CategoryProductErrorState(this.exception);

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
