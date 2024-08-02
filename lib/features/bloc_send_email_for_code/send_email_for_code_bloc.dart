import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';

part 'send_email_for_code_event.dart';

part 'send_email_for_code_state.dart';

class SendEmailForCodeBloc
    extends Bloc<SendEmailForCodeEvent, SendEmailForCodeState> {
  SendEmailForCodeBloc(this.repository) : super(SendEmailForCodeInitial()) {
    on<SendEmailEvent>(_sendEmail);
  }

  final AbstractRepository repository;

  Future<void> _sendEmail(
    SendEmailEvent event,
    Emitter<SendEmailForCodeState> emit,
  ) async {
    try {
      if (state is! SendEmailForCodeLoaded) {
        emit(SendEmailForCodeLoading());
      }

      String code = await repository.sendEmailForCode(event.email);
      emit(SendEmailForCodeLoaded(emailCode: code));
    } catch (e) {
      emit(SendEmailForCodeError(exception: e));
    }
  }
}
