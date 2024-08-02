import 'package:russsia_carrot/data/model/products_model.dart';
import 'package:equatable/equatable.dart';

class FavoritesModel extends Equatable {
  final int count;
  final List<ResultFavorites> results;

  const FavoritesModel({
    required this.count,
    required this.results,
  });

  factory FavoritesModel.fromJson(Map<String, dynamic> json) => FavoritesModel(
    count: json["count"],
    results: List<ResultFavorites>.from(json["results"].map((x) => ResultFavorites.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };

  @override
  List<Object?> get props => [count, results];
}

class ResultFavorites extends Equatable{
  final int id;
  final ResultProducts productData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ResultFavorites({
    required this.id,
    required this.productData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResultFavorites.fromJson(Map<String, dynamic> json) => ResultFavorites(
    id: json["id"],
    productData: ResultProducts.fromJson(json["product_data"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_data": productData.toJson(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, productData, createdAt, updatedAt];
}