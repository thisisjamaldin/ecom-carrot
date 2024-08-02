part of 'confirm_bloc.dart';

sealed class ConfirmState extends Equatable {
  const ConfirmState();
}

final class ConfirmInitial extends ConfirmState {
  @override
  List<Object> get props => [];
}

final class LoadingConfirmState extends ConfirmState {
  @override
  List<Object?> get props => [];
}

final class LoadedConfirmState extends ConfirmState {
  const LoadedConfirmState({required this.confirmModel});

  final ConfirmModel confirmModel;

  @override
  List<Object?> get props => [confirmModel];
}

final class ErrorConfirmState extends ConfirmState {
  final Object exception;

  const ErrorConfirmState({required this.exception});

  @override
  List<Object?> get props => [exception];
}
