import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:russsia_carrot/data/event_bus.dart';
import 'package:russsia_carrot/features/bloc_auth/auth_bloc.dart';
import 'package:russsia_carrot/features/cubit_save_token/save_token_cubit.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:russsia_carrot/theme/color_res.dart';
import 'package:flutter/material.dart';
import '../../router/router.dart';

@RoutePage()
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _obscureText = true;

  final _blocLogin = AuthBloc(GetIt.I<AbstractRepository>());
  final eventBus = GetIt.I<EventBus>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: BlocBuilder<AuthBloc, AuthState>(
            bloc: _blocLogin,
            builder: (context, state) {
              if (state is LoadSuccessState) {
                AutoRouter.of(context).replaceAll([const MainRoute()]);
                context.read<SaveTokenCubit>().saveToken(state.confirm.token);
                eventBus.fire(UpdateMainList());
              }
              if (state is ErrorLoginState) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Неправильный логин или пароль')),
                  );
                });
              }
              if (state is LoadingLoginState) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 88,
                    ),
                    const Text(
                      "Авторизация",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 21),
                    const Text(
                      "Введите свои данные, для авторизации",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 31),
                    const Text(
                      "Логин или Почта",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _controllerEmail,
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
                    const SizedBox(
                      height: 21,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Пароль",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            AutoRouter.of(context).push(WriteEmailRoute());
                          },
                          child: const Text(
                            "Забыли пароль?",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorRes.orange,
                                decoration: TextDecoration.underline,
                                decorationColor: ColorRes.orange),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _controllerPassword,
                      obscureText: _obscureText,
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
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_controllerEmail.text.isNotEmpty &&
                            _controllerPassword.text.isNotEmpty) {
                          // print(_controllerEmail.text);
                          // print(_controllerPassword.text);
                          _blocLogin.add(LoginEvent(
                            email: _controllerEmail.text,
                            password: _controllerPassword.text,
                          ));
                        }
                      },
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
                    const SizedBox(
                      height: 34,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Нет аккаунта? ",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            AutoRouter.of(context).push(const RegisterRoute());
                          },
                          child: const Text(
                            "Зарегистрируйтесь",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorRes.orange),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
