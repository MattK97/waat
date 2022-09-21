import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/chat_tab/bottom_widget/bottom_widget.dart';
import 'package:newappc/views/chat_tab/bottom_widget/widgets/more_button/more_button.dart';
import 'package:newappc/views/chat_tab/bottom_widget/widgets/text_input/text_input.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../models/Chat.dart';
import '../../chat_tab.dart';

class SendButton extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SendButtonState();
}

class _SendButtonState extends ConsumerState<SendButton> {
  Future<void> _sendMessage({Chat chat}) async {
    ref.read(typingIndicatorProvider.state).state = false;
    final chat = await ref.read(chosenChatInfoStreamProvider.future);
    final chatMessageType = ref.read(chatMessageTypeProvider.state).state;
    if (chatMessageType == ChatMessageType.text) {
      _sendTextMessage(chat: chat);
    } else if (chatMessageType == ChatMessageType.voice) {
      _sendAudioMessage(chat: chat);
    } else if (chatMessageType == ChatMessageType.file) {
      _sendFileMessage(chat: chat);
    }
  }

  Future<void> _sendFileMessage({Chat chat}) async {
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${chat.chatId}';
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('file-messages/$fileName')
          .putFile(File(ref.read(pickedFileProvider.state).state.path))
          .then((res) async {
        String fileUrl = await res.ref.getDownloadURL();
        final messageTimestamp = FieldValue.serverTimestamp();

        var map = {
          'text': fileUrl,
          'created': messageTimestamp,
          'user_id': ref.read(appUserProvider).userID,
          'type': 'file',
        };

        final messageId = await chatServices.sendPrivateMessage(chat.chatId, map);
        chatServices.updateChatInfo(chat.chatId, {
          'last_message_timestamp': messageTimestamp,
          'last_message': map['text'],
          'last_message_id': messageId,
          'last_message_type': map['type'],
          'last_sender_id': map['user_id'],
          'read': chat.read..removeWhere((element) => element != ref.read(appUserProvider).userID),
          'typing': chat.typing
            ..removeWhere((element) => element == ref.read(appUserProvider).userID),
        });
      });
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> _sendAudioMessage({Chat chat}) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${appDirectory.path}/voice_message.m4a';
    File file = File(filePath);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${chat.chatId}';

    // final tempMess = flyer_types.TextMessage(
    //     author: flyer_types.User(
    //         id: ref.read(appUserProvider).userID, firstName: ref.read(appUserProvider).firstName),
    //     id: 'none',
    //     metadata: {'type': ref.read(chatMessageTypeProvider.state).state},
    //     text: filePath,
    //     createdAt: DateTime.now().millisecondsSinceEpoch);
    //
    // List<flyer_types.Message> currentMessages =
    //     await ref.read(messageStream(ref.read(chosenChatIdProvider.state).state).future);
    //
    // currentMessages.add(tempMess);
    // currentMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // currentMessages.reversed;
    // List<flyer_types.Message> messageList = currentMessages.reversed.toList();
    // _messagesStream.sink.add(messageList);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('voice-messages/$fileName')
          .putFile(file)
          .then((res) async {
        String fileUrl = await res.ref.getDownloadURL();
        final messageTimestamp = FieldValue.serverTimestamp();
        var map = {
          'text': fileUrl,
          'created': messageTimestamp,
          'user_id': ref.read(appUserProvider).userID,
          'type': 'voice'
        };
        final messageId = await chatServices.sendPrivateMessage(chat.chatId, map);
        chatServices.updateChatInfo(chat.chatId, {
          'last_message_timestamp': messageTimestamp,
          'last_message': map['text'],
          'last_message_id': messageId,
          'last_message_type': map['type'],
          'last_sender_id': map['user_id'],
          'read': chat.read..removeWhere((element) => element != ref.read(appUserProvider).userID),
          'typing': chat.typing
            ..removeWhere((element) => element == ref.read(appUserProvider).userID),
        });
      });
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> _sendTextMessage({Chat chat}) async {
    final messageTimestamp = FieldValue.serverTimestamp();
    var map = {
      'text': ref.read(textInputControllerProvider).text,
      'created': messageTimestamp,
      'user_id': ref.read(appUserProvider).userID,
      'type': 'text'
    };
    final messageId = await chatServices.sendPrivateMessage(chat.chatId, map);

    chatServices.updateChatInfo(chat.chatId, {
      'last_message_timestamp': messageTimestamp,
      'last_message': map['text'],
      'last_message_id': messageId,
      'last_message_type': map['type'],
      'last_sender_id': map['user_id'],
      'read': chat.read..removeWhere((element) => element != ref.read(appUserProvider).userID),
      'typing': chat.typing
        ..removeWhere((element) => element == (ref.read(appUserProvider).userID)),
    });
    ref.read(textInputControllerProvider).clear();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(CupertinoIcons.arrow_up_circle), onPressed: _sendMessage);
  }
}
