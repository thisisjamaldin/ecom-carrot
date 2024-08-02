part of 'product_detail_bloc.dart';

sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();
}

final class LoadProductDetailEvent extends ProductDetailEvent {
  const LoadProductDetailEvent({
    required this.id,
    required this.token,
  });

  final int id;
  final String token;

  @override
  List<Object?> get props => [id,token];
}
