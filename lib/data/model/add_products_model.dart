

import 'package:equatable/equatable.dart';
import 'package:russsia_carrot/data/model/products_model.dart';

class AddProductsModel extends Equatable {
  final OwnerAdd owner;
  final List<PhotoAdd> photos;
  final String name;
  final String description;
  final String price;
  final String ownerName;
  final String ownerPhone;
  final String ownerEmail;
  final String address;
  final int category;

  const AddProductsModel({
    required this.owner,
    required this.photos,
    required this.name,
    required this.description,
    required this.price,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    required this.address,
    required this.category,
  });

  factory AddProductsModel.fromJson(Map<String, dynamic> json) =>
      AddProductsModel(
        owner: OwnerAdd.fromJson(json["owner"]),
        photos: List<PhotoAdd>.from(json["photos"].map((x) => Photo.fromJson(x))),
        name: json["name"],
        description: json["description"],
        price: json["price"],
        ownerName: json["owner_name"],
        ownerPhone: json["owner_phone"],
        ownerEmail: json["owner_email"],
        address: json["address"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "owner": owner.toJson(),
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
        "name": name,
        "description": description,
        "price": price,
        "owner_name": ownerName,
        "owner_phone": ownerPhone,
        "owner_email": ownerEmail,
        "address": address,
        "category": category,
      };

  @override
  List<Object?> get props => [
        owner,
        photos,
        name,
        description,
        price,
        ownerName,
        ownerPhone,
        ownerEmail,
        address,
        category
      ];
}

class OwnerAdd extends Equatable {
  final String email;
  final String firstName;
  final String lastName;
  final String middleName;
  final String phone;

  const OwnerAdd({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.phone,
  });

  factory OwnerAdd.fromJson(Map<String, dynamic> json) => OwnerAdd(
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        middleName: json["middle_name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "middle_name": middleName,
        "phone": phone,
      };

  @override
  List<Object?> get props => [email, firstName, lastName, middleName, phone];
}

class PhotoAdd extends Equatable {
  final String photo;

  const PhotoAdd({
    required this.photo,
  });

  factory PhotoAdd.fromJson(Map<String, dynamic> json) => PhotoAdd(
    photo: json["photo"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "photo": photo,
  };

  @override
  List<Object?> get props => [photo];
}
