import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:russsia_carrot/data/local/Pref.dart';

part 'save_eamail_state.dart';

class SaveEamailCubit extends Cubit<SaveEamailState> {
  SaveEamailCubit(this.pref) : super(SaveEamailState(email: pref.getEmail()));
  final Pref pref;

  void saveEmail(String email){
    pref.saveEmail(email);
    emit(SaveEamailState(email: pref.getEmail()));
  }
}
