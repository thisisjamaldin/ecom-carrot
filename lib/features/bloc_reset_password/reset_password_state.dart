part of 'reset_password_bloc.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();
}

final class ResetPasswordInitial extends ResetPasswordState {
  @override
  List<Object> get props => [];
}

final class ResetPasswordLoading extends ResetPasswordState{
  @override
  List<Object?> get props => [];
}
final class ResetPasswordLoaded extends ResetPasswordState{
  @override
  List<Object?> get props => [];
}

final class ResetPasswordError extends ResetPasswordState{
  final Object exception;

  const ResetPasswordError({required this.exception});
  @override
  List<Object?> get props => [exception];
}