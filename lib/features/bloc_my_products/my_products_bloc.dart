import 'package:bloc/bloc.dart';
import 'package:russsia_carrot/data/model/products_model.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:equatable/equatable.dart';

part 'my_products_event.dart';

part 'my_products_state.dart';

class MyProductsBloc extends Bloc<MyProductsEvent, MyProductsState> {
  MyProductsBloc(this.repository) : super(MyProductsInitial()) {
    on<LoadMyProductsEvent>(_loadMyProducts);
    on<DeleteMyProductEvent>(_deleteProduct);
  }

  final AbstractRepository repository;

  Future<void> _loadMyProducts(
    LoadMyProductsEvent event,
    Emitter<MyProductsState> emit,
  ) async {
    try {
      if (state is! MyProductsLoaded) {
        emit(MyProductsLoading());
      }
      final List<ResultProducts> resultProducts =
          await repository.fetchMyProducts(
        event.limit.toString(),
        event.token,
      );
      emit(MyProductsLoaded(resultProducts: resultProducts));
    } catch (e) {
      emit(MyProductsErrorState(e));
    }
  }

  Future<void> _deleteProduct(
    DeleteMyProductEvent event,
    Emitter<MyProductsState> emit,
  ) async {
    try {
      if (state is! MyProductsLoaded) {
        emit(MyProductsLoading());
      }
      await repository.deleteProducts(event.token, event.productId);
      final List<ResultProducts> resultProducts =
          await repository.fetchMyProducts(
        event.limit.toString(),
        event.token,
      );
      emit(MyProductsLoaded(resultProducts: resultProducts));
    } catch (e) {
      emit(MyProductsErrorState(e));
    }
  }
}
