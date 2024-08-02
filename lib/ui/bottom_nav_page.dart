import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:russsia_carrot/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../features/cubit_save_token/save_token_cubit.dart';
import '../generated/assets.dart';
import '../theme/color_res.dart';

@RoutePage()
class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  late String token;

  @override
  void initState() {
    token = context.read<SaveTokenCubit>().state.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        MainRoute(),
         FavoriteRoute(),
        CreateRoute(),
        MessageRoute(),
        ProfileRoute(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
          enableFeedback: true,
          useLegacyColorScheme: true,
          showSelectedLabels: true,
          mouseCursor: MaterialStateMouseCursor.textable,
          currentIndex: tabsRouter.activeIndex,
          elevation: 0,
          onTap: tabsRouter.setActiveIndex,
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
            bottomItem(
                Assets.iconsHome,
                tabsRouter.activeIndex == 0 ? ColorRes.orange : Colors.white,
                'Главная'),
            bottomItem(
                Assets.iconsHeart,
                tabsRouter.activeIndex == 1 ? ColorRes.orange : Colors.white,
                'Избранное'),
            bottomItem(
                Assets.iconsCreate,
                tabsRouter.activeIndex == 2 ? ColorRes.orange : Colors.white,
                'Создать'),
            bottomItem(
                Assets.iconsMessage,
                tabsRouter.activeIndex == 3 ? ColorRes.orange : Colors.white,
                'Сообщения'),
            bottomItem(
                Assets.iconsProfile,
                tabsRouter.activeIndex == 4 ? ColorRes.orange : Colors.white,
                'Профиль'),
          ],
        );
      },
    );
  }
}

BottomNavigationBarItem bottomItem(String image, Color color, String text) {
  return BottomNavigationBarItem(
    backgroundColor: ColorRes.dark,
    icon: Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: SvgPicture.asset(image, color: color),
    ),
    label: text,
  );
}
