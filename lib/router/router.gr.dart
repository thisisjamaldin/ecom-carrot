// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AllProductOwnerRoute.name: (routeData) {
      final args = routeData.argsAs<AllProductOwnerRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AllProductOwnerPage(
          key: args.key,
          products: args.products,
        ),
      );
    },
    AllProductRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AllProductPage(),
      );
    },
    AllReviewsRoute.name: (routeData) {
      final args = routeData.argsAs<AllReviewsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AllReviewsPage(
          key: args.key,
          id: args.id,
        ),
      );
    },
    AuthRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthPage(),
      );
    },
    BottomNavRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BottomNavPage(),
      );
    },
    ConfirmRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ConfirmPage(),
      );
    },
    CreateRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CreatePage(),
      );
    },
    DetailNotificationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DetailNotificationPage(),
      );
    },
    DetailProductRoute.name: (routeData) {
      final args = routeData.argsAs<DetailProductRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DetailProductPage(
          key: args.key,
          id: args.id,
          idReviews: args.idReviews,
        ),
      );
    },
    FavoriteRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FavoritePage(),
      );
    },
    MainAuthRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainAuthPage(),
      );
    },
    MainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainPage(),
      );
    },
    MessageDetailRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MessageDetailPage(),
      );
    },
    MessageRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MessagePage(),
      );
    },
    NotificationRoute.name: (routeData) {
      final args = routeData.argsAs<NotificationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NotificationPage(
          key: args.key,
          isProfile: args.isProfile,
        ),
      );
    },
    HelpRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HelpPage(),
      );
    },
    PhotoDetailRoute.name: (routeData) {
      final args = routeData.argsAs<PhotoDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PhotoDetailPage(
          key: args.key,
          photos: args.photos,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfilePage(),
      );
    },
    ProfileEditRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileEditRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfileEditPage(
          blocProfile: args.bloc,
        ),
      );
    },
    RecoverPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RecoverPasswordPage(),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
    SellerProfileRoute.name: (routeData) {
      final args = routeData.argsAs<SellerProfileRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SellerProfilePage(
          key: args.key,
          products: args.products,
        ),
      );
    },
    WriteEmailRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WriteEmailPage(),
      );
    },
    WriteReviewsRoute.name: (routeData) {
      final args = routeData.argsAs<WriteReviewsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WriteReviewsPage(
          key: args.key,
          products: args.products,
        ),
      );
    },
  };
}

/// generated route for
/// [AllProductOwnerPage]
class AllProductOwnerRoute extends PageRouteInfo<AllProductOwnerRouteArgs> {
  AllProductOwnerRoute({
    Key? key,
    required ResultProducts products,
    List<PageRouteInfo>? children,
  }) : super(
          AllProductOwnerRoute.name,
          args: AllProductOwnerRouteArgs(
            key: key,
            products: products,
          ),
          initialChildren: children,
        );

  static const String name = 'AllProductOwnerRoute';

  static const PageInfo<AllProductOwnerRouteArgs> page =
      PageInfo<AllProductOwnerRouteArgs>(name);
}

class AllProductOwnerRouteArgs {
  const AllProductOwnerRouteArgs({
    this.key,
    required this.products,
  });

  final Key? key;

  final ResultProducts products;

  @override
  String toString() {
    return 'AllProductOwnerRouteArgs{key: $key, products: $products}';
  }
}

/// generated route for
/// [AllProductPage]
class AllProductRoute extends PageRouteInfo<void> {
  const AllProductRoute({List<PageRouteInfo>? children})
      : super(
          AllProductRoute.name,
          initialChildren: children,
        );

  static const String name = 'AllProductRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AllReviewsPage]
class AllReviewsRoute extends PageRouteInfo<AllReviewsRouteArgs> {
  AllReviewsRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          AllReviewsRoute.name,
          args: AllReviewsRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'AllReviewsRoute';

