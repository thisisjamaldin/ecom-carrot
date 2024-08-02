import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../generated/assets.dart';
import '../router/router.dart';
import '../theme/color_res.dart';
import 'bottom_nav_page.dart';

class BottomNavigate extends StatelessWidget {
  const BottomNavigate({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      enableFeedback: true,
      useLegacyColorScheme: true,
      showSelectedLabels: true,
      mouseCursor: MaterialStateMouseCursor.textable,
      currentIndex: index,
      elevation: 0,
      onTap: (index) async {
        switch (index) {
          case 0:
            await AutoRouter.of(context).replaceAll([const MainRoute()]);
            break;
          case 1:
            await AutoRouter.of(context).replaceAll([const FavoriteRoute()]);
            break;
          case 2:
            await AutoRouter.of(context).replaceAll([const CreateRoute()]);
            break;
          case 3:
            await AutoRouter.of(context).replaceAll([const MessageRoute()]);
            break;
          case 4:
            await AutoRouter.of(context).replaceAll([const ProfileRoute()]);
            break;
        }
      },
      fixedColor: ColorRes.orange,
      unselectedItemColor: Colors.white,
      showUnselectedLabels: true,
      unselectedIconTheme: const IconThemeData(size: 24.0),
      unselectedFontSize: 10.0,
      selectedLabelStyle: const TextStyle(fontSize: 10),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      selectedIconTheme: const IconThemeData(size: 24.0),
      selectedFontSize: 10.0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: ColorRes.dark,
      items: [
        bottomItem(Assets.iconsHome,
            index == 0 ? ColorRes.orange : Colors.white, 'Главная'),
        bottomItem(Assets.iconsHeart,
            index == 1 ? ColorRes.orange : Colors.white, 'Избранное'),
        bottomItem(Assets.iconsCreate,
            index == 2 ? ColorRes.orange : Colors.white, 'Создать'),
        bottomItem(Assets.iconsMessage,
            index == 3 ? ColorRes.orange : Colors.white, 'Сообщения'),
        bottomItem(Assets.iconsProfile,
            index == 4 ? ColorRes.orange : Colors.white, 'Профиль'),
      ],
    );
  }
}
