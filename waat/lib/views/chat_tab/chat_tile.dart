import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/widgets/custom_divider.dart';
import 'package:newappc/models/Chat.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/chat_tab/conversation_icon.dart';

class ChatTile extends ConsumerWidget {
  final Chat chat;
  final VoidCallback onTap;

  ChatTile({this.onTap, this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref
        .read(usersNotifier)
        .userList
        .firstWhere((element) => element.userID == ref.read(authServiceViewModel).user.uid);
    final chatName = chat.isGroupChat
        ? 'Group'
        : ref
            .read(usersNotifier)
            .userList
            .firstWhere((element1) =>
                element1.userID == chat.users.where((element2) => element2 != user.userID).first)
            .firstName;
    final color = chat.isGroupChat
        ? '26A69A'
        : ref
            .read(usersNotifier)
            .userList
            .firstWhere((element1) =>
                element1.userID == chat.users.where((element2) => element2 != user.userID).first)
            .color;

    final isTyping = chat.typing.where((element) => element != user.userID).isNotEmpty;
    return Column(
      children: [
        ListTile(
            leading: ConversationIcon(chatName, color, false),
            title: Transform.translate(
                offset: Offset(-10, 10),
                child: Text(chatName, style: TextStyle(fontWeight: FontWeight.bold))),
            subtitle: Transform.translate(
              offset: Offset(-10, 10),
              child: chat == null
                  ? Text('')
                  : isTyping
                      ? Text('Is typing...')
                      : chat.lastMessage == null
                          ? Text("")
                          : Builder(
                              builder: (context) {
                                if (chat.lastMessageType == 'text') {
                                  return Text(chat.lastMessage);
                                } else if (chat.lastMessageType == 'voice') {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        CupertinoIcons.mic,
                                        color: Colors.grey[400],
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text('Voice Message'),
                                    ],
                                  );
                                } else if (chat.lastMessageType == 'file') {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        CupertinoIcons.doc,
                                        color: Colors.grey[400],
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text('Attachment'),
                                    ],
                                  );
                                } else {
                                  return Text(chat.lastMessage);
                                }
                              },
                            ),
            ),
            trailing: chat == null
                ? Container(
                    width: 12.0,
                    height: 12.0,
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        chat == null || chat.lastMessageTimestamp == ''
                            ? ''
                            : '${Jiffy(chat.lastMessageTimestamp).E}, ${Jiffy(chat.lastMessageTimestamp).Hm}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      !chat.read.contains(user.userID)
                          ? Container(
                              width: 12.0,
                              height: 12.0,
                              decoration: new BoxDecoration(
                                color: Colors.teal[400],
                                shape: BoxShape.circle,
                              ))
                          : Container(
                              width: 12.0,
                              height: 12.0,
                              decoration: new BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                            ),
                    ],
                  ),
            onTap: onTap),
        Padding(
          padding: const EdgeInsets.only(left: 64.0),
          child: CustomDivider(),
        )
      ],
    );
  }
}
