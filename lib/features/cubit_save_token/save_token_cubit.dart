import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:russsia_carrot/data/local/Pref.dart';

part 'save_token_state.dart';

class SaveTokenCubit extends Cubit<SaveTokenState> {
  SaveTokenCubit({required this.pref})
      : super(SaveTokenState(token: pref.getToken()));

  final Pref pref;

  Future<void> saveToken(String token) async {
    pref.saveToken(token);
    emit(SaveTokenState(token: token));
  }

  void clearToken() {
    pref.clearToken();
    pref.clearId();
    emit(const SaveTokenState(token: ''));
  }
}
