import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:russsia_carrot/data/model/register_model.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this.repository) : super(RegisterInitial()) {
    on<LoadRegisterEvent>((_loadRegister));
  }

  final AbstractRepository repository;

  Future<void> _loadRegister(
    LoadRegisterEvent event,
    Emitter<RegisterState> emit,
  ) async {
    try {
      if (state is! LoadedRegisterState) {
        emit(LoadingRegisterState());
      }
      RegisterModel registerModel =
          await repository.fetchRegister(event.email, event.password);
      emit(LoadedRegisterState(registerModel: registerModel));
    } catch (e) {
      emit(ErrorRegisterState(exception: e));
    }
  }
}
