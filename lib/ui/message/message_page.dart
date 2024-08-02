import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:russsia_carrot/features/bloc_chat/chat_bloc.dart';
import 'package:russsia_carrot/router/router.dart';
import 'package:flutter/material.dart';

import '../../features/cubit_save_token/save_token_cubit.dart';
import '../favorite/widget/list_message.dart';
import 'widget/button_pay.dart';

@RoutePage()
class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late String token;
  bool buy = true;

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
    BlocProvider.of<ChatBloc>(context).add(
      LoadChatEvent(token: token, buy: buy),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Сообщения',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
        if (state.chatRoomModel?.results != null) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonPay(
                          title: 'Покупаю',
                          select: buy,
                          onTap: () {
                            if (buy) return;
                            setState(() {
                              buy = true;
                            });
                          },
                        ),
                        ButtonPay(
                          title: 'Продаю',
                          select: !buy,
                          onTap: () {
                            if (!buy) return;
                            setState(() {
                              buy = false;
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              if (state.chatRoomModel?.results?.isNotEmpty == true)
                SliverList.builder(
                  itemCount: state.chatRoomModel?.results?.length ?? 0,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          context.read<ChatBloc>().add(ChatCreateEvent(
                              name: '-',
                              token: token,
                              user: 0,
                              productId: 0,
                              uuid: state.chatRoomModel!.results![index].uuid));
                          context.pushRoute(MessageDetailRoute());
                        },
                        child:  ListMessage(productRoom: state.chatRoomModel!.results![index].productId!));
                  },
                )
              else
                SliverToBoxAdapter(
                  child: Column(
                    children: [Text('Пусто')],
                  ),
                ),
            ],
          );
        } else if (state.error != null) {
          return Center(
            child: Text('${state.error}'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
