part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();
}

final class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

final class LoadedNotificationState extends NotificationState {
  final NotificationModel notificationModel;

  const LoadedNotificationState({required this.notificationModel});

  @override
  List<Object?> get props => [notificationModel];
}

final class LoadingNotificationState extends NotificationState {
  @override
  List<Object?> get props => [];
}

final class ErrorNotificationState extends NotificationState {
  final Object exception;

  const ErrorNotificationState({required this.exception});

  @override
  List<Object?> get props => [exception];
}