  static const PageInfo<AllReviewsRouteArgs> page =
      PageInfo<AllReviewsRouteArgs>(name);
}

class AllReviewsRouteArgs {
  const AllReviewsRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'AllReviewsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [AuthPage]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
      : super(
          AuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [BottomNavPage]
class BottomNavRoute extends PageRouteInfo<void> {
  const BottomNavRoute({List<PageRouteInfo>? children})
      : super(
          BottomNavRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ConfirmPage]
class ConfirmRoute extends PageRouteInfo<void> {
  const ConfirmRoute({List<PageRouteInfo>? children})
      : super(
          ConfirmRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConfirmRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CreatePage]
class CreateRoute extends PageRouteInfo<void> {
  const CreateRoute({List<PageRouteInfo>? children})
      : super(
          CreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DetailNotificationPage]
class DetailNotificationRoute extends PageRouteInfo<void> {
  const DetailNotificationRoute({List<PageRouteInfo>? children})
      : super(
          DetailNotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'DetailNotificationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DetailProductPage]
class DetailProductRoute extends PageRouteInfo<DetailProductRouteArgs> {
  DetailProductRoute({
    Key? key,
    required int id,
    required int idReviews,
    List<PageRouteInfo>? children,
  }) : super(
          DetailProductRoute.name,
          args: DetailProductRouteArgs(
            key: key,
            id: id,
            idReviews: idReviews,
          ),
          initialChildren: children,
        );

  static const String name = 'DetailProductRoute';

  static const PageInfo<DetailProductRouteArgs> page =
      PageInfo<DetailProductRouteArgs>(name);
}

class DetailProductRouteArgs {
  const DetailProductRouteArgs({
    this.key,
    required this.id,
    required this.idReviews,
  });

  final Key? key;

  final int id;

  final int idReviews;

  @override
  String toString() {
    return 'DetailProductRouteArgs{key: $key, id: $id, idReviews: $idReviews}';
  }
}

/// generated route for
/// [FavoritePage]
class FavoriteRoute extends PageRouteInfo<void> {
  const FavoriteRoute({List<PageRouteInfo>? children})
      : super(
          FavoriteRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavoriteRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainAuthPage]
class MainAuthRoute extends PageRouteInfo<void> {
  const MainAuthRoute({List<PageRouteInfo>? children})
      : super(
          MainAuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainAuthRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MessageDetailPage]
class MessageDetailRoute extends PageRouteInfo<void> {
  const MessageDetailRoute({List<PageRouteInfo>? children})
      : super(
          MessageDetailRoute.name,
          initialChildren: children,
        );

  static const String name = 'MessageDetailRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MessagePage]
class MessageRoute extends PageRouteInfo<void> {
  const MessageRoute({List<PageRouteInfo>? children})
      : super(
          MessageRoute.name,
          initialChildren: children,
        );

  static const String name = 'MessageRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotificationPage]
class NotificationRoute extends PageRouteInfo<NotificationRouteArgs> {
  NotificationRoute({
    Key? key,
    required bool isProfile,
    List<PageRouteInfo>? children,
  }) : super(
          NotificationRoute.name,
          args: NotificationRouteArgs(
            key: key,
            isProfile: isProfile,
          ),
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const PageInfo<NotificationRouteArgs> page =
      PageInfo<NotificationRouteArgs>(name);
}

class NotificationRouteArgs {
  const NotificationRouteArgs({
    this.key,
    required this.isProfile,
  });

  final Key? key;

  final bool isProfile;

  @override
  String toString() {
    return 'NotificationRouteArgs{key: $key, isProfile: $isProfile}';
  }
}

/// generated route for
/// [HelpPage]
class HelpRoute extends PageRouteInfo<void> {
  HelpRoute()
      : super(
          HelpRoute.name,
        );

  static const String name = 'HelpRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PhotoDetailPage]
class PhotoDetailRoute extends PageRouteInfo<PhotoDetailRouteArgs> {
  PhotoDetailRoute({
    Key? key,
    required List<Photo> photos,
    List<PageRouteInfo>? children,
  }) : super(
          PhotoDetailRoute.name,
          args: PhotoDetailRouteArgs(
            key: key,
            photos: photos,
          ),
          initialChildren: children,
        );

  static const String name = 'PhotoDetailRoute';

  static const PageInfo<PhotoDetailRouteArgs> page =
      PageInfo<PhotoDetailRouteArgs>(name);
}

class PhotoDetailRouteArgs {
  const PhotoDetailRouteArgs({
    this.key,
    required this.photos,
  });

  final Key? key;

  final List<Photo> photos;

  @override
  String toString() {
    return 'PhotoDetailRouteArgs{key: $key, photos: $photos}';
  }
}

class ProfileEditRouteArgs {
  const ProfileEditRouteArgs({
    required this.bloc,
  });

  final ProfileBloc bloc;

  @override
  String toString() {
    return 'ProfileEditRouteArgs{photos: $bloc}';
  }
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileEditPage]
class ProfileEditRoute extends PageRouteInfo<ProfileEditRouteArgs> {
  ProfileEditRoute({List<PageRouteInfo>? children, required ProfileBloc bloc})
      : super(
          ProfileEditRoute.name,
          args: ProfileEditRouteArgs(
            bloc: bloc,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileEditRoute';

  static const PageInfo<ProfileEditRouteArgs> page =
      PageInfo<ProfileEditRouteArgs>(name);
}

/// generated route for
/// [RecoverPasswordPage]
class RecoverPasswordRoute extends PageRouteInfo<void> {
  const RecoverPasswordRoute({List<PageRouteInfo>? children})
      : super(
          RecoverPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'RecoverPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SellerProfilePage]
class SellerProfileRoute extends PageRouteInfo<SellerProfileRouteArgs> {
  SellerProfileRoute({
    Key? key,
    required ResultProducts products,
    List<PageRouteInfo>? children,
  }) : super(
          SellerProfileRoute.name,
          args: SellerProfileRouteArgs(
            key: key,
            products: products,
          ),
          initialChildren: children,
        );

  static const String name = 'SellerProfileRoute';

  static const PageInfo<SellerProfileRouteArgs> page =
      PageInfo<SellerProfileRouteArgs>(name);
}

class SellerProfileRouteArgs {
  const SellerProfileRouteArgs({
    this.key,
    required this.products,
  });

  final Key? key;

  final ResultProducts products;

  @override
  String toString() {
    return 'SellerProfileRouteArgs{key: $key, products: $products}';
  }
}

/// generated route for
/// [WriteEmailPage]
class WriteEmailRoute extends PageRouteInfo<void> {
  const WriteEmailRoute({List<PageRouteInfo>? children})
      : super(
          WriteEmailRoute.name,
          initialChildren: children,
        );

  static const String name = 'WriteEmailRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WriteReviewsPage]
class WriteReviewsRoute extends PageRouteInfo<WriteReviewsRouteArgs> {
  WriteReviewsRoute({
    Key? key,
    required ResultProducts products,
    List<PageRouteInfo>? children,
  }) : super(
          WriteReviewsRoute.name,
          args: WriteReviewsRouteArgs(
            key: key,
            products: products,
          ),
          initialChildren: children,
        );

  static const String name = 'WriteReviewsRoute';

  static const PageInfo<WriteReviewsRouteArgs> page =
      PageInfo<WriteReviewsRouteArgs>(name);
}

class WriteReviewsRouteArgs {
  const WriteReviewsRouteArgs({
    this.key,
    required this.products,
  });

  final Key? key;

  final ResultProducts products;

  @override
  String toString() {
    return 'WriteReviewsRouteArgs{key: $key, products: $products}';
  }
}
