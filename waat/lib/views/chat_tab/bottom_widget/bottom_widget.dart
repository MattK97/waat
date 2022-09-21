import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/services/AudioRecorder.dart';
import 'package:newappc/views/chat_tab/bottom_widget/widgets/audio_input.dart';
import 'package:newappc/views/chat_tab/bottom_widget/widgets/file_input/file_input.dart';
import 'package:newappc/views/chat_tab/bottom_widget/widgets/text_input/text_input.dart';
import 'package:newappc/views/chat_tab/chat_tab.dart';

import '../../../models/Chat.dart';
import '../typing_indicator.dart';

enum ChatMessageType { text, voice, file }

final chatMessageTypeProvider = StateProvider<ChatMessageType>((ref) => ChatMessageType.text);
final audioRecorderProvider = Provider<AudioRecorder>((ref) => AudioRecorder());
final audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());
final _childWidgetProvider = StateProvider<Widget>((ref) {
  switch (ref.read(chatMessageTypeProvider.state).state) {
    case ChatMessageType.voice:
      return AudioInput();
      break;
    case ChatMessageType.text:
      return TextInput();
      break;
    case ChatMessageType.file:
      return FileInput();
      break;
    default:
      return TextInput();
  }
});

class BottomWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomWidgetState();
}

class _BottomWidgetState extends ConsumerState<BottomWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Chat>(
      stream: ref.watch(chosenChatInfoStreamProvider.future).asStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          );
        }
        final chat = snapshot.data;
        if (!chat.read.contains(ref.read(appUserProvider).userID)) {
          final chat = snapshot.data;
          chatServices.updateChatInfo(chat.chatId, {
            'read': chat.read..add(ref.read(appUserProvider).userID),
          });
        }

        final isGroupChat = chat.isGroupChat;
        final isInterlocutorTyping =
            chat.typing.where((e) => e != ref.read(appUserProvider).userID).isNotEmpty;

        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: TypingIndicator(
                    height: 28, width: 45, showIndicator: !isGroupChat && isInterlocutorTyping),
              ),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.grey, // set border color
                        width: 1.0), // set border width
                    borderRadius:
                        BorderRadius.all(Radius.circular(32.0)), // set rounded corner radius
                  ),
                  child: ref.watch(_childWidgetProvider.state).state),
            ],
          ),
        );
      },
    );
  }
}
