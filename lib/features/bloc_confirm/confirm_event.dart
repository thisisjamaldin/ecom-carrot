part of 'confirm_bloc.dart';

sealed class ConfirmEvent extends Equatable {
  const ConfirmEvent();
}

class LoadConfirmEvent extends ConfirmEvent {
  const LoadConfirmEvent({required this.code,});

  final int code;

  @override
  List<Object?> get props => [code];
}
