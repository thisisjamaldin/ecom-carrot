part of 'add_reviews_bloc.dart';

sealed class AddReviewsState extends Equatable {
  const AddReviewsState();
}

final class AddReviewsInitial extends AddReviewsState {
  @override
  List<Object> get props => [];
}

final class LoadingAddReviewsState extends AddReviewsState {
  @override
  List<Object?> get props => [];
}


final class LoadedAddReviewsState extends AddReviewsState {
  const LoadedAddReviewsState({required this.resultReviews});

  final ResultReviews resultReviews;

  @override
  List<Object?> get props => [resultReviews];
}

final class ErrorAddReviewsState extends AddReviewsState {
  final Object exception;

  const ErrorAddReviewsState({required this.exception});

  @override
  List<Object?> get props => [exception];
}
