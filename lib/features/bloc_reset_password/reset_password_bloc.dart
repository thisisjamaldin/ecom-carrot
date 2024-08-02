import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';

part 'reset_password_event.dart';

part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc(this.repository) : super(ResetPasswordInitial()) {
    on<ResetEvent>(_sendPassword);
  }

  final AbstractRepository repository;

  Future<void> _sendPassword(
    ResetEvent event,
    Emitter<ResetPasswordState> emit,
  ) async {
    try {
      if (state is! ResetPasswordLoaded) {
        emit(ResetPasswordLoading());
      }
      repository.sendPasswordForRest(
        event.code,
        event.password,
        event.passwordConfirm,
      );
      emit(ResetPasswordLoaded());
    } catch (e) {
      emit(ResetPasswordError(exception: e));
    }
  }
}
