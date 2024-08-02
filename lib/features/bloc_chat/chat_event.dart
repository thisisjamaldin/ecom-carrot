// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_bloc.dart';

class ChatEvent {}

class LoadChatEvent extends ChatEvent {
  bool buy;
  String token;
  LoadChatEvent({
    required this.buy,
    required this.token,
  });
}

class ChatCreateEvent extends ChatEvent {
  String name;
  String token;
  int user;
  int productId;
  String? uuid;
  ChatCreateEvent({
    required this.name,
    required this.token,
    required this.user,
    required this.productId,
    required this.uuid,
  });
}

class ChatSendMsgEvent extends ChatEvent {
  String body;
  String token;
  XFile? image;
  ChatSendMsgEvent({
    required this.body,
    required this.token,
    this.image,
  });
}

class ChatAddMsgEvent extends ChatEvent {
  MessagesModel msg;
  ChatAddMsgEvent({
    required this.msg,
  });
}
