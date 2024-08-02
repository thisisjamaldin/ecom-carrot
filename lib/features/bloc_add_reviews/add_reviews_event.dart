part of 'add_reviews_bloc.dart';

sealed class AddReviewsEvent extends Equatable {
  const AddReviewsEvent();
}


class LoadAddReviewsEvent extends AddReviewsEvent {
  const LoadAddReviewsEvent({
    required this.token,
    required this.user,
    required this.product,
    required this.rating,
    required this.text,
  });

  final String token;
  final int user;
  final int product;
  final int rating;
  final String text;

  @override
  List<Object?> get props => [token, user, product, rating, text];
}
