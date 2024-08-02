import 'package:bloc/bloc.dart';
import 'package:russsia_carrot/data/model/products_model.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:equatable/equatable.dart';

part 'product_detail_event.dart';

part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc(this.repository) : super(ProductDetailInitial()) {
    on<LoadProductDetailEvent>(_loadProductDetail);
  }

  final AbstractRepository repository;

  Future<void> _loadProductDetail(
    LoadProductDetailEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    try {
      if (state is! ProductDetailLoaded) {
        emit(ProductDetailLoading());
      }
      final ResultProducts resultProducts = await repository.fetchProductDetail(
        event.id,
        event.token,
      );
      emit(ProductDetailLoaded(resultProducts: resultProducts));
    } catch (e) {
      emit(ProductDetailErrorState(e));
    }
  }
}
