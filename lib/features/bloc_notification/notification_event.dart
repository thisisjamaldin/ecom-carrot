part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();
}

final class LoadNotificationEvent extends NotificationEvent {
  int limit;
  final String token;

  LoadNotificationEvent({
    required this.token,
    required this.limit,
  });

  @override
  List<Object?> get props => [limit, token];
}
