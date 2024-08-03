import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:russsia_carrot/features/bloc_profile/profile_bloc.dart';
import 'package:russsia_carrot/features/cubit_save_token/save_token_cubit.dart';
import 'package:russsia_carrot/generated/assets.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:russsia_carrot/router/router.dart';
import 'package:russsia_carrot/theme/color_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class ProfileEditPassPage extends StatefulWidget {
  @override
  State<ProfileEditPassPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPassPage> {
  TextEditingController pass1Ctrl = TextEditingController();
  TextEditingController pass2Ctrl = TextEditingController();
  TextEditingController pass3Ctrl = TextEditingController();
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;
  late String token;

  @override
  void initState() {
    super.initState();
    token = context.read<SaveTokenCubit>().state.token;
    if (token.isEmpty) {
      Future.delayed(Duration.zero, () async {
        Navigator.of(context).pop();
        AutoRouter.of(context).replaceAll([MainRoute(), MainAuthRoute()]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: const Text(
            'Пароль',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: SvgPicture.asset(Assets.iconsChevronLeft),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 14,
                ),
                const Text(
                  'Текущий пароль',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                TextField(
                  controller: pass1Ctrl,
                  obscureText: _obscureText1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorRes.grey,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 17),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText1 ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText1 = !_obscureText1;
                        });
                      },
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                const SizedBox(
                  height: 14,
                ),
                const Text(
                  'Новый пароль',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                TextField(
                  controller: pass2Ctrl,
                  obscureText: _obscureText2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorRes.grey,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 17),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText2 ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText2 = !_obscureText2;
                        });
                      },
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                const SizedBox(
                  height: 14,
                ),
                const Text(
                  'Подтверждение пароля',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                TextField(
                  controller: pass3Ctrl,
                  obscureText: _obscureText3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorRes.grey,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 17),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText3 ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText3 = !_obscureText3;
                        });
                      },
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                GestureDetector(
                  onTap: () async {
                     if (pass1Ctrl.text.isEmpty || pass2Ctrl.text.isEmpty || pass3Ctrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Заполните все поля')),
                          );
                          return;
                        }
                        showDialog(
                            context: context,
                            builder: (c) {
                              return Center(
                                child: Container(
                                  padding: EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: ColorRes.grey,
                                  ),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            });
                    var res = await GetIt.I<AbstractRepository>()
                        .changePassword(token, pass1Ctrl.text, pass2Ctrl.text,
                            pass3Ctrl.text);
                    Navigator.pop(context);
                    if (res.isEmpty) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Изменен')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$res')),
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorRes.orange),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    child: const Text(
                      "Изменить",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
