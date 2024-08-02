import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:russsia_carrot/features/bloc_logout/logout_bloc.dart';
import 'package:russsia_carrot/features/bloc_my_products/my_products_bloc.dart';
import 'package:russsia_carrot/features/bloc_profile/profile_bloc.dart';
import 'package:russsia_carrot/features/cubit_save_token/save_token_cubit.dart';
import 'package:russsia_carrot/generated/assets.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:russsia_carrot/router/router.dart';
import 'package:russsia_carrot/theme/color_res.dart';
import 'package:russsia_carrot/ui/profile/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../features/cubit_save_email/save_eamail_cubit.dart';
import '../../features/cubit_save_name/save_number_cubit.dart';
import '../../features/cubit_save_number/save_name_cubit.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _blocProfile = ProfileBloc(GetIt.I<AbstractRepository>());
  final _blocMyProducts = MyProductsBloc(GetIt.I<AbstractRepository>());
  final _blocLogout = LogoutBloc(GetIt.I<AbstractRepository>());
  final limitProducts = ValueNotifier(6);

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
    _blocProfile.add(LoadProfileEvent(token: token));
    _blocMyProducts
        .add(LoadMyProductsEvent(token: token, limit: limitProducts.value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Профиль',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                color: const Color(0xff3F3D45),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                SvgPicture.asset(Assets.iconsPencil),
                const SizedBox(width: 6),
                const Text(
                  'Редактировать профиль',
                  style: TextStyle(
                    fontSize: 8,
                    color: ColorRes.orange,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: _blocProfile,
        builder: (context, state) {
          if (state is LoadedProfileState) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                        color: ColorRes.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: state.owner.image.isEmpty
                              ? Image.asset(Assets.imagesPerson)
                              : Image.network(state.owner.image),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${state.owner.firstName} ${state.owner.lastName}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            Text(state.owner.email,
                                style: const TextStyle(fontSize: 10)),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.62,
                              child: const Divider(
                                color: ColorRes.greyDark,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.62,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(Assets.iconsStar),
                                      const SizedBox(width: 6),
                                      const Text('Рейтинг',
                                          style: TextStyle(fontSize: 10)),
                                      const SizedBox(width: 4),
                                      Text(
                                        state.owner.raiting.toString(),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Сделок завершено ',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        state.owner.completedTransactions
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: ColorRes.orange),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 12),
                    child: Text(
                      'Объявления',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  BlocBuilder<MyProductsBloc, MyProductsState>(
                    bloc: _blocMyProducts,
                    builder: (context, state) {
                      if (state is MyProductsLoaded) {
                        return GestureDetector(
                          onTap: () {
                            AutoRouter.of(context).push(AllProductRoute());
                          },
                          child: CustomButton(
                            text: 'Мои объявления',
                            amount: true,
                            count: state.resultProducts.length,
                          ),
                        );
                      }
                      if (state is MyProductsErrorState) {
                        return Center(
                          child: Text(state.exception.toString()),
                        );
                      }
                      return const CustomButton(
                        text: 'Мои объявления',
                        amount: true,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Настройки',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                      onTap: () =>
                          AutoRouter.of(context).push(NotificationRoute(
                            isProfile: true,
                          )),
                      child: const CustomButton(text: 'Уведомления')),
                  const SizedBox(height: 12),
                  GestureDetector(
                      onTap: () {
                        AutoRouter.of(context).push(HelpRoute());
                      },
                      child: const CustomButton(text: 'Помощь')),
                  const SizedBox(height: 12),
                  GestureDetector(
                      onTap: () {
                        launchUrl(
                            Uri.parse('https://codify.kz/privacymorkovka'));
                      },
                      child: const CustomButton(
                          text: 'Политика конфиденциальности')),
                  const SizedBox(height: 40),
                  BlocBuilder<LogoutBloc, LogoutState>(
                    bloc: _blocLogout,
                    builder: (context, state) {
                      return Center(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (c) {
                                  return Center(
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: ColorRes.grey,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Вы уверены?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text('Вы уверены что хотите выйти?'),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(c);
                                                  _blocLogout.add(
                                                      LoadLogoutEvent(
                                                          token: token,
                                                          revoke: true));
                                                  context
                                                      .read<SaveNumberCubit>()
                                                      .saveNumber('');
                                                  context
                                                      .read<SaveNameCubit>()
                                                      .saveNumber('');
                                                  context
                                                      .read<SaveEamailCubit>()
                                                      .saveEmail('');
                                                  context
                                                      .read<SaveTokenCubit>()
                                                      .clearToken();
                                                  AutoRouter.of(context)
                                                      .replaceAll([
                                                    const MainRoute(),
                                                    const MainAuthRoute()
                                                  ]);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          22, 4, 22, 4),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: ColorRes.orange),
                                                  child: const Text('Да'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(c);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          22, 4, 22, 4),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: ColorRes.greyDark),
                                                  child: const Text('Нет'),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(Assets.iconsExit),
                              const SizedBox(width: 6),
                              const Text(
                                'Выйти',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40)
                ],
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
