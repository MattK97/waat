import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/chat_tab/bottom_widget/widgets/more_button/more_button.dart';
import 'package:newappc/views/chat_tab/bottom_widget/widgets/voice_recorder_button.dart';
import 'package:newappc/views/chat_tab/chat_tab.dart';

import '../send_button.dart';

final textInputControllerProvider =
    Provider<TextEditingController>((ref) => TextEditingController());

final typingIndicatorProvider = StateProvider<bool>((ref) => false);

class TextInput extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TextInputState();
}

class _TextInputState extends ConsumerState<TextInput> {
  Future<void> _updateTypingState(String value) async {
    final chat = await ref.read(chosenChatInfoStreamProvider.future);
    if (value.isNotEmpty && !ref.read(typingIndicatorProvider.state).state) {
      ref.read(typingIndicatorProvider.state).state = true;
      chatServices.updateChatInfo(
          chat.chatId, {'typing': chat.typing..add(ref.read(appUserProvider).userID)});
    } else if (value.isEmpty && ref.read(typingIndicatorProvider.state).state) {
      ref.read(typingIndicatorProvider.state).state = false;
      chatServices.updateChatInfo(chat.chatId, {
        'typing': chat.typing..removeWhere((element) => element == ref.read(appUserProvider).userID)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MoreButton(),
          flex: 1,
        ),
        Expanded(
          child: VoiceRecorderButton(),
          flex: 1,
        ),
        Expanded(
          child: TextField(
              onChanged: _updateTypingState,
              controller: ref.watch(textInputControllerProvider),
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Wyślij wiadomość",
              )),
          flex: 7,
        ),
        Expanded(
          child: SendButton(),
          flex: 1,
        )
      ],
    );
  }
}
