import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/chat_tab/bottom_widget/bottom_widget.dart';

import '../more_button/more_button.dart';

class FileInput extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(fit: StackFit.passthrough, children: [
        Container(
          width: 100,
          height: 170,
          child: Image.file(File(ref.read(pickedFileProvider.state).state.path)),
        ),
        Align(
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(
              CupertinoIcons.clear_circled,
              color: Colors.red,
            ),
            onPressed: () {
              ref.read(chatMessageTypeProvider.state).state = ChatMessageType.text;
              ref.read(pickedFileProvider.state).state = null;
            },
          ),
        ),
      ]),
    );
  }
}
