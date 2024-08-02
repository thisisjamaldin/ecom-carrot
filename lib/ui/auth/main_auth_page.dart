import 'package:auto_route/auto_route.dart';
import 'package:russsia_carrot/theme/color_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../generated/assets.dart';
import '../../router/router.dart';

@RoutePage()
class MainAuthPage extends StatefulWidget {
  const MainAuthPage({super.key});

  @override
  State<MainAuthPage> createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<MainAuthPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SvgPicture.asset('assets/icons/carrot.svg'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 21,
                    ),
                    const Text(
                      "Войдите, чтобы создавать объявления,\nпросматривать и вести чат с продавцами",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    GestureDetector(
                      onTap: () => AutoRouter.of(context).push(const AuthRoute()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 42.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorRes.orange),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          child: const Text(
                            "Войти",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    GestureDetector(
                      onTap: () =>
                          AutoRouter.of(context).push(const RegisterRoute()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 42.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorRes.grey),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          child: const Text(
                            "Зарегистрироваться",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 31,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Stack(
                        children: [
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Container(
                          //         height: 1,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //     const Padding(
                          //       padding: EdgeInsets.symmetric(horizontal: 9.0),
                          //       child: Text("Или"),
                          //     ),
                          //     Expanded(
                          //       child: Container(
                          //         height: 1,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     GestureDetector(
                    //         onTap: () {
                    //           // TODO:Дописать авторизацию по Google
                    //         },
                    //         child: SvgPicture.asset(Assets.iconsGoogle)),
                    //     const SizedBox(
                    //       width: 20,
                    //     ),
                    //     GestureDetector(
                    //         onTap: () {
                    //           // TODO:Дописать авторизацию по Facebook
                    //         },
                    //         child: SvgPicture.asset(Assets.iconsFacebook)),
                    //   ],
                    // )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
