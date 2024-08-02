import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:russsia_carrot/data/local/pref.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../data/model/chat.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this.repository) : super(ChatState()) {
    on<LoadChatEvent>(_getRoom);
    on<ChatCreateEvent>(_createRoom);
    on<ChatSendMsgEvent>(_sendMsg);
    on<ChatAddMsgEvent>(_addMsg);
  }

  final AbstractRepository repository;
  WebSocketChannel? _channel;
  String currentUuid = '';
  // StreamSubscription? _subscription;

  _getRoom(
    LoadChatEvent event,
    emit,
  ) async {
    try {
      emit(ChatState());
      var chat = await repository.getRoom(event.token, event.buy);
      emit(state.copyWith(chatRoomModel: chat));
    } catch (e) {
      emit(state.copyWith(error: '$e'));
    }
  }

  _createRoom(
    ChatCreateEvent event,
    emit,
  ) async {
    emit(state.copyWith(messages: null));
    try {
      var chat = await repository.createRoom(
          event.token, event.name, event.user, event.productId, event.uuid);
      print('----asd${chat}');
      await _channel?.sink.close();
      MessagesOldModel msgs =
          await repository.getOldMessages(event.token, chat.uuid ?? '');
      print('----asd${msgs}');
      if (Pref().getId() == null) {
        await GetIt.I<AbstractRepository>().fetchProfile(event.token);
      }
      for (MessagesModel msg in msgs.results ?? []) {
        add(ChatAddMsgEvent(msg: msg));
      }
      _connectWebSocket(chat.uuid, event.token);
      emit(state.copyWith(roomMessagesModel: chat));
    } catch (e) {
      emit(state.copyWith(error: '$e'));
    }
  }

  _connectWebSocket(uuid, token) {
    try {
      _channel = IOWebSocketChannel.connect(
          'ws://195.49.215.94/chat-room/${uuid}/?Authorization=Token ${token}');
      currentUuid = uuid ?? '';
      // await _channel?.ready;
      // print('---socket:${_channel?.protocol}');
      _channel?.stream.listen((data) {
        print('---socket12:${data}');
        MessagesModel msg = MessagesModel.fromJson(json.decode(data));
        print('---socket:${data}');
        print('---socket:${msg}');
        add(ChatAddMsgEvent(msg: msg));
      }, onDone: () async {
        await Future.delayed(const Duration(seconds: 2));
        _connectWebSocket(uuid, token);
      }, onError: (e) {
        print('---e$e');
      });
      // await _channel?.ready;

      // _subscription = _channel!.stream.listen(
      //   (data) {
      //     print('---socket:${data}');
      //     // Handle incoming data
      //   },
      // );
    } on WebSocketException catch (e) {
      print('--error:${e.message}');
    }
  }

  _sendMsg(
    ChatSendMsgEvent event,
    emit,
  ) async {
    if (Pref().getId() == null) {
      await GetIt.I<AbstractRepository>().fetchProfile(event.token);
    }
    print('--cha:${event.body}');
    print('--cha:${Pref().getId()}');
    if (event.image != null) {
      repository.uploadMessageImage(event.token, currentUuid, event.image!);
    } else {
      _channel?.sink.add(jsonEncode({
        "type": "send_message",
        "body": event.body,
        "chat_user_id": Pref().getId()
      }));
    }
  }

  _addMsg(ChatAddMsgEvent event, emit) {
    state.addMsg(event.msg);
    emit(state);
  }
}
