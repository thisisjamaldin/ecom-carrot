import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:russsia_carrot/data/model/products_model.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<LoadProfileEvent>((_loadConfirm));
  }

  final AbstractRepository repository;

  Future<void> _loadConfirm(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state is! LoadedProfileState) {
        emit(LoadingProfileState());
      }
      Owner owner = await repository.fetchProfile(event.token);
      emit(LoadedProfileState(owner: owner));
    } catch (e) {
      emit(ErrorProfileState(exception: e));
    }
  }
}
