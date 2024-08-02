import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:russsia_carrot/data/firebase/notification_service.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:russsia_carrot/repository/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'carrot_app.dart';
import 'data/local/pref.dart';

main() async {
  ///Firebase
  WidgetsFlutterBinding.ensureInitialized();
  PushNotificationService().init();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  ///Talker
  final talker = TalkerFlutter.init(
      settings: TalkerSettings(
    maxHistoryItems: 30,
    titles: {TalkerLogType.exception: 'Error: '},
    enabled: true,
  ));
  GetIt.I.registerSingleton(talker);
  GetIt.I<Talker>();

  final talkerDioLogger = TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printResponseHeaders: false,
        printResponseData: false,
      ));

  ///Dio
  final Dio dio = Dio();
  dio.interceptors.add(talkerDioLogger);

  ///Event Bus
  GetIt.I.registerSingleton(EventBus());

  ///Repository
  GetIt.I.registerLazySingleton<AbstractRepository>(() => Repository(dio: dio));

  ///Shared Preferences
  GetIt.I.registerSingleton(await SharedPreferences.getInstance());
  GetIt.I.registerFactory<Pref>(() => Pref());

  // final pref = Pref();

  // var repo = GetIt.I<AbstractRepository>();
  // repo.addProducts(
  //   pref.getToken(),
  //   AddProductsModel(
  //     owner: Owner(id: 1,image: '',chatUiid: '',completedTransactions: 1,email: '',firstName: '',getFullName: '',lastName: ''),
  //     photos: [],
  //     name: '', description: '', price: '', ownerName: '', ownerPhone: '', ownerEmail: '', address: '', category: null,
  //   ),
  // );
  
  runApp(CarrotApp());
}
