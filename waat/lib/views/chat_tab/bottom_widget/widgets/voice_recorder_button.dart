import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/chat_tab/bottom_widget/bottom_widget.dart';

class VoiceRecorderButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(chatMessageTypeProvider.state).state == ChatMessageType.voice) {
      return IconButton(
          icon: Icon(CupertinoIcons.clear_circled),
          onPressed: () => ref.watch(chatMessageTypeProvider.state).state == ChatMessageType.text);
    } else {
      return IconButton(
        icon: Icon(CupertinoIcons.mic),
        onPressed: () {
          if (ref.watch(chatMessageTypeProvider.state).state != ChatMessageType.voice) {
            ref.read(audioRecorderProvider).startRecording();
          }
        },
      );
    }
  }
}
