import 'package:equatable/equatable.dart';

class ProductsModel extends Equatable {
  final int count;
  final int totalPages;
  final String next;
  final String previous;
  final List<ResultProducts> results;

  const ProductsModel({
    required this.count,
    required this.totalPages,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        count: json["count"],
        totalPages: json["total_pages"],
        next: json["next"] ?? "",
        previous: json["previous"] ?? "",
        results: List<ResultProducts>.from(
            json["results"].map((x) => ResultProducts.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "total_pages": totalPages,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [count, totalPages, next, previous, results];
}

class ResultProducts extends Equatable {
  final int id;
  final Owner owner;
  final List<Photo> photos;
  final bool favorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String description;
  final String price;
  final String photo;
  final String ownerName;
  final String ownerPhone;
  final String ownerEmail;
  final String address;
  final int category;

  const ResultProducts({
    required this.id,
    required this.owner,
    required this.photos,
    required this.favorite,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
    required this.price,
    required this.photo,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    required this.address,
    required this.category,
  });

  factory ResultProducts.fromJson(Map<String, dynamic> json) => ResultProducts(
        id: json["id"],
        owner: Owner.fromJson(json["owner"]),
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
        favorite: json["favorite"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        name: json["name"],
        description: json["description"],
        price: json["price"],
        photo: json["photo"] ?? "",
        ownerName: json["owner_name"],
        ownerPhone: json["owner_phone"],
        ownerEmail: json["owner_email"],
        address: json["address"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner": owner.toJson(),
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
        "favorite": favorite,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "name": name,
        "description": description,
        "price": price,
        "photo": photo,
        "owner_name": ownerName,
        "owner_phone": ownerPhone,
        "owner_email": ownerEmail,
        "address": address,
        "category": category,
      };

  @override
  List<Object?> get props => [
        id,
        owner,
        photos,
        favorite,
        createdAt,
        updatedAt,
        name,
        description,
        price,
        photo,
        ownerName,
        ownerPhone,
        ownerEmail,
        address,
        category
      ];
}

class Owner extends Equatable {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String middleName;
  final String phone;
  final String image;
  final String getFullName;
  final int raiting;
  final int completedTransactions;
  final String? chatUiid;

  const Owner({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.phone,
    required this.image,
    required this.getFullName,
    required this.raiting,
    required this.completedTransactions,
    required this.chatUiid,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        middleName: json["middle_name"] ?? "",
        phone: json["phone"] ?? "",
        image: json["image"] ?? "",
        getFullName: json["get_full_name"],
        raiting: json["raiting"],
        completedTransactions: json["completed_transactions"],
        chatUiid: json["chat_uiid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "middle_name": middleName,
        "phone": phone,
        "image": image,
        "get_full_name": getFullName,
        "raiting": raiting,
        "completed_transactions": completedTransactions,
        "chat_uiid": chatUiid,
      };

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        middleName,
        phone,
        image,
        getFullName,
        raiting,
        completedTransactions,
        chatUiid
      ];
}

class Photo extends Equatable {
  final String photo;

  const Photo({
    required this.photo,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        photo: json["photo"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "photo": photo,
      };

  @override
  List<Object?> get props => [photo];
}
