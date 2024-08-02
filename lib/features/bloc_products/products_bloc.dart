import 'package:bloc/bloc.dart';
import 'package:russsia_carrot/data/model/products_model.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:equatable/equatable.dart';

part 'products_event.dart';

part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc(this.repository) : super(ProductsInitial()) {
    on<LoadProductsEvent>(_loadProducts);
    on<FindProductEvent>(_findProducts);
    on<SelectCategoryEvent>(_selectCategoryProducts);
    on<OwnerProductsEvent>(_ownerProducts);
  }

  final AbstractRepository repository;

  Future<void> _selectCategoryProducts(
    SelectCategoryEvent event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      if (state is! ProductsLoaded) {
        emit(ProductsLoading());
      }
      final ProductsModel productsModel = await repository.fetchProducts(
        event.limit.toString(),
        event.token,
        category: event.category,
      );
      emit(ProductsLoaded(productsModel: productsModel));
    } catch (e) {
      emit(ProductsErrorState(e));
    }
  }

  Future<void> _ownerProducts(
      OwnerProductsEvent event,
      Emitter<ProductsState> emit,
      ) async {
    try {
      if (state is! ProductsLoaded) {
        emit(ProductsLoading());
      }
      final ProductsModel productsModel = await repository.fetchProducts(
        event.limit.toString(),
        event.token,
        owner: event.owner,
      );
      emit(ProductsLoaded(productsModel: productsModel));
    } catch (e) {
      emit(ProductsErrorState(e));
    }
  }

  Future<void> _findProducts(
    FindProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      if (state is! ProductsFind) {
        emit(ProductsLoading());
      }

      final ProductsModel productsModel = await repository.fetchSearchProduct(
        event.token,
        event.searchText,
      );
      emit(ProductsFind(productsModel: productsModel));
    } catch (e) {
      emit(ProductsErrorState(e));
    }
  }

  Future<void> _loadProducts(
    LoadProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      if (state is! ProductsLoaded) {
        emit(ProductsLoading());
      }
      final ProductsModel productsModel = await repository.fetchProducts(
        event.limit.toString(),
        event.token,
      );
      emit(ProductsLoaded(productsModel: productsModel));
    } catch (e) {
      emit(ProductsErrorState(e));
    }
  }
}
