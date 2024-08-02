part of 'save_name_cubit.dart';

class SaveNameState extends Equatable {
  const SaveNameState({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}