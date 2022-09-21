import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as flyer_types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as flyer_ui;
import 'package:flutter_chat_ui/src/widgets/chat.dart' as flyer_chat;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/models/Chat.dart';
import 'package:newappc/views/chat_tab/bottom_widget/bottom_widget.dart';

import '../../additional_widgets/color_manipulator.dart';
import '../../additional_widgets/hex_color.dart';
import '../../screens/MainScreen.dart';
import 'message_bubble.dart';
import 'mocked_chat_screen.dart';

final messageStream =
    StreamProvider.autoDispose.family<List<flyer_types.Message>, String>((ref, chatId) {
  final userList = ref.read(usersNotifier).userList;
  List<flyer_types.Message> _messageList = [];
  StreamController<List<flyer_types.Message>> _messagesStream =
      StreamController<List<flyer_types.Message>>();

  FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection("messages")
      .orderBy('created', descending: true)
      .limit(16)
      .snapshots()
      .listen((event) {
    event.docs?.forEach((element) {
      final textMessage = flyer_types.TextMessage(
          author: flyer_types.User(
              id: element.data()['user_id'],
              firstName: userList
                  .firstWhere((user) => user.userID == element.data()['user_id'])
                  .firstName),
          id: element.id,
          metadata: {'type': element.data()['type']},
          text: element.data()['text'],
          createdAt: (element.data()['created'] == '' || element.data()['created'] == null)
              ? Timestamp.fromDate(DateTime.now()).millisecondsSinceEpoch
              : element.data()['created'].millisecondsSinceEpoch);
      if (!_messageList.any((message) => message.id == textMessage.id))
        _messageList.add(textMessage);
    });
    _messageList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    _messageList.reversed;
    List<flyer_types.Message> messageList = _messageList.reversed.toList();
    _messagesStream.sink.add(messageList);
  });
  return _messagesStream.stream;
});

class ChatScreen extends ConsumerStatefulWidget {
  final Chat chat;

  ChatScreen({this.chat});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  String get _chatName {
    if (widget.chat.isGroupChat) {
      return 'Group Name';
    } else {
      final interlocutorId =
          widget.chat.users.firstWhere((element) => element != ref.read(appUserProvider).userID);
      return ref
          .read(usersNotifier)
          .userList
          .firstWhere((element) => element.userID == interlocutorId)
          .firstName;
    }
  }

  String get _chatColor {
    if (widget.chat.isGroupChat) {
      return '26A69A';
    } else {
      String interlocutorId =
          widget.chat.users.firstWhere((element) => element != ref.read(appUserProvider).userID);
      return ref
          .read(usersNotifier)
          .userList
          .firstWhere((element) => element.userID == interlocutorId)
          .color;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pushNotificationP = ref.watch(pushNotificationProvider);
    final chatTheme = flyer_ui.DefaultChatTheme(
        backgroundColor: Colors.transparent,
        userAvatarNameColors: widget.chat.users
            .map((e) => HexColor(ref
                .read(usersNotifier)
                .userList
                .firstWhere((element) => element.userID == e)
                .color))
            .toList());

    return StreamBuilder(
        stream: ref.watch(messageStream(widget.chat.chatId).stream),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Could not retrieve data"));
          }
          if (!snapshot.hasData) {
            return MockedChatScreenView(color: _chatColor, chatName: _chatName);
          }
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: ColorManipulator.lighten(HexColor(_chatColor)),
              leading: IconButton(
                icon: Icon(CupertinoIcons.chevron_left,
                    color: ColorManipulator.darken(HexColor(_chatColor))),
                onPressed: () {
                  Navigator.pop(context);
                  pushNotificationP.notify();
                },
              ),
              title: Text(_chatName.toUpperCase(),
                  style: TextStyle(
                      height: 0,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: ColorManipulator.darken(HexColor(_chatColor)))),
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: flyer_chat.Chat(
                showUserAvatars: true,
                bubbleBuilder: (Widget child,
                        {flyer_types.Message message, bool nextMessageInGroup}) =>
                    MessageBubble(message: message),
                onSendPressed: null,
                user: flyer_types.User(id: ref.read(appUserProvider).userID),
                messages: snapshot.data,
                theme: chatTheme,
                customBottomWidget: BottomWidget(),
              ),
            ),
          );
        });
  }
}
