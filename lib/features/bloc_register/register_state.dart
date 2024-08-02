part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();
}

final class RegisterInitial extends RegisterState {
  @override
  List<Object> get props => [];
}

final class LoadingRegisterState extends RegisterState {
  @override
  List<Object?> get props => [];
}

final class LoadedRegisterState extends RegisterState {
  const LoadedRegisterState({required this.registerModel});

  final RegisterModel registerModel;

  @override
  List<Object?> get props => [registerModel];
}

final class ErrorRegisterState extends RegisterState {
  final Object exception;

  const ErrorRegisterState({required this.exception});

  @override
  List<Object?> get props => [exception];
}
