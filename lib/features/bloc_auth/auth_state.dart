part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class LoadSuccessState extends AuthState {
  final ConfirmModel confirm;

  const LoadSuccessState({required this.confirm});

  @override
  List<Object?> get props => [confirm];
}

final class ErrorLoginState extends AuthState {
  final Object exception;

  const ErrorLoginState({required this.exception});

  @override
  List<Object?> get props => [exception];
}

final class LoadingLoginState extends AuthState {
  @override
  List<Object?> get props => [];
}
