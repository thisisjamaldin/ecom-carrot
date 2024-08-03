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
import 'package:russsia_carrot/ui/profile/profile_edit_pass.dart';

@RoutePage()
class ProfileEditPage extends StatefulWidget {
  ProfileBloc blocProfile;

  ProfileEditPage({super.key, required this.blocProfile});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  XFile? profile;
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
    loadData();
  }

  void loadData() {
    widget.blocProfile.add(LoadProfileEvent(token: token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text(
          'Редактировать профиль',
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
      body: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: widget.blocProfile,
        builder: (context, state) {
          if (state is LoadedProfileState) {
            nameCtrl.text = state.owner.firstName;
            phoneCtrl.text = state.owner.phone;
            emailCtrl.text = state.owner.email;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () async {
                          final XFile? image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              profile = image;
                            });
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: profile != null
                                ? Image.file(File(profile!.path))
                                : state.owner.image.isEmpty
                                    ? Image.asset(Assets.imagesPerson)
                                    : Image.network(state.owner.image),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      'Ваше имя',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    TextField(
                      controller: nameCtrl,
                      onChanged: (value) {
                        // checkTextField();
                      },
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: ColorRes.grey,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 17)),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      'Email',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailCtrl,
                      onChanged: (value) {
                        // checkTextField();
                      },
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: ColorRes.grey,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 17)),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      'Телефон',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    TextField(
                      keyboardType: TextInputType.phone,
                      controller: phoneCtrl,
                      onChanged: (value) {
                        // checkTextField();
                      },
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: ColorRes.grey,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 17)),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      'Пароль',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileEditPassPage()),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(12, 14, 12, 14),
                        decoration: BoxDecoration(
                            color: ColorRes.grey,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            Text(
                              '⁫•⁫•⁫•⁫•⁫•⁫•⁫•⁫•⁫•⁫•',
                              style: TextStyle(height: 0),
                            ),
                            Spacer(),
                            Text(
                              'Сменить пароль',
                              style: TextStyle(color: ColorRes.orange),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (emailCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Заполните почту')),
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
                            .editProfile(token, emailCtrl.text, nameCtrl.text,
                                phoneCtrl.text, profile);
                        Navigator.pop(context);
                        if (res.isEmpty) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Редактированно')),
                          );
                          loadData();
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
                          "Редактировать",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        AutoRouter.of(context).push(HelpRoute());
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorRes.grey),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: const Text(
                          "Удалить профиль",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorRes.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is ErrorProfileState) {
            return Center(
              child: Text("${state.exception}"),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
