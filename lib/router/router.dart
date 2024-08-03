import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:russsia_carrot/data/local/Pref.dart';
import 'package:russsia_carrot/data/model/products_model.dart';
import 'package:russsia_carrot/features/bloc_profile/profile_bloc.dart';
import 'package:russsia_carrot/ui/auth/auth_page.dart';
import 'package:russsia_carrot/ui/auth/confirm_page.dart';
import 'package:russsia_carrot/ui/auth/main_auth_page.dart';
import 'package:russsia_carrot/ui/auth/register_page.dart';
import 'package:russsia_carrot/ui/main/all_product/all_product_owner_page.dart';
import 'package:russsia_carrot/ui/main/notification/detail_notification_page.dart';
import 'package:russsia_carrot/ui/profile/help.dart';
import 'package:russsia_carrot/ui/profile/profile_edit.dart';
import 'package:russsia_carrot/ui/profile/seller_profile_page.dart';
import 'package:flutter/cupertino.dart';

import '../ui/auth/recover_password_page.dart';
import '../ui/auth/write_email_page.dart';
import '../ui/bottom_nav_page.dart';
import '../ui/create/create_page.dart';
import '../ui/favorite/favorite_page.dart';
import '../ui/main/all_product/all_product_page.dart';
import '../ui/main/detail_product/detail_product_page.dart';
import '../ui/main/detail_product/photo_detail_page.dart';
import '../ui/main/main_page.dart';
import '../ui/main/notification/notification_page.dart';
import '../ui/message/message_detail_page.dart';
import '../ui/message/message_page.dart';
import '../ui/profile/profile_page.dart';
import '../ui/reviews/all_reviews_page.dart';
import '../ui/reviews/write_reviews_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  bool startAuth = false;
  final pref = Pref();

  @override
  List<AutoRoute> get routes => [
        ///Auth
        AutoRoute(page: MainAuthRoute.page,initial: startAuth),
        AutoRoute(page: AuthRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: ConfirmRoute.page),
        AutoRoute(page: RecoverPasswordRoute.page),
        AutoRoute(page: WriteEmailRoute.page),

        ///Seller Profile
        AutoRoute(page: SellerProfileRoute.page),
          AutoRoute(page: ProfileEditRoute.page),

        ///Bottom Navigation
        AutoRoute(page: BottomNavRoute.page, initial: !startAuth, children: [
          AutoRoute(page: MainRoute.page),
          AutoRoute(page: FavoriteRoute.page),
          AutoRoute(page: CreateRoute.page),
          AutoRoute(page: MessageRoute.page),
          AutoRoute(page: ProfileRoute.page),
        ]),

        ///Detail
        AutoRoute(page: DetailProductRoute.page, path: '/detail-product/:id/:idReviews'),
        AutoRoute(page: AllProductRoute.page),
        AutoRoute(page: AllProductOwnerRoute.page),
        AutoRoute(page: PhotoDetailRoute.page),

        ///Message
        AutoRoute(page: MessageDetailRoute.page),

        ///Notification
        AutoRoute(page: NotificationRoute.page),
        AutoRoute(page: DetailNotificationRoute.page),

        ///Profile
        AutoRoute(page: HelpRoute.page),

        AutoRoute(page: AllProductRoute.page),
        AutoRoute(page: AllReviewsRoute.page),
        AutoRoute(page: WriteReviewsRoute.page)
      ];
}
