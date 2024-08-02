part of 'send_email_for_code_bloc.dart';

sealed class SendEmailForCodeState extends Equatable {
  const SendEmailForCodeState();
}

final class SendEmailForCodeInitial extends SendEmailForCodeState {
  @override
  List<Object> get props => [];
}

final class SendEmailForCodeLoading extends SendEmailForCodeState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class SendEmailForCodeError extends SendEmailForCodeState {
  final Object exception;

  const SendEmailForCodeError({required this.exception});

  @override
  List<Object?> get props => [exception];
}

final class SendEmailForCodeLoaded extends SendEmailForCodeState {
  final String emailCode;

  const SendEmailForCodeLoaded({required this.emailCode});

  @override
  List<Object?> get props => [emailCode];
}
