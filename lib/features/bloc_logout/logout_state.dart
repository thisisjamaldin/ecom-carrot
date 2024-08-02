part of 'logout_bloc.dart';

sealed class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => throw UnimplementedError();
}

final class LogoutInitial extends LogoutState {}

final class LogoutLoading extends LogoutState {}

final class LogoutLoaded extends LogoutState {
  const LogoutLoaded({required this.detail});

  final String detail;

  @override
  List<Object?> get props => [detail];
}


final class LogoutErrorState extends LogoutState {
  const LogoutErrorState(this.exception);

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
