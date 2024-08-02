import 'dart:convert';

import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final int count;
  final int totalPages;
  final dynamic next;
  final dynamic previous;
  final List<Result> results;

  const CategoryModel({
    required this.count,
    required this.totalPages,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory CategoryModel.fromJson(String str) =>
      CategoryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
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
  final String name;
  final String photo;

  const Result({
    required this.id,
    required this.name,
    required this.photo,
  });

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        photo: json["photo"]  ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "photo": photo,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        photo,
      ];
}
