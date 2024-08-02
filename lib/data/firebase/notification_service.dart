// import 'dart:io';
// import 'dart:math';

// import 'package:app_settings/app_settings.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:russsia_carrot/router/router.dart';

// class NotificationService {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void foregroundMessage() async {
//     await messaging.setForegroundNotificationPresentationOptions(
//       sound: true,
//       badge: true,
//       alert: true,
//     );
//   }

//   void requestNotificationPermission() async {
//      await _flutterLocalNotificationsPlugin
//     .resolvePlatformSpecificImplementation<
//         IOSFlutterLocalNotificationsPlugin>()
//     ?.requestPermissions(
//     alert: true,
//     badge: true,
//     sound: true,
//     );
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('user granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('user granted provisional permission');
//     } else {
//       AppSettings.openAppSettings();
//       print('user denied permission');
//     }
//   }

//   void initLocalNotification(
//       BuildContext context, RemoteMessage message) async {
//     var androidInitializationSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitializationSettings = const DarwinInitializationSettings();
//     var initializationSettings = InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iosInitializationSettings,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (details) {
//         handleMessage(context, message);
//       },
//       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//     );
//   }

//   @pragma('vm:entry-point')
//   void notificationTapBackground(NotificationResponse notificationResponse) {
//     print('------notify${notificationResponse}');
//   }

//   void firebaseInit(BuildContext context) async {
//     FirebaseMessaging.onMessage.listen((message) {
//       if (Platform.isAndroid) {
//         initLocalNotification(context, message);
//       }
//       if (Platform.isIOS) {
//         foregroundMessage();
//       }
//       showNotification(message);
//     });
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel chanel = AndroidNotificationChannel(
//       Random.secure().nextInt(100000).toString(),
//       'High important notification',
//     );
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(chanel.id, chanel.name,
//             channelDescription: 'your channel description',
//             importance: Importance.high,
//             priority: Priority.high,
//             ticker: 'ticker');

//     DarwinNotificationDetails darwinNotificationDetails =
//         const DarwinNotificationDetails(
//             presentAlert: true, presentBadge: true, presentSound: true);

//     NotificationDetails notificationDetails = NotificationDetails(
//       iOS: darwinNotificationDetails,
//       android: androidNotificationDetails,
//     );

//     Future.delayed(
//       Duration.zero,
//       () {
//         _flutterLocalNotificationsPlugin.show(
//           0,
//           message.notification!.title,
//           message.notification!.body,
//           notificationDetails,
//         );
//       },
//     );
//   }

//   void remoteMessage(BuildContext context, RemoteMessage message) {}

//   void handleMessage(BuildContext context, RemoteMessage message) {
//     if (message.data['type'] == '') {}
//     AutoRouter.of(context).push(NotificationRoute(isProfile: false));
//   }

//   Future<void> setupInteractMessage(BuildContext context) async {
//     RemoteMessage? initMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

//     if (initMessage != null) {
//       handleMessage(context, initMessage);
//     }

//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       handleMessage(context, event);
//     });
//   }

//   void isTokenRefresh() async {
//     messaging.onTokenRefresh.listen((event) {
//       // print('EVENT $event');
//       event.toString();
//     });
//   }

//   Future<String> getDeviceToken() async {
//     String? token = await messaging.getToken();

//     return token!;
//   }
// }

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:russsia_carrot/data/local/pref.dart';
import 'package:russsia_carrot/firebase_options.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('--asdasd${message}');
  return;
  //background notification
}

class PushNotificationService {
  bool _inited = false;
  init() async {
    if (_inited) return;
    _inited = true;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final notificationSettings =
        await FirebaseMessaging.instance.requestPermission(provisional: true);

// For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    print('---np:${apnsToken}');
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) => CupertinoAlertDialog(
        //     title: Text(title ?? ''),
        //     content: Text(body ?? ''),
        //   ),
        // );
      },
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {});

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (Pref().getToken().isNotEmpty) {
      GetIt.I<AbstractRepository>()
          .sendToken('$fcmToken', Platform.isAndroid? 'android':'ios', Pref().getToken());
    }
    // NotificationRepository().sendToken(
    //     fcmToken ?? '',
    //     Platform.isAndroid
    //         ? (await DeviceInfoPlugin().androidInfo).id
    //         : Platform.isIOS
    //             ? (await DeviceInfoPlugin().iosInfo).identifierForVendor
    //             : '',
    //     Platform.isAndroid
    //         ? 'android'
    //         : Platform.isIOS
    //             ? 'ios'
    //             : '');
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmNewToken) {
      // NotificationRepository().updateToken(fcmNewToken);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print('--asdasd${event}');
      // context
      //     .read<ProfileBloc>()
      //     .add(ProfileGetProfileEvent());
      // FlutterRingtonePlayer().play(
      //   android: AndroidSounds.notification,
      //   ios: IosSounds.glass,
      //   looping: false,
      //   volume: 1,
      // );
      flutterLocalNotificationsPlugin.show(
          event.ttl ?? 0,
          '${event.notification?.title}',
          '${event.notification?.body}',
          const NotificationDetails(
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
              android: AndroidNotificationDetails('carrotrr', 'carrotrr',
                  importance: Importance.max,
                  priority: Priority.high,
                  showWhen: false)));
      print("---message recieved");
      print(event.notification?.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('----Message clicked!');
    });
  }

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
}
