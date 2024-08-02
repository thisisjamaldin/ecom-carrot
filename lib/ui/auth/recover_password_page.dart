import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:russsia_carrot/router/router.dart';

import '../../features/bloc_reset_password/reset_password_bloc.dart';
import '../../theme/color_res.dart';

@RoutePage()
class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  late Timer _timer;
  final Stopwatch _stopwatch = Stopwatch();
  int _start = 60;
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;

  final eventBus = GetIt.I<EventBus>();
  final _blocReset = ResetPasswordBloc(GetIt.I<AbstractRepository>());

  @override
  void initState() {
    super.initState();
    startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  String get smsCode {
    return _controllers.map((controller) => controller.text).join();
  }

  int? get smsCodeAsInt {
    try {
      return int.parse(smsCode);
    } catch (e) {
      return 1234;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_stopwatch.elapsed.inSeconds >= 60) {
          _timer.cancel();
        }
        _start = 60 - _stopwatch.elapsed.inSeconds;
      });
    });
    _stopwatch.start();
  }

  void restartTimer() {
    setState(() {
      _stopwatch.reset();
      _start = 60;
      startTimer();
    });
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < _focusNodes.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
        bloc: _blocReset,
        builder: (context, state) {
          if (state is ResetPasswordLoaded) {
            Future.delayed(Duration.zero, () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Пароль сохранен')),
              );
              AutoRouter.of(context).replaceAll([MainAuthRoute(), AuthRoute()]);
            });

          }
          if (state is ResetPasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Введение некорректные данные')),
            );
          }
          if (state is ResetPasswordLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 88),
                  const Text(
                    "Подтверждение",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 21),
                  const Text(
                    "Введите код присланный на почту",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 51),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        List.generate(4, (index) => _buildCodeInput(index)),
                  ),
                  const SizedBox(height: 37),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _start > 0
                          ? Text(
                              '0:$_start',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        width: 11,
                      ),
                      GestureDetector(
                        onTap: () {
                          _start < 0 ? restartTimer() : null;
                        },
                        child: Text(
                          'Отправить код заново',
                          style: TextStyle(
                              color: _start > 0
                                  ? ColorRes.greyText
                                  : ColorRes.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Придумайте пароль",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 21),
                  const Text(
                    "Подтверждение пароля",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _controllerConfirmPassword,
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
                          _obscureText2
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () async {
                      if (smsCodeAsInt != null) {
                        if (_controllerPassword.text.isNotEmpty &&
                            _controllerConfirmPassword.text.isNotEmpty) {
                          if (_controllerPassword.text == _controllerConfirmPassword.text) {
                            _blocReset.add(ResetEvent(
                              code: smsCodeAsInt!.toInt(),
                              password: _controllerPassword.text,
                              passwordConfirm: _controllerConfirmPassword.text,
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Пароли не совпадают')),
                            );
                          }

                        }
                        // _bloc.add(
                        //     LoadConfirmEvent(code: smsCodeAsInt!.toInt()));
                        // repository.fetchConfirm(smsCodeAsInt!.toInt());
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
                        "Далее",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (smsCodeAsInt != null) {
                          if (_controllerPassword.text.isNotEmpty &&
                              _controllerConfirmPassword.text.isNotEmpty) {
                            if (_controllerPassword.text == _controllerConfirmPassword.text) {
                              _blocReset.add(ResetEvent(
                                code: smsCodeAsInt!.toInt(),
                                password: _controllerPassword.text,
                                passwordConfirm: _controllerConfirmPassword.text,
                              ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Пароли не совпадают')),
                              );
                            }

                          }
                          // _bloc.add(
                          //     LoadConfirmEvent(code: smsCodeAsInt!.toInt()));
                          // repository.fetchConfirm(smsCodeAsInt!.toInt());
                        }
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: ColorRes.orange,
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Text(
                          "Не получили код?",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorRes.orange),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCodeInput(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 36,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 50, color: Colors.white),
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: _controllers[index].text.isEmpty
                    ? ColorRes.grey
                    : ColorRes.orange,
                width: 3),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorRes.orange, width: 3),
          ),
        ),
        maxLength: 1,
        onChanged: (value) {
          setState(() {
            _onCodeChanged(value, index);
          });
        },
      ),
    );
  }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 88),
//           const Text(
//             "Регистрация",
//             style: TextStyle(
//               fontSize: 30,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 21),
//           const Text(
//             "Введите свои данные, для регистрации",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 31),
//           const Text(
//             "Email или Телефон",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _controllerEmail,
//             decoration: const InputDecoration(
//               filled: true,
//               fillColor: ColorRes.grey,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding:
//               EdgeInsets.symmetric(vertical: 12, horizontal: 17),
//             ),
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           const SizedBox(height: 21),
//           const Text(
//             "Придумайте пароль",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _controllerPassword,
//             obscureText: _obscureText,
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: ColorRes.grey,
//               border: const OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                   vertical: 12, horizontal: 17),
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   _obscureText ? Icons.visibility : Icons.visibility_off,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _obscureText = !_obscureText;
//                   });
//                 },
//               ),
//             ),
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           const SizedBox(height: 21),
//           const Text(
//             "Подтверждение пароля",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _controllerConfirmPassword,
//             obscureText: _obscureText2,
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: ColorRes.grey,
//               border: const OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                   vertical: 12, horizontal: 17),
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   _obscureText2 ? Icons.visibility : Icons.visibility_off,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _obscureText2 = !_obscureText2;
//                   });
//                 },
//               ),
//             ),
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           const SizedBox(height: 40),
//           GestureDetector(
//             onTap: _registerWithEmailPassword,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: ColorRes.orange,
//               ),
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 15),
//               child: const Text(
//                 "Далее",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//           const SizedBox(height: 34),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Есть аккаунт? ",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   // AutoRouter.of(context).push(const AuthRoute());
//                 },
//                 child: const Text(
//                   "Авторизуйтесь",
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: ColorRes.orange,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
}
