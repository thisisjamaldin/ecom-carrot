part of 'send_email_for_code_bloc.dart';

sealed class SendEmailForCodeEvent extends Equatable {
  const SendEmailForCodeEvent();
}

final class SendEmailEvent extends SendEmailForCodeEvent{
  final String email;

  const SendEmailEvent({required this.email});
  @override
  List<Object?> get props => [email];
}