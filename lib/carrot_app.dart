import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:russsia_carrot/features/bloc_chat/chat_bloc.dart';
import 'package:russsia_carrot/features/cubit_save_token/save_token_cubit.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:russsia_carrot/router/router.dart';
import 'package:russsia_carrot/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uni_links/uni_links.dart';

import 'data/firebase/notification_service.dart';
import 'data/local/Pref.dart';
import 'features/bloc_favorites/favorites_bloc.dart';
import 'features/bloc_products/products_bloc.dart';
import 'features/cubit_save_email/save_eamail_cubit.dart';
import 'features/cubit_save_name/save_number_cubit.dart';
import 'features/cubit_save_number/save_name_cubit.dart';

class CarrotApp extends StatefulWidget {
  const CarrotApp({super.key});

  @override
  State<CarrotApp> createState() => _CarrotAppState();
}

class _CarrotAppState extends State<CarrotApp> {
  final _appRouter = AppRouter();
  final pref = Pref();
  final repository = GetIt.I<AbstractRepository>();
  // NotificationService service = NotificationService();

  Position? _currentPosition;

  Future<void> _getCurrentLocation() async {
    final permission = await Permission.location.request();
    if (permission.isGranted) {
      try {
        _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {});
      } catch (e) {
        print(e);
      }
    } else if (permission.isDenied || permission.isPermanentlyDenied) {
      // Пользователь отклонил или навсегда отклонил запрос на разрешение
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Разрешение отклонено'),
          content: Text(
              'Пожалуйста, предоставьте доступ к геолокации в настройках приложения.'),
          actions: [
            TextButton(
              child: Text('ОК'),
              onPressed: () {
                Navigator.of(context).pop();
                AppSettings.openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    if (_currentPosition == null) {
      _getCurrentLocation();
    }
    _handleIncomingLinks();
    // WidgetsFlutterBinding.ensureInitialized();
    // PushNotificationService().init();
    // AppSettings.openAppSettings(type: AppSettingsType.location);
    // service.requestNotificationPermission();
    // service.foregroundMessage();
    // service.firebaseInit(context);
    // service.setupInteractMessage(context);
    // service.isTokenRefresh();
    // service.getDeviceToken().then((String tokenValue) {
    if (pref.getToken().isNotEmpty) {
      print(pref.getToken());
      print('pref.getToken()');
      // print(tokenValue);
      // pref.savePushToken(tokenValue);
      print(pref.getPushToken());
      // if (pref.getPushToken() != tokenValue) {
      // if (Platform.isAndroid) {
      // repository.sendToken(tokenValue, 'android', pref.getToken());
      // } else if (Platform.isIOS) {
      //   repository.sendToken(tokenValue, 'ios', pref.getToken());
      // }
    }
    // }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SaveTokenCubit(pref: pref),
        ),
        BlocProvider(
          create: (context) => SaveEamailCubit(pref),
        ),
        BlocProvider(
          create: (context) => SaveNumberCubit(pref),
        ),
        BlocProvider(
          create: (context) => SaveNameCubit(pref),
        ),
        BlocProvider(
          create: (context) => FavoritesBloc(repository),
        ),
        BlocProvider(
          create: (context) => ProductsBloc(repository),
        ),
        BlocProvider(
          create: (context) => ChatBloc(repository),
        ),
      ],
      child: BlocBuilder<SaveTokenCubit, SaveTokenState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: darkTheme,
            routerConfig: _appRouter.config(
              navigatorObservers: () => [
                TalkerRouteObserver(GetIt.I<Talker>()),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleIncomingLinks() async {
    // Handle initial link
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      _navigateToRoute(initialLink);
    }

    // Handle link stream
    linkStream.listen((String? link) {
      if (link != null) {
        _navigateToRoute(link);
      }
    }, onError: (err) {
      print('Error handling link: $err');
    });
  }

  void _navigateToRoute(String link) {
    final uri = Uri.parse(link);
    print('----asd${uri}');
    print('----asd${uri.pathSegments}');
    // if (uri.pathSegments.length == 3 && uri.pathSegments.first == 'detail-product') {
    final id = int.tryParse(uri.pathSegments[3]);
    final idReviews = int.tryParse(uri.pathSegments[4]);
    if (id != null && idReviews != null) {
      _appRouter.push(DetailProductRoute(id: id, idReviews: idReviews));
    }
    // }
  }
}
