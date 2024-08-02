part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent({
    required this.token,
  });

  final String token;

  @override
  List<Object?> get props => [token];
}
