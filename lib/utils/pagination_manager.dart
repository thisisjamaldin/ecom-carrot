import 'package:flutter/cupertino.dart';

class PaginationManager {
  PaginationManager({
    required this.shouldPaginate,
    required this.isLoading,
    required this.limitCategory,
    required this.load,
    required this.scrollCategoryController,
  }) {
    if (shouldPaginate) {
      scrollCategoryController.addListener(_scrollCategoryListener);
    }
  }

  bool shouldPaginate;
  ValueNotifier<bool> isLoading;
  ValueNotifier<int> limitCategory;
  Function() load;
  ScrollController scrollCategoryController;

  void paginationCategoryFun(bool paginate, int limitList) {
    shouldPaginate = paginate;
    if (shouldPaginate == false) {
      isLoading.value = false;
      limitCategory.value = limitList;
      load();
    } else {
      load();
    }
  }

  void _scrollCategoryListener() {
    if (scrollCategoryController.offset >=
        scrollCategoryController.position.maxScrollExtent &&
        !scrollCategoryController.position.outOfRange) {
      // Достигнут конец списка, обработка пагинации здесь
      // Вызовите метод загрузки новых данных
      if (shouldPaginate) {
        _loadCategoryMoreData();
      }
    }
  }

  void _loadCategoryMoreData() {
    limitCategory.value += 10;
    isLoading.value = true;
    load();
  }
}
