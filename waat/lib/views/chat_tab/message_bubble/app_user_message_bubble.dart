import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as flyer_types;
import 'package:newappc/views/chat_tab/message_bubble/contents/text_message_content.dart';

import '../bottom_widget/bottom_widget.dart';

class AppUserMessageBubble extends StatelessWidget {
  final flyer_types.TextMessage message;

  ChatMessageType get _chatMessageType => ChatMessageType.values.byName(message.metadata['type']);

  AppUserMessageBubble({this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        margin: EdgeInsets.all(0),
        color: Colors.teal[400],
        child: Padding(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 12),
            child: Builder(
              builder: (context) {
                switch (_chatMessageType) {
                  case ChatMessageType.text:
                    return TextMessageContent(
                      message: message,
                    );
                    break;
                  case ChatMessageType.voice:
                    return TextMessageContent(
                      message: message,
                    );
                    break;
                  case ChatMessageType.file:
                    return TextMessageContent(
                      message: message,
                    );
                    break;
                  default:
                    return TextMessageContent(
                      message: message,
                    );
                    break;
                }
              },
            )));
  }
}
