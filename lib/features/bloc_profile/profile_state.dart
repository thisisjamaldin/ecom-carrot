part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

final class LoadingProfileState extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class LoadedProfileState extends ProfileState {
  const LoadedProfileState({required this.owner});

  final Owner owner;

  @override
  List<Object?> get props => [owner];

  @override
  bool operator ==(Object other) => false;
  @override
  int get hashCode => super.hashCode;
}

final class ErrorProfileState extends ProfileState {
  final Object exception;

  const ErrorProfileState({required this.exception});

  @override
  List<Object?> get props => [exception];
}
