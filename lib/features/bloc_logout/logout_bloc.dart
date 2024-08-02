import 'package:bloc/bloc.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:equatable/equatable.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc(this.repository) : super(LogoutInitial()) {
    on<LoadLogoutEvent>(_loadProducts);
  }

  final AbstractRepository repository;

  Future<void> _loadProducts(
      LoadLogoutEvent event,
      Emitter<LogoutState> emit,
      ) async {
    try {
      if (state is! LogoutLoaded) {
        emit(LogoutLoading());
      }
      final String detail = await repository.logoutAccount(
        event.token,
        event.revoke,
      );
      emit(LogoutLoaded(detail: detail));
    } catch (e) {
      emit(LogoutErrorState(e));
    }
  }

}
