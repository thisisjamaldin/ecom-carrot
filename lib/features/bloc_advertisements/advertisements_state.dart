part of 'advertisements_bloc.dart';

sealed class AdvertisementsState extends Equatable {
  const AdvertisementsState();
}

final class AdvertisementsInitial extends AdvertisementsState {
  @override
  List<Object> get props => [];
}

final class LoadingAdvertisementsState extends AdvertisementsState {
  @override
  List<Object?> get props => [];
}

final class LoadedAdvertisementsState extends AdvertisementsState {
  const LoadedAdvertisementsState({required this.advertisementsModel});

  final AdvertisementsModel advertisementsModel;

  @override
  List<Object?> get props => [advertisementsModel];
}

final class ErrorAdvertisementsState extends AdvertisementsState {
  final Object exception;

  const ErrorAdvertisementsState({required this.exception});

  @override
  List<Object?> get props => [exception];
}
