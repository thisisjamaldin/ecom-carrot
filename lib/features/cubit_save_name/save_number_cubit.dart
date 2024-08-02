import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/local/Pref.dart';

part 'save_number_state.dart';

class SaveNumberCubit extends Cubit<SaveNumberState> {
  SaveNumberCubit(this.pref) : super(SaveNumberState(number: pref.getNumber()));
  final Pref pref;

  void saveNumber(String number) {
    pref.saveNumber(number);
    emit(SaveNumberState(number: number));
  }
}
