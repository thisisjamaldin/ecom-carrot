part of 'save_number_cubit.dart';

class SaveNumberState extends Equatable {
  const SaveNumberState({required this.number});

  final String number;

  @override
  List<Object?> get props => [number];
}