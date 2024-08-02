part of 'reviews_bloc.dart';

sealed class ReviewsEvent extends Equatable {
  const ReviewsEvent();
}

class LoadReviewsEvent extends ReviewsEvent {
  const LoadReviewsEvent({
    required this.token,
    required this.user,
  });

  final String token;
  final String user;

  @override
  List<Object?> get props => [token, user];
}

