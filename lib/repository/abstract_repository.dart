import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:russsia_carrot/data/model/favorites_model.dart';
import 'package:russsia_carrot/data/model/notification_model.dart';
import 'package:russsia_carrot/data/model/products_model.dart';
import 'package:russsia_carrot/data/model/register_model.dart';
import 'package:russsia_carrot/data/model/reviews_model.dart';

import '../data/model/advertisements_model.dart';
import '../data/model/categories_model.dart';
import '../data/model/chat.dart';

abstract class AbstractRepository {
  Future<CategoryModel> fetchCategory(String limit);

  Future<ProductsModel> fetchProducts(
    String limit,
    String token, {
    String searchText = '',
    String category = '',
    String owner = '',
  });

  Future<List<ResultProducts>> fetchMyProducts(
    String? limit,
    String token,
  );

  Future<String> sendEmailForCode(String email);

  Future<void> sendPasswordForRest(
    int code,
    String password,
    String passwordConfirm,
  );

  Future<void> addProducts(
    String token,
    String email,
    String firstName,
    String lastName,
    String middleName,
    String phone,
    List<File> photos,
    String name,
    String description,
    String price,
    String ownerName,
    String ownerPhone,
    String ownerEmail,
    String address,
    int category,
  );

  Future<void> deleteProducts(String token, int id);

  Future<String> getCityName(Position position);

  Future<ProductsModel> fetchSearchProduct(String token, String searchText);

  Future<ResultProducts> fetchProductDetail(int id, String token);

  Future<AdvertisementsModel> fetchAdvertisements(String limit);

  Future<FavoritesModel> fetchFavorites(String limit, String token);

  Future<void> deleteFavorites(String id, String token);

  Future<void> addFavorites(String productId, String token);

  Future<NotificationModel> getListNotification(String token, int limit);

  Future<RegisterModel> fetchRegister(String email, String password);

  Future<ConfirmModel> fetchConfirm(int code);

  Future<ConfirmModel> loginAccount(String email, String password);

  Future<String> logoutAccount(String token, bool revoke);

  Future<Owner> fetchProfile(String token);

  Future<ReviewsModel> fetchReviews(String token, String user);

  Future<ResultReviews> reviews(
      String token, int user, int product, int rating, String text);

  Future<void> sendToken(String tokenPush, String platform, String tokenUser);
  Future<ChatRoomModel> getRoom(String token, bool buy);
  Future<ChatRoomResultsModel> createRoom(
      String token, String name, int user, int productId, String? uuid);
  Future<MessagesOldModel> getOldMessages(String token, String uuid);
  Future<void> uploadMessageImage(String token, String uuid, XFile image);
  Future<void> sendReport(String token, String header, String name,
      String email, String phone, String content);
}
