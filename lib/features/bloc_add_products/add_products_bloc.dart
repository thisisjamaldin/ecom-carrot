import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';

part 'add_products_event.dart';

part 'add_products_state.dart';

class AddProductsBloc extends Bloc<AddProductsEvent, AddProductsState> {
  AddProductsBloc(this.repository) : super(AddProductsInitial()) {
    on<LoadAddProductsEvent>((_loadAddReviews));
  }

  final AbstractRepository repository;

  Future<void> _loadAddReviews(
    LoadAddProductsEvent event,
    Emitter<AddProductsState> emit,
  ) async {
    try {
      if (state is! LoadedAddProductsState) {
        emit(LoadingAddProductsState());
      }
      await repository.addProducts(
        event.token,
        event. email,
        event. firstName,
        event. lastName,
        event. middleName,
        event. phone,
        event. photos,
        event. name,
        event. description,
        event. price,
        event. ownerName,
        event. ownerPhone,
        event. ownerEmail,
        event. address,
        event. category,
      );
      emit(const LoadedAddProductsState());
    } catch (e) {
      emit(ErrorAddProductsState(exception: e));
    }
  }
}
