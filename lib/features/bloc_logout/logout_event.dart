part of 'logout_bloc.dart';

sealed class LogoutEvent extends Equatable {
  const LogoutEvent();
}

final class LoadLogoutEvent extends LogoutEvent {
  const LoadLogoutEvent({
    required this.revoke,
    required this.token,
  });

  final bool revoke;
  final String token;

  @override
  List<Object?> get props => [revoke, token];
}


