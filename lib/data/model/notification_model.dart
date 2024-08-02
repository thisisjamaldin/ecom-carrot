import 'dart:convert';

import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final int count;
  final int totalPages;
  final dynamic next;
  final dynamic previous;
  final List<Result> results;

  const NotificationModel({
    required this.count,
    required this.totalPages,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory NotificationModel.fromJson(String str) =>
      NotificationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromMap(Map<String, dynamic> json) =>
      NotificationModel(
        count: json["count"],
        totalPages: json["total_pages"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "count": count,
        "total_pages": totalPages,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
      };

  @override
  List<Object?> get props => [
        count,
        totalPages,
        next,
        previous,
        results,
      ];
}

class Result extends Equatable {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String description;
  final bool isRead;
  final bool isForAll;
  final String? photo;
  final int? user;

  const Result({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.isRead,
    required this.isForAll,
    required this.photo,
    required this.user,
  });

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        title: json["title"],
        description: json["description"],
        isRead: json["is_read"],
        isForAll: json["is_for_all"],
        photo: json["photo"],
        user: json["user"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "title": title,
        "description": description,
        "is_read": isRead,
        "is_for_all": isForAll,
        "photo": photo,
        "user": user,
      };

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        title,
        description,
        isRead,
        isForAll,
        photo,
        user,
      ];
}
