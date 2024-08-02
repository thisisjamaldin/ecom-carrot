import 'package:equatable/equatable.dart';

class RegisterModel extends Equatable {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final dynamic middleName;
  final dynamic phone;
  final dynamic image;
  final String getFullName;

  const RegisterModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.phone,
    required this.image,
    required this.getFullName,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        middleName: json["middle_name"] ?? "",
        phone: json["phone"] ?? "",
        image: json["image"] ?? "",
        getFullName: json["get_full_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "middle_name": middleName ?? "",
        "phone": phone ?? "",
        "image": image ?? "",
        "get_full_name": getFullName,
      };

  @override
  List<Object?> get props =>
      [id, email, firstName, lastName, middleName, phone, image, getFullName];
}

class ConfirmModel extends Equatable {
  final String token;

  const ConfirmModel({required this.token});

  factory ConfirmModel.fromJson(Map<String, dynamic> json) =>
      ConfirmModel(token: json["token"]);

  Map<String, dynamic> toJson() => {"token": token};

  @override
  List<Object?> get props => [token];
}
