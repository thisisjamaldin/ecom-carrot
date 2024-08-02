import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:russsia_carrot/data/model/reviews_model.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';

part 'reviews_event.dart';

part 'reviews_state.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  ReviewsBloc(this.repository) : super(ReviewsInitial()) {
    on<LoadReviewsEvent>((_loadReviews));
  }

  final AbstractRepository repository;

  Future<void> _loadReviews(
    LoadReviewsEvent event,
    Emitter<ReviewsState> emit,
  ) async {
    try {
      if (state is! LoadedReviewsState) {
        emit(LoadingReviewsState());
      }
      ReviewsModel reviewsModel =
          await repository.fetchReviews(event.token, event.user);
      emit(LoadedReviewsState(reviewsModel: reviewsModel));
    } catch (e) {
      emit(ErrorReviewsState(exception: e));
    }
  }

}
