part of 'save_token_cubit.dart';

class SaveTokenState extends Equatable {
  const SaveTokenState({required this.token});

  final String token;

  @override
  List<Object?> get props => [token];
}
