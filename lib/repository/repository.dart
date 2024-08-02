import 'dart:convert';
import 'dart:io';

import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:image_picker/image_picker.dart';
import 'package:russsia_carrot/data/local/pref.dart';
import 'package:russsia_carrot/data/model/advertisements_model.dart';
import 'package:russsia_carrot/data/model/favorites_model.dart';
import 'package:russsia_carrot/data/model/notification_model.dart';
import 'package:russsia_carrot/data/model/products_model.dart';
import 'package:russsia_carrot/data/model/register_model.dart';
import 'package:russsia_carrot/data/model/reviews_model.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:russsia_carrot/utils/key.dart';
import 'package:dio/dio.dart';

import '../data/model/categories_model.dart';
import '../data/model/chat.dart';
import '../ext.dart';

class Repository extends AbstractRepository {
  Repository({required this.dio});

  final Dio dio;

  @override
  Future<CategoryModel> fetchCategory(String limit) async {
    Response response =
        await dio.get('${baseUrl}categories?offset=1&limit=$limit');
    Map<String, dynamic> data = json.decode(response.toString());
    CategoryModel category = CategoryModel.fromMap(data);
    return category;
  }

  @override
  Future<ProductsModel> fetchProducts(String limit, String token,
      {String searchText = '', String category = '', String owner = ''}) async {
    print('OWNER   $token');
    Response response;
    if (token.isNotEmpty) {
      response = await dio.get(
          '${baseUrl}products/?offset=1&limit=$limit&search=$searchText&category=$category&owner=$owner',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token',
          }));
    } else {
      response = await dio.get(
          '${baseUrl}products/?offset=1&limit=$limit&search=$searchText&category=$category&owner=$owner');
    }
    Map<String, dynamic> data = json.decode(response.toString());
    ProductsModel productsModel = ProductsModel.fromJson(data);
    return productsModel;
  }

  @override
  Future<List<ResultProducts>> fetchMyProducts(
      String? limit, String token) async {
    Response response =
        await dio.get('${baseUrl}products/my-products/?offset=1&limit=$limit',
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Token $token',
            }));
    List<dynamic> data;
    if (response.data is String) {
      data = jsonDecode(response.data);
    } else {
      data = response.data;
    }

    List<ResultProducts> resultProducts =
        data.map((json) => ResultProducts.fromJson(json)).toList();
    return resultProducts;
  }

  @override
  Future<String> sendEmailForCode(String email) async {
    Response response =
        await dio.get('${baseUrl}accounts/reset-password/get-code/$email');
    return response.data['detail'].toString();
  }

  @override
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
  ) async {
    try {
      var myInt = int.parse(price);
      final imageBytes1 = await photos[0].readAsBytes();
      MultipartFile file1 = MultipartFile.fromBytes(
        imageBytes1,
        filename: '${DateTime.now()}.png',
      );

      print(ownerPhone);
      FormData formData = FormData.fromMap({
        "owner": jsonEncode({
          "email": email,
          "first_name": firstName,
          "last_name": lastName,
          "middle_name": middleName,
          "phone": phone,
        }),
        "photo": file1,
        "name": name,
        "description": description,
        "price": myInt,
        "owner_name": ownerName,
        "owner_phone": ownerPhone,
        "owner_email": ownerEmail,
        "address": address,
        "category": category,
      });

      Response response = await dio.post(
        '${baseUrl}products/',
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Token $token',
          },
        ),
        data: formData,
      );
      var asi = response.data['id'].toString();
      for (var element in photos) {
        addPhoto(token, asi, element);
      }
      talker.info(response.data['photo']);
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print('lkasdglasdkfmn${e.message}');
      }
      rethrow;
    } catch (e, sta) {
      print('Other error: $e');
      talker.handle('OLD    $sta');
      rethrow;
    }
  }

  Future<void> addPhoto(String token, String id, File photo) async {
    // String fileName =photos.path.split('/').last;

    final imageBytes = await photo.readAsBytes();
    MultipartFile file = MultipartFile.fromBytes(
      imageBytes,
      filename: '${DateTime.now()}.png',
    );
    var myInt = int.parse(id);

    FormData formData = FormData.fromMap({
      "product": myInt,
      "photo": file,
    });
    try {
      Response response = await dio.post(
        '${baseUrl}product-photos/',
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Token $token',
          },
        ),
        data: formData,
      );
      talker.info(response.statusCode);
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print(e.message);
      }
      rethrow; // Проброс ошибки дальше
    } catch (e) {
      print('Other error: $e');
      rethrow; // Проброс ошибки дальше
    }
  }

  @override
  Future<void> deleteProducts(String token, int id) async {
    await dio.delete(
      '${baseUrl}products/$id/',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ),
    );
  }

  @override
  Future<ProductsModel> fetchSearchProduct(
      String token, String searchText) async {
    Response response = await dio.get('${baseUrl}products/?search=$searchText',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        }));
    Map<String, dynamic> data = json.decode(response.toString());
    ProductsModel productsModel = ProductsModel.fromJson(data);
    return productsModel;
  }

  @override
  Future<void> sendPasswordForRest(
      int code, String password, String passwordConfirm) async {
    Map<String, dynamic> body = {
      'password': password,
      'password_confirm': passwordConfirm,
    };
    Response response = await dio.post(
      '${baseUrl}accounts/reset-password/$code',
      data: body,
    );
    talker.info(response.statusCode);
    talker.info(response.data);
  }

  @override
  Future<ResultProducts> fetchProductDetail(int id, String token) async {
    Response response = await dio.get('${baseUrl}products/$id',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        }));
    Map<String, dynamic> data = json.decode(response.toString());
    ResultProducts resultProductsModel = ResultProducts.fromJson(data);
    return resultProductsModel;
  }

  @override
  Future<AdvertisementsModel> fetchAdvertisements(String limit) async {
    Response response =
        await dio.get('${baseUrl}advertisings/?offset=1&limit=$limit');
    Map<String, dynamic> data = json.decode(response.toString());
    AdvertisementsModel advertisementsModel = AdvertisementsModel.fromMap(data);
    return advertisementsModel;
  }

  @override
  Future<FavoritesModel> fetchFavorites(String limit, String token) async {
    final response = await dio.get('http://195.49.215.94/api/v1/favorites/',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        }));

    Map<String, dynamic> data = json.decode(response.toString());
    FavoritesModel favoritesModel = FavoritesModel.fromJson(data);
    return favoritesModel;
  }

  @override
  Future<void> deleteFavorites(String id, String token) async {
    await dio.delete(
      '${baseUrl}favorites/$id/',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ),
    );
  }

  @override
  Future<void> addFavorites(String productId, String token) async {
    Map<String, dynamic> body = {'product': productId};
    await dio.post(
      '${baseUrl}favorites/',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ),
      data: json.encode(body),
    );
  }

  @override
  Future<NotificationModel> getListNotification(
    String token,
    int limit,
  ) async {
    Response response = await dio.get(
      '${baseUrl}notifications/?limit=$limit',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ),
    );
    printLongString('---reee$response');

    Map<String, dynamic> data = json.decode(response.toString());
    NotificationModel notificationModel = NotificationModel.fromMap(data);
    return notificationModel;
  }

  @override
  Future<RegisterModel> fetchRegister(String email, String password) async {
    Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };
    Response response = await dio.post(
      '${baseUrl}accounts/register/',
      data: json.encode(body),
    );
    Map<String, dynamic> data = json.decode(response.toString());
    RegisterModel registerModel = RegisterModel.fromJson(data);
    return registerModel;
  }

  @override
  Future<ConfirmModel> fetchConfirm(int code) async {
    Response response = await dio.get(
      '${baseUrl}accounts/register/$code',
    );
    Map<String, dynamic> data = json.decode(response.toString());
    ConfirmModel confirmModel = ConfirmModel.fromJson(data);
    return confirmModel;
  }

  @override
  Future<ConfirmModel> loginAccount(String email, String password) async {
    Map<String, dynamic> body = {
      'login': email,
      'password': password,
    };
    Response response =
        await dio.post('${baseUrl}accounts/login/', data: json.encode(body));

    Map<String, dynamic> data = json.decode(response.toString());

    ConfirmModel confirmModel = ConfirmModel.fromJson(data);
    return confirmModel;
  }

  @override
  Future<String> logoutAccount(String token, bool revoke) async {
    Map<String, dynamic> body = {
      'revoke_token': revoke,
    };

    Response response = await dio.post(
      '${baseUrl}accounts/logout/',
      data: json.encode(body),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ),
    );
    Map<String, dynamic> data = json.decode(response.toString());
    return data['message'];
  }

  @override
  Future<Owner> fetchProfile(String token) async {
    Response response = await dio.get(
      '${baseUrl}accounts/profile/',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ),
    );
    Map<String, dynamic> data = json.decode(response.toString());
    Owner owner = Owner.fromJson(data);
    Pref().saveId(owner.id);
    return owner;
  }

  @override
  Future<ReviewsModel> fetchReviews(String token, String user) async {
    Response response = await dio.get(
      '${baseUrl}reviews/?salesman=$user',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ),
    );
    Map<String, dynamic> data = json.decode(response.toString());
    ReviewsModel reviewsModel = ReviewsModel.fromJson(data);
    return reviewsModel;
  }

  @override
  Future<ResultReviews> reviews(
      String token, int user, int product, int rating, String text) async {
    Map<String, dynamic> body = {
      'text': text,
      'rating': rating,
      'product': product,
      'salesman': user,
    };
    Response response = await dio.post(
      '${baseUrl}reviews/',
      data: json.encode(body),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ),
    );

    Map<String, dynamic> data = json.decode(response.toString());

    ResultReviews resultReviews = ResultReviews.fromJson(data);
    return resultReviews;
  }

  @override
  Future<void> sendToken(
      String tokenPush, String platform, String tokenUser) async {
    Map<String, dynamic> body = {
      'registration_id': tokenPush,
      'type': platform,
    };
    Response response = await dio.post(
      '${baseUrl}fcm-devices/',
      data: json.encode(body),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $tokenUser',
        },
      ),
    );
    print('Status code');
    print(response.statusCode);
  }

  @override
  Future<String> getCityName(Position position) async {
    final response = await dio.get(
      'https://nominatim.openstreetmap.org/reverse',
      queryParameters: {
        'lat': position.latitude,
        'lon': position.longitude,
        'format': 'json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.toString());
      final address = data['address'];

      if (address != null && address['city'] != null) {
        return address['city'];
      } else if (address['village'] != null) {
        return address['village'];
      } else {
        return 'Город не найден';
      }
    } else {
      throw Exception('Ошибка при получении города');
    }
  }

  @override
  Future<ChatRoomModel> getRoom(String token, bool buy) async {
    Response response = await dio.get(
      '${baseUrl}chat/rooms/?type=${buy ? 'buying' : 'selling'}',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ),
    );
    print('$token');
    printLongString('${response}');
    Map<String, dynamic> data = json.decode(response.toString());
    ChatRoomModel chatRoomModel = ChatRoomModel.fromJson(data);
    return chatRoomModel;
  }

  void printLongString(String text) {
    final RegExp pattern = RegExp('.{1,800}');
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => print(match.group(0)));
  }

  @override
  Future<ChatRoomResultsModel> createRoom(
      String token, String name, int user, int productId, String? uuid) async {
    if (uuid == null) {
      Response response = await dio.post(
        '${baseUrl}chat/create-chat/',
        data:
            json.encode({"name": name, "user": user, "product_id": productId}),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );
      print('----22${response}');
      try {
        Map<String, dynamic> data = json.decode(response.toString());
        ChatRoomResultsModel chatRoomModel =
            ChatRoomResultsModel.fromJson(data);
      } catch (e) {
        print('----$e');
      }
      Map<String, dynamic> data = json.decode(response.toString());
      ChatRoomResultsModel chatRoomModel = ChatRoomResultsModel.fromJson(data);
      print('----22${chatRoomModel}');
      return chatRoomModel;
    } else {
      Response response = await dio.get(
        '${baseUrl}chat/rooms/${uuid}/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );
      print('----33${response}');
      Map<String, dynamic> data = json.decode(response.toString());
      ChatRoomResultsModel chatRoomModel = ChatRoomResultsModel.fromJson(data);
      return chatRoomModel;
    }
  }

  @override
  Future<MessagesOldModel> getOldMessages(String token, String uuid) async {
    Response response = await dio.get(
      '${baseUrl}chat/messages/room/${uuid}',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ),
    );
    Map<String, dynamic> data = json.decode(response.toString());
    MessagesOldModel chatRoomModel = MessagesOldModel.fromJson(data);
    return chatRoomModel;
  }

  @override
  Future<void> uploadMessageImage(
      String token, String uuid, XFile image) async {
    final imageBytes = await image.readAsBytes();
    MultipartFile file = MultipartFile.fromBytes(
      imageBytes,
      filename: '${DateTime.now()}.png',
    );

    FormData formData = FormData.fromMap({
      "photo": file,
    });
    Response response = await dio.post(
      '${baseUrl}chat/messages/upload-file/${uuid}',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ),
      data: formData,
    );
    print('----res:${response}');
    return;
  }

  @override
  Future<void> sendReport(String token, String header, String name,
      String email, String phone, String content) async {
    var res = await dio.post(
      '${baseUrl}chat/request-for-supports/',
      data: json.encode({
        "header": header,
        "name": name,
        "email": email,
        "phone": phone,
        "content": content
      }),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ),
    );
    print('---re:${res}');
    return;
  }
}
