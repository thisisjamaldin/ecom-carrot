import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:russsia_carrot/router/router.dart';

import '../../features/bloc_send_email_for_code/send_email_for_code_bloc.dart';
import '../../theme/color_res.dart';

@RoutePage()
class WriteEmailPage extends StatefulWidget {
  const WriteEmailPage({super.key});

  @override
  State<WriteEmailPage> createState() => _WriteEmailPageState();
}

class _WriteEmailPageState extends State<WriteEmailPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final _blocEmailSend = SendEmailForCodeBloc(GetIt.I<AbstractRepository>());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendEmailForCodeBloc, SendEmailForCodeState>(
      bloc: _blocEmailSend,
      builder: (context, state) {
        if (state is SendEmailForCodeLoaded) {
          AutoRouter.of(context).push(const RecoverPasswordRoute());
        }
        if (state is SendEmailForCodeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Введение некорректные данные')),
          );
        }
        if (state is SendEmailForCodeLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 88),
                const Text(
                  "Введите email",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 31),
                const Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _controllerEmail,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: ColorRes.grey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    if (_controllerEmail.text.isNotEmpty) {
                      _blocEmailSend
                          .add(SendEmailEvent(email: _controllerEmail.text));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Введите email')),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorRes.orange,
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: const Text(
                      "Далее",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 34),
              ],
            ),
          ),
        );
      },
    );
  }
}

// RecoverPasswordPage
