part of 'advertisements_bloc.dart';

sealed class AdvertisementsEvent extends Equatable {
  const AdvertisementsEvent();
}

class LoadAdvertisementsEvent extends AdvertisementsEvent {
  const LoadAdvertisementsEvent({required this.limit});

  final int limit;

  @override
  List<Object?> get props => [limit];
}
