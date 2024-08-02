part of 'reviews_bloc.dart';

sealed class ReviewsState extends Equatable {
  const ReviewsState();
}

final class ReviewsInitial extends ReviewsState {
  @override
  List<Object> get props => [];
}

final class LoadingReviewsState extends ReviewsState {
  @override
  List<Object?> get props => [];
}

final class LoadedReviewsState extends ReviewsState {
  const LoadedReviewsState({required this.reviewsModel});

  final ReviewsModel reviewsModel;

  @override
  List<Object?> get props => [reviewsModel];
}


final class ErrorReviewsState extends ReviewsState {
  final Object exception;

  const ErrorReviewsState({required this.exception});

  @override
  List<Object?> get props => [exception];
}
