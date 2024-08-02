import 'dart:convert';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;
import 'package:talker_flutter/talker_flutter.dart';

String title =
    'Эти наушники — верный спутник в мире звука и стиля. С их элегантным дизайном и превосходным качеством звучания вы погружаетесь в музыкальный опыт нового уровня. Наушники идеально сбалансированы между комфортом и функциональностью, обеспечивая чистоту звука и ясные высокие частоты. Идеальный выбор для тех, кто ценит каждую ноту и стремится к идеальному звучанию в любой обстановке.';
final talker = GetIt.I<Talker>();
// Future<Review?> postReviews(TestReviews data) async {
//   try {
//     FormData formData = FormData();
//
//     formData.fields.add(MapEntry('resort', data.resort));
//     formData.fields.add(MapEntry('text', data.text));
//     formData.fields.add(MapEntry('rating', data.rating.toString()));
//
//     // Добавляем изображения в FormData
//     try {
//       for (int i = 0; i < data.images.length; i++) {
//         String fileName = data.images[i].path.split('/').last;
//         final imageBytes = await data.images[i].readAsBytes();
//         MultipartFile file = await MultipartFile.fromBytes(
//           imageBytes,
//           filename: fileName,
//         );
//         formData.files.add(MapEntry('file$i', file));
//       }
//     } catch (e) {
//       print("Error uploading image: $e");
//     }
//     print(formData);
//     final response = await _dio.post(
//       _baseUrl + ApiConfigUser.postReviews,
//       options: ApiConfigUser.userHeaders,
//       data: formData,
//     );
//     print(response.data);
//   } on DioException catch (e) {
//     print('postReviews ERROR $e');
//   }
//   return null;
// }



/// // void paginationCategoryFun(bool paginate, int limitList) {
//   //   shouldPaginate = paginate;
//   //   if (shouldPaginate == false) {
//   //     isLoading.value = false;
//   //     limitCategory.value = limitList;
//   //     loadCategoryData();
//   //   } else {
//   //     loadCategoryData();
//   //     _scrollCategoryController.addListener(_scrollCategoryListener);
//   //   }
//   // }
//
//   void _scrollCategoryListener() {
//     if (_scrollCategoryController.offset >=
//             _scrollCategoryController.position.maxScrollExtent &&
//         !_scrollCategoryController.position.outOfRange) {
//       // Достигнут конец списка, обработка пагинации здесь
//       // Вызовите метод загрузки новых данных
//       if (shouldPaginate) {
//         _loadCategoryMoreData();
//       }
//     }
//   }
//
//   void _loadCategoryMoreData() {
//     limitCategory.value += 30;
//     isLoading.value = true;
//     loadCategoryData();
//   }

class ToImageData {
  static String imagetoData(String? imagepath) {
    final extension = path.extension(
      imagepath!.substring(imagepath.lastIndexOf("/")).replaceAll("/", ""),
    );
    final bytes = File(imagepath).readAsBytesSync();
    String base64 =
        "data:image/${extension.replaceAll(".", "")};base64,${base64Encode(bytes)}";
    return base64;
  }
}