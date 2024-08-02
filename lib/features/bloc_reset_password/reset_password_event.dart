part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();
}

final class ResetEvent extends ResetPasswordEvent {
  final int code;
  final String password;
  final String passwordConfirm;

  const ResetEvent(
      {required this.code,
      required this.password,
      required this.passwordConfirm});

  @override
  List<Object?> get props => [
        code,
        passwordConfirm,
        password,
      ];
}
