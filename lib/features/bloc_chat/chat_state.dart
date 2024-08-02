part of 'chat_bloc.dart';

class ChatState {
  ChatRoomModel? chatRoomModel;
  ChatRoomResultsModel? roomMessagesModel;
  List<MessagesModel>? messages;
  String? error;

  ChatState({
    this.chatRoomModel,
    this.error,
    this.roomMessagesModel,
    this.messages,
  });

  addMsg(MessagesModel msg) {
    messages ??= [];
    this.messages?.insert(0, msg);
  }

  @override
  bool operator ==(covariant ChatState other) {
    return false;
  }

  @override
  int get hashCode => chatRoomModel.hashCode;

  ChatState copyWith({
    ChatRoomModel? chatRoomModel,
    ChatRoomResultsModel? roomMessagesModel,
    List<MessagesModel>? messages,
    String? error,
  }) {
    return ChatState(
      chatRoomModel: chatRoomModel ?? this.chatRoomModel,
      roomMessagesModel: roomMessagesModel ?? this.roomMessagesModel,
      messages: messages,
      error: error,
    );
  }
}
