import 'package:equatable/equatable.dart';
import 'package:russsia_carrot/data/model/products_model.dart';


class ReviewsModel {
  final int count;
  final int totalPages;
  final String next;
  final String previous;
  final List<ResultReviews> results;

  ReviewsModel({
    required this.count,
    required this.totalPages,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory ReviewsModel.fromJson(Map<String, dynamic> json) => ReviewsModel(
    count: json["count"],
    totalPages: json["total_pages"],
    next: json["next"] ?? "",
    previous: json["previous"] ?? "",
    results: List<ResultReviews>.from(json["results"].map((x) => ResultReviews.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "total_pages": totalPages,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}


class ResultReviews extends Equatable {
  final int id;
  final Owner user;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String text;
  final int rating;
  final int product;
  final int salesman;

  const ResultReviews({
    required this.id,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    required this.text,
    required this.rating,
    required this.product,
    required this.salesman,
  });

  factory ResultReviews.fromJson(Map<String, dynamic> json) => ResultReviews(
        id: json["id"],
        user: Owner.fromJson(json["user"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        text: json["text"],
        rating: json["rating"],
        product: json["product"],
        salesman: json["salesman"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "text": text,
        "rating": rating,
        "product": product,
        "salesman": salesman,
      };

  @override
  List<Object?> get props =>
      [id, user, createdAt, updatedAt, text, rating, product, salesman];
}

class User extends Equatable {
  final int id;
  final DateTime lastLogin;
  final String firstName;
  final String lastName;
  final bool isActive;
  final DateTime dateJoined;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String phone;
  final String image;
  final String middleName;
  final String email;

  const User({
    required this.id,
    required this.lastLogin,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.dateJoined,
    required this.createdAt,
    required this.updatedAt,
    required this.phone,
    required this.image,
    required this.middleName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        lastLogin: DateTime.parse(json["last_login"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        isActive: json["is_active"],
        dateJoined: DateTime.parse(json["date_joined"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["u"
            "pdated_at"]),
        phone: json["phone"] ?? "",
        image: json["image"] ?? "",
        middleName: json["middle_name"] ?? "",
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "last_login": lastLogin.toIso8601String(),
        "first_name": firstName,
        "last_name": lastName,
        "is_active": isActive,
        "date_joined": dateJoined.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "phone": phone,
        "image": image,
        "middle_name": middleName,
        "email": email,
      };

  @override
  List<Object?> get props => [
        id,
        lastLogin,
        firstName,
        lastName,
        isActive,
        dateJoined,
        createdAt,
        updatedAt,
        phone,
        image,
        middleName,
        email
      ];
}
