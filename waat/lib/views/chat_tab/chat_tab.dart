import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_titled_container_no_border.dart';
import 'package:newappc/models/Chat.dart';
import 'package:newappc/models/Team.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/rest/services/chat_services.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/chat_tab/conversation_icon.dart';

import 'chat_screen.dart';
import 'chat_tile.dart';

final chatInfoStreamProvider = StreamProvider<List<Chat>>((ref) {
  StreamController<List<Chat>> chatInfoStreamController = StreamController();

  FirebaseFirestore.instance
      .collection('chat_info')
      .where("users", arrayContains: ref.read(authServiceViewModel).user.uid)
      .snapshots()
      .listen((event) {
    List<Chat> chatList = [];
    event.docs?.forEach((element) => chatList.add(Chat(
        read: List<String>.from(element.data()['read']),
        typing: List<String>.from(element.data()['typing']),
        users: List<String>.from(element.data()['users']),
        lastMessageTimestamp: element.data()['last_message_timestamp'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                    element.data()['last_message_timestamp'].millisecondsSinceEpoch)
                .toString()
            : null,
        lastMessage: element.data()['last_message'],
        lastMessageId: element.data()['last_message_id'],
        lastMessageType: element.data()['last_message_type'],
        lastSenderId: element.data()['last_sender_id'],
        chatId: element.id,
        isGroupChat: element.data()['is_group_chat'])));

    chatInfoStreamController.sink.add(chatList);
  });
  return chatInfoStreamController.stream;
});

final chosenChatInfoStreamProvider = FutureProvider.autoDispose<Chat>((ref) {
  return ref
      .watch(chatInfoStreamProvider)
      .value
      .firstWhere((element) => element.chatId == ref.read(chosenChatIdProvider.state).state);
});

final chosenChatIdProvider = StateProvider<String>((ref) => null);

class ChatTab extends ConsumerStatefulWidget {
  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends ConsumerState<ChatTab> {
  User user;
  List<User> notStartedUserList = [];

  @override
  void initState() {
    super.initState();
    user = ref.read(appUserProvider);
  }

  Future<void> _openChat({
    Chat chat,
  }) async {
    ref.read(chosenChatIdProvider.state).state = chat.chatId;
    if (!chat.read.contains(user.userID)) {
      chatServices.updateChatInfo(chat.chatId, {'read': chat.read..add(user.userID)});
    }
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => ChatScreen(
              chat: chat,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final tier = ref.read(chosenTeamProvider.state).state.tier;
    final userList = ref.watch(usersNotifier).userList;
    final userListWithoutAppUser = userList.where((element) => element != user).toList();
    List<User> notStartedUsers = [...userListWithoutAppUser];

    if (tier == Tier.BASE) {
      return Center(
        child: Text('ORDER PREMIUM'),
      );
    }

    return StreamBuilder(
      stream: ref.watch(chatInfoStreamProvider.stream),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: CustomTitledContainerNoBorder(
              customSectionTitle: CustomSectionTitle(
                leftIcon: CupertinoIcons.bubble_left_bubble_right,
                rightIcon: CupertinoIcons.add,
                disableRightIcon: true,
                color: Colors.teal[400],
                title: AppLocalizations.of(context).chats,
              ),
              child: Column(
                children: [
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Chat chat = snapshot.data[index];
                        if (!chat.isGroupChat) {
                          String interlocutorId = chat.users
                              .firstWhere((element) => element != user.userID, orElse: () => null);
                          if (interlocutorId != null) {
                            User interlocutor =
                                userList.firstWhere((element) => element.userID == interlocutorId);
                            notStartedUsers.remove(interlocutor);
                          }
                        }
                        return ChatTile(
                          chat: chat,
                          onTap: () async => _openChat(chat: chat),
                        );
                      }),
                  Builder(builder: (context) {
                    return ListView.builder(
                        itemCount: notStartedUsers.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final interlocutor = notStartedUsers[index];
                          return ListTile(
                              onTap: () =>
                                  ChatServices().initChat(user.userID, interlocutor.userID),
                              leading: ConversationIcon(
                                  interlocutor.firstName, interlocutor.color, false),
                              title: Transform.translate(
                                  offset: Offset(-10, 10),
                                  child: Text(interlocutor.firstName,
                                      style: TextStyle(fontWeight: FontWeight.bold))),
                              subtitle:
                                  Transform.translate(offset: Offset(-10, 10), child: Text('')));
                        });
                  })
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
