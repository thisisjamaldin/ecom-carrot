part of 'category_product_bloc.dart';

sealed class CategoryProductEvent extends Equatable {
  const CategoryProductEvent();
}

final class LoadCategoryProductEvent extends CategoryProductEvent {
  const LoadCategoryProductEvent({
    required this.limit,
  });

  final int limit;

  @override
  List<Object?> get props => [
        limit,
      ];
}
