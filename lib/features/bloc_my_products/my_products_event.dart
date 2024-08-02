part of 'my_products_bloc.dart';

sealed class MyProductsEvent extends Equatable {
  const MyProductsEvent();
}

final class LoadMyProductsEvent extends MyProductsEvent {
  const LoadMyProductsEvent({
    required this.limit,
    required this.token,
  });

  final int? limit;
  final String token;

  @override
  List<Object?> get props => [limit, token];
}

final class DeleteMyProductEvent extends MyProductsEvent {
  final String token;
  final int productId;
  final int limit;

  const DeleteMyProductEvent({
    required this.token,
    required this.productId,
    required this.limit,
  });

  @override
  List<Object?> get props => [
        token,
        productId,
        limit,
      ];
}
