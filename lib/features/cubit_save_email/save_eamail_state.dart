part of 'save_eamail_cubit.dart';

class SaveEamailState extends Equatable {
  const SaveEamailState({required this.email});
  final String email;

  @override
  List<Object?> get props => [email];
}
