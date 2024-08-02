import 'package:equatable/equatable.dart';
import 'dart:convert';

class AdvertisementsModel extends Equatable {
  final int count;
  final int totalPages;
  final dynamic next;
  final dynamic previous;
  final List<Result> results;

  const AdvertisementsModel({
    required this.count,
    required this.totalPages,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory AdvertisementsModel.fromJson(String str) =>
      AdvertisementsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AdvertisementsModel.fromMap(Map<String, dynamic> json) =>
      AdvertisementsModel(
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
  final dynamic photo;

  const Result({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.photo,
  });

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        title: json["title"],
        description: json["description"],
        photo: json["photo"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "title": title,
        "description": description,
        "photo": photo,
      };

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        title,
        description,
        photo,
      ];
}
