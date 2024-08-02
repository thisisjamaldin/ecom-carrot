import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:russsia_carrot/data/model/notification_model.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(this.repository) : super(NotificationInitial()) {
    on<LoadNotificationEvent>(_loadNotification);
  }

  final AbstractRepository repository;

  Future<void> _loadNotification(
    LoadNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (state is! LoadedNotificationState) {
        emit(LoadingNotificationState());
      }
      NotificationModel notificationModel =
          await repository.getListNotification(
        event.token,
        event.limit,
      );
      emit(LoadedNotificationState(notificationModel: notificationModel));
    } catch (e) {
      emit(ErrorNotificationState(exception: e));
    }
  }
}
