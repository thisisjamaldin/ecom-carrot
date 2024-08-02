import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';

import '../../data/model/register_model.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginEvent>((_login));
  }

  final AbstractRepository repository;

  Future<void> _login(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (state is! LoadSuccessState) {
        emit(LoadingLoginState());
      }

      ConfirmModel confirm =
          await repository.loginAccount(event.email, event.password);
      emit(LoadSuccessState(confirm: confirm));
    } catch (e) {
      emit(ErrorLoginState(exception: e));
    }
  }
}
