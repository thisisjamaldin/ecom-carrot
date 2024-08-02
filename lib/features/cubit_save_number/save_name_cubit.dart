import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/local/Pref.dart';

part 'save_name_state.dart';

class SaveNameCubit extends Cubit<SaveNameState> {
  SaveNameCubit(this.pref) : super(SaveNameState(name: pref.getName()));

  final Pref pref;

  void saveNumber(String number) {
    pref.saveName(number);
    emit(SaveNameState(name: number));
  }
}
