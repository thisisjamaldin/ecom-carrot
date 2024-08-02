import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:russsia_carrot/data/model/advertisements_model.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';

part 'advertisements_event.dart';

part 'advertisements_state.dart';

class AdvertisementsBloc
    extends Bloc<AdvertisementsEvent, AdvertisementsState> {
  AdvertisementsBloc(this.repository) : super(AdvertisementsInitial()) {
    on<LoadAdvertisementsEvent>((_loadAdvertisements));
  }

  final AbstractRepository repository;

  Future<void> _loadAdvertisements(
    LoadAdvertisementsEvent event,
    Emitter<AdvertisementsState> emit,
  ) async {
    try {
      if (state is! LoadedAdvertisementsState) {
        emit(LoadingAdvertisementsState());
      }
      AdvertisementsModel advertisementsModel =
          await repository.fetchAdvertisements(event.limit.toString());
      emit(LoadedAdvertisementsState(advertisementsModel: advertisementsModel));
    } catch (e) {
      emit(ErrorAdvertisementsState(exception: e));
    }
  }
}
