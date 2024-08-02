import 'package:bloc/bloc.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/categories_model.dart';

part 'category_product_event.dart';

part 'category_product_state.dart';

class CategoryProductBloc
    extends Bloc<CategoryProductEvent, CategoryProductState> {
  CategoryProductBloc(this.repository) : super(CategoryProductInitial()) {
    on<LoadCategoryProductEvent>(_loadCategory);
  }

  final AbstractRepository repository;

  Future<void> _loadCategory(
    LoadCategoryProductEvent event,
    Emitter<CategoryProductState> emit,
  ) async {
    try {
      if (state is! CategoryProductLoaded) {
        emit(CategoryProductLoading());
      }
      final CategoryModel categoryModel = await repository.fetchCategory(
        event.limit.toString(),
      );
      emit(CategoryProductLoaded(categoryModel: categoryModel));
    } catch (e) {
      emit(CategoryProductErrorState(e));
    }
  }
}
