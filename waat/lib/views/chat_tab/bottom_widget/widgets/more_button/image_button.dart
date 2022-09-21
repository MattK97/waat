import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newappc/views/chat_tab/bottom_widget/bottom_widget.dart';

import 'more_button.dart';

class ImageButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
        final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
        ref.read(pickedFileProvider.state).state = pickedFile;
        ref.read(chatMessageTypeProvider.state).state = ChatMessageType.file;
        if (pickedFile != null) {
          ref.read(chatMessageTypeProvider.state).state = ChatMessageType.file;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Icon(CupertinoIcons.photo),
            ),
            Expanded(
              flex: 4,
              child: Text("Photo"),
            )
          ],
        ),
      ),
    );
  }
}
