import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:russsia_carrot/data/local/pref.dart';
import 'package:russsia_carrot/features/bloc_chat/chat_bloc.dart';
import 'package:russsia_carrot/features/bloc_profile/profile_bloc.dart';
import 'package:russsia_carrot/features/cubit_save_token/save_token_cubit.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:russsia_carrot/router/router.dart';
import 'package:russsia_carrot/ui/message/widget/list_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../generated/assets.dart';
import '../../theme/color_res.dart';
import '../bottom_navigate.dart';

@RoutePage()
class MessageDetailPage extends StatefulWidget {
  const MessageDetailPage({super.key});

  @override
  State<MessageDetailPage> createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  late String token;
  TextEditingController msgCtrl = TextEditingController();

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
    int myId = Pref().getId() ?? 0;
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: ColorRes.grey,
          automaticallyImplyLeading: false,
          actions: [
            if (state.roomMessagesModel != null)
              Expanded(
                  child: Container(
                      color: ColorRes.grey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 12.0, left: 12),
                                  child:
                                      SvgPicture.asset(Assets.iconsChevronLeft),
                                ),
                              ),
                              const SizedBox(width: 28),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    '${state.roomMessagesModel?.name}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '${state.roomMessagesModel?.users?[0].user?.firstName}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: ColorRes.orange),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 24),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(200)),
                            child: SvgPicture.asset(Assets.iconsPhone),
                          )
                        ],
                      )))
          ],
        ),
        body: state.roomMessagesModel!=null? Column(
          children: [
            Expanded(
              child: CustomScrollView(
                reverse: true,
                slivers: [
                  SliverList.builder(
                    itemBuilder: (context, index) {
                      return ListChat(
                        msg: state.messages![index],
                        myId: myId,
                      );
                    },
                    itemCount: state.messages?.length ?? 0,
                  )
                ],
              ),
            ),

            ///Edit Text
            Column(
              children: [
                const Divider(
                  color: ColorRes.grey,
                  height: 0,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 28,
                    top: 16,
                  ),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final XFile? photo = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (photo != null) {
                            context.read<ChatBloc>().add(ChatSendMsgEvent(
                                body: '', token: token, image: photo));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: ColorRes.grey,
                              borderRadius: BorderRadius.circular(200)),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: msgCtrl,
                          cursorColor: ColorRes.greyWhite,
                          style: const TextStyle(
                            fontSize: 12,
                            color: ColorRes.greyWhite,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: ColorRes.greyWhite),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            filled: true,
                            fillColor: ColorRes.grey,
                            hintText: 'Напишите сообщение...',
                            hintStyle: const TextStyle(
                                color: Color(0xff6E6E6E), fontSize: 9),
                            contentPadding: const EdgeInsets.fromLTRB(
                              16,
                              10,
                              20,
                              10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (msgCtrl.text.trim().isEmpty) return;
                          context.read<ChatBloc>().add(ChatSendMsgEvent(
                              body: msgCtrl.text, token: token));
                          msgCtrl.clear();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: ColorRes.orange,
                              borderRadius: BorderRadius.circular(200)),
                          child: SvgPicture.asset(Assets.iconsSend),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ):Center(child: CircularProgressIndicator(),),
        bottomNavigationBar: const BottomNavigate(index: 3),
      );
    });
  }
}
