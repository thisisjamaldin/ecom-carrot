import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:russsia_carrot/data/model/reviews_model.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';

part 'add_reviews_event.dart';

part 'add_reviews_state.dart';

class AddReviewsBloc extends Bloc<AddReviewsEvent, AddReviewsState> {
  AddReviewsBloc(this.repository) : super(AddReviewsInitial()) {
    on<LoadAddReviewsEvent>((_loadAddReviews));
  }

  final AbstractRepository repository;

  Future<void> _loadAddReviews(
    LoadAddReviewsEvent event,
    Emitter<AddReviewsState> emit,
  ) async {
    try {
      if (state is! LoadedAddReviewsState) {
        emit(LoadingAddReviewsState());
      }
      ResultReviews resultReviews = await repository.reviews(
          event.token, event.user, event.product, event.rating, event.text);
      emit(LoadedAddReviewsState(resultReviews: resultReviews));
    } catch (e) {
      emit(ErrorAddReviewsState(exception: e));
    }
  }
}
