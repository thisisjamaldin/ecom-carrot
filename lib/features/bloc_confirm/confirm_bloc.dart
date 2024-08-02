import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:russsia_carrot/data/model/register_model.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';

part 'confirm_event.dart';

part 'confirm_state.dart';

class ConfirmBloc extends Bloc<ConfirmEvent, ConfirmState> {
  ConfirmBloc(this.repository) : super(ConfirmInitial()) {
    on<LoadConfirmEvent>(_loadConfirm);
  }

  final AbstractRepository repository;

  Future<void> _loadConfirm(
    LoadConfirmEvent event,
    Emitter<ConfirmState> emit,
  ) async {
    try {
      if (state is! LoadedConfirmState) {
        emit(LoadingConfirmState());
      }
      ConfirmModel confirmModel = await repository.fetchConfirm(event.code);
      emit(LoadedConfirmState(confirmModel: confirmModel));
    } catch (e) {
      emit(ErrorConfirmState(exception: e));
    }
  }
}
