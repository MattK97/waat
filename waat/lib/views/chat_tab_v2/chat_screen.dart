// import 'dart:async';
// import 'dart:io';
//
// import 'package:async/async.dart' show StreamGroup;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:just_audio/just_audio.dart' as JustAudio;
// import 'package:newappc/additional_widgets/color_manipulator.dart';
// import 'package:newappc/additional_widgets/hex_color.dart';
// import 'package:newappc/models/Chat.dart' as models;
// import 'package:newappc/models/User.dart';
// import 'package:newappc/screens/MainScreen.dart';
// import 'package:newappc/services/AudioPlayer.dart';
// import 'package:newappc/services/AudioRecorder.dart';
// import 'package:newappc/views/chat_tab_v2/chat_screen_cutom_bottom_widget.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';
//
// import 'message_bubble.dart';
//
// class ChatScreen extends ConsumerStatefulWidget {
//   final User user;
//   final models.Chat chat;
//   final Stream<List<models.Chat>> chatsInfoStream;
//
//   const ChatScreen({Key key, this.user, this.chat, this.chatsInfoStream}) : super(key: key);
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends ConsumerState<ChatScreen> {
//   StreamController<List<types.Message>> _messagesStream;
//   StreamController<models.Chat> _chosenChatStreamController;
//   Stream _mergedStream;
//   AudioPlayer _audioPlayer;
//   AudioRecorder _audioRecorder;
//   final databaseReference = FirebaseFirestore.instance;
//   TextEditingController _textEditingController;
//   models.Chat chat;
//   List<types.Message> listOfMessages;
//   String _playingVoiceMessageDataSource = '';
//   Timestamp _oldestMessageTimestamp;
//
//   @override
//   void initState() {
//     super.initState();
//     _messagesStream = StreamController<List<types.Message>>();
//     _chosenChatStreamController = StreamController<models.Chat>();
//     _initMessagesStream();
//     _initChosenChatInfoStream();
//     _mergeStreams();
//     chat = widget.chat;
//     listOfMessages = [];
//     _audioRecorder = AudioRecorder(recorder: Record());
//     _audioPlayer = AudioPlayer(JustAudio.AudioPlayer());
//     _textEditingController = TextEditingController();
//   }
//
//   List<types.Message> _messageList = [];
//
//   void _initMessagesStream() {
//     final userList = ref.read(usersNotifier).userList;
//     FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chat.chatId)
//         .collection("messages")
//         .orderBy('created', descending: true)
//         .limit(16)
//         .snapshots()
//         .listen((event) {
//       _oldestMessageTimestamp = Timestamp.fromMillisecondsSinceEpoch(
//           _calculateTimestamp(event.docs.last.data()['created']));
//       event.docs?.forEach((element) {
//         final uid = element.data()['user_id'];
//         final textMessage = types.TextMessage(
//             author: types.User(
//                 id: uid,
//                 firstName: userList.firstWhere((element) => element.userID == uid).firstName),
//             id: element.id,
//             metadata: {'type': element.data()['type']},
//             text: element.data()['text'],
//             createdAt: _calculateTimestamp(element.data()['created']));
//         if (!_messageList.any((message) => message.id == textMessage.id))
//           _messageList.add(textMessage);
//       });
//       _messageList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
//       _messageList.reversed;
//       List<types.Message> messageList = _messageList.reversed.toList();
//       _messagesStream.sink.add(messageList);
//     });
//   }
//
//   int _calculateTimestamp(Timestamp timestamp) => (timestamp == '' || timestamp == null)
//       ? Timestamp.fromDate(DateTime.now()).millisecondsSinceEpoch
//       : timestamp.millisecondsSinceEpoch;
//
//   void _initChosenChatInfoStream() => widget.chatsInfoStream.listen((event) {
//         _chosenChatStreamController.sink
//             .add(event.firstWhere((element) => element.chatId == widget.chat.chatId));
//       });
//
//   void _mergeStreams() {
//     _mergedStream = StreamGroup.merge([_chosenChatStreamController.stream, _messagesStream.stream]);
//
//     ///HERE WE ARE ADDING INITIAL DATA THAT IS LOST AT THE BEGINNING
//     _chosenChatStreamController.sink.add(widget.chat);
//   }
//
//   ChatMessageType _chatMessageTypeCalc(dynamic type) {
//     if (type == 'text') {
//       return ChatMessageType.text;
//     } else if (type == 'voice') {
//       return ChatMessageType.voice;
//     } else if (type == 'file') {
//       return ChatMessageType.file;
//     }
//     return ChatMessageType.text;
//   }
//
//   void _addTempMessage(
//       List<types.Message> messages, String filePath, ChatMessageType chatMessageType) {
//     String type;
//     switch (chatMessageType) {
//       case ChatMessageType.file:
//         type = 'file';
//         break;
//       case ChatMessageType.voice:
//         type = 'voice';
//         break;
//       case ChatMessageType.text:
//         type = 'text';
//         break;
//       default:
//         type = 'text';
//         break;
//     }
//     final tempMess = types.TextMessage(
//         author: types.User(id: widget.user.userID, firstName: widget.user.firstName),
//         id: 'none',
//         metadata: {'type': type},
//         text: filePath,
//         createdAt: DateTime.now().millisecondsSinceEpoch);
//
//     messages.add(tempMess);
//     messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
//     messages.reversed;
//     List<types.Message> messageList = messages.reversed.toList();
//     _messagesStream.sink.add(messageList);
//   }
//
//   Future<void> _sendFileMessage(String chatID, String filePath, List<types.Message> messages,
//       bool interlocutorIsOnScreen) async {
//     String fileName = '${DateTime.now().millisecondsSinceEpoch}_${chatID}';
//     File file = File(filePath);
//     try {
//       _addTempMessage(messages, filePath, ChatMessageType.file);
//
//       await firebase_storage.FirebaseStorage.instance
//           .ref('file-messages/$fileName')
//           .putFile(file)
//           .then((res) async {
//         String fileUrl = await res.ref.getDownloadURL();
//         final messageTimestamp = FieldValue.serverTimestamp();
//
//         var map = {
//           'text': fileUrl,
//           'created': messageTimestamp,
//           'user_id': widget.user.userID,
//           'type': 'file',
//         };
//
//         final messageId = await chatServices.sendPrivateMessage(widget.user.userID, chatID, map);
//         _updateChatDetails({
//           'last_message_timestamp': messageTimestamp,
//           'last_message': map['text'],
//           'last_message_id': messageId,
//           'last_message_type': map['type'],
//           'last_sender_id': map['user_id'],
//           'read': interlocutorIsOnScreen,
//           'typing': chat.typing.remove(widget.user.userID)
//         });
//       });
//     } on firebase_storage.FirebaseException catch (e) {
//       print(e);
//     }
//   }
//
//   Future<void> _sendVoiceMessage(
//       String chatID, List<types.Message> messages, bool interlocutorIsOnScreen) async {
//     Directory appDirectory = await getApplicationDocumentsDirectory();
//     String filePath = '${appDirectory.path}/voice_message.m4a';
//     File file = File(filePath);
//     String fileName = '${DateTime.now().millisecondsSinceEpoch}_${chatID}';
//
//     try {
//       _addTempMessage(messages, filePath, ChatMessageType.voice);
//
//       await firebase_storage.FirebaseStorage.instance
//           .ref('voice-messages/$fileName')
//           .putFile(file)
//           .then((res) async {
//         String fileUrl = await res.ref.getDownloadURL();
//         final messageTimestamp = FieldValue.serverTimestamp();
//         var map = {
//           'text': fileUrl,
//           'created': messageTimestamp,
//           'user_id': widget.user.userID,
//           'type': 'voice'
//         };
//         final messageId = await chatServices.sendPrivateMessage(widget.user.userID, chatID, map);
//         _updateChatDetails({
//           'last_message_timestamp': messageTimestamp,
//           'last_message': map['text'],
//           'last_message_id': messageId,
//           'last_message_type': map['type'],
//           'last_sender_id': map['user_id'],
//           'read': interlocutorIsOnScreen,
//           'typing': chat.typing.remove(widget.user.userID)
//         });
//       });
//     } on firebase_storage.FirebaseException catch (e) {
//       print(e);
//     }
//   }
//
//   Future<void> _sendTextMessage(
//       String chatID, List<types.Message> messages, bool interlocutorIsOnScreen) async {
//     final messageTimestamp = FieldValue.serverTimestamp();
//     var map = {
//       'text': _textEditingController.text,
//       'created': messageTimestamp,
//       'user_id': widget.user.userID,
//       'type': 'text'
//     };
//     final messageId = await chatServices.sendPrivateMessage(widget.user.userID, chatID, map);
//     chatServices.updateChatInfo(widget.chat.chatId, {
//       'last_message_timestamp': messageTimestamp,
//       'last_message': map['text'],
//       'last_message_id': messageId,
//       'last_message_type': map['type'],
//       'last_sender_id': map['user_id'],
//       'read': interlocutorIsOnScreen,
//       'typing': chat.typing.remove(widget.user.userID)
//     });
//
//     _textEditingController.clear();
//   }
//
//   Future<void> _updateChatDetails(Map<String, dynamic> details) async =>
//       chatServices.updateChatInfo(widget.chat.chatId, details);
//
//   void _updateVoiceDataSource(String source) => setState(() {
//         _playingVoiceMessageDataSource = source;
//       });
//
//   @override
//   void dispose() {
//     _messagesStream.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final pushNotificationP = ref.watch(pushNotificationProvider);
//     final user = ref
//         .read(usersNotifier)
//         .userList
//         .firstWhere((element) => element.userID == ref.read(authServiceViewModel).user.uid);
//     final users = ref.read(usersNotifier).userList;
//
//     final chatName = chat.isGroupChat
//         ? 'Group'
//         : ref
//             .read(usersNotifier)
//             .userList
//             .firstWhere((element1) =>
//                 element1.userID == chat.users.where((element2) => element2 != user.userID).first)
//             .firstName;
//     final color = chat.isGroupChat
//         ? '26A69A'
//         : ref
//             .read(usersNotifier)
//             .userList
//             .firstWhere((element1) =>
//                 element1.userID == chat.users.where((element2) => element2 != user.userID).first)
//             .color;
//     return StreamBuilder<Object>(
//         stream: _mergedStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text("Could not retrieve data"));
//           }
//           if (!snapshot.hasData) {
//             return _mockedChatScreenView(color: color, chatName: chatName);
//           }
//           if (snapshot.data.runtimeType == models.Chat)
//             chat = snapshot.data;
//           else {
//             listOfMessages = snapshot.data;
//           }
//           return Scaffold(
//               backgroundColor: Colors.grey[50],
//               appBar: AppBar(
//                 centerTitle: true,
//                 backgroundColor: ColorManipulator.lighten(HexColor(color)),
//                 leading: IconButton(
//                   icon: Icon(CupertinoIcons.chevron_left,
//                       color: ColorManipulator.darken(HexColor(color))),
//                   onPressed: () {
//                     Navigator.pop(context);
//                     pushNotificationP.notify();
//                   },
//                 ),
//                 title: Text(chatName.toUpperCase(),
//                     style: TextStyle(
//                         height: 0,
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: ColorManipulator.darken(HexColor(color)))),
//               ),
//               body: SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.9,
//                 child: Chat(
//                   onEndReached: () async {
//                     return await Future.delayed(Duration(seconds: 1))
//                         .then((value) => _downloadMoreMessages());
//                   },
//                   theme: DefaultChatTheme(
//                       backgroundColor: Colors.transparent,
//                       userAvatarNameColors: chat.users
//                           .map((e) =>
//                               HexColor(users.firstWhere((element) => element.userID == e).color))
//                           .toList()),
//                   showUserAvatars: true,
//                   messages: listOfMessages,
//                   user: types.User(id: widget.user.userID),
//                   customBottomWidget: ChatScreenCustomBottomWidget(
//                     typing: chat.typing,
//                     read: chat.read,
//                     messages: listOfMessages,
//                     textEditingController: _textEditingController,
//                     updateChatDetails: _updateChatDetails,
//                     sendTextMessage: _sendTextMessage,
//                     sendFileMessage: _sendFileMessage,
//                     sendVoiceMessage: _sendVoiceMessage,
//                     user: widget.user,
//                     chatId: widget.chat.chatId,
//                     audioRecorder: _audioRecorder,
//                   ),
//                   bubbleBuilder: (Widget child, {types.Message message, bool nextMessageInGroup}) =>
//                       MessageBubble(
//                     playingVoiceMessageDataSource: _playingVoiceMessageDataSource,
//                     choseAudioFileSource: _updateVoiceDataSource,
//                     child: child,
//                     user: widget.user,
//                     message: message,
//                     messageRead: true,
//                     displayReadOrSentInfo: listOfMessages.first != message,
//                     chatMessageType: _chatMessageTypeCalc(message.metadata['type']),
//                     audioPlayer: _audioPlayer,
//                   ),
//                 ),
//               ));
//         });
//   }
//
//   Future<void> _downloadMoreMessages() async {
//     final userList = ref.read(usersNotifier).userList;
//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chat.chatId)
//         .collection("messages")
//         .where('created', isLessThan: _oldestMessageTimestamp)
//         .orderBy('created', descending: true)
//         .limit(10)
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       _oldestMessageTimestamp = Timestamp.fromMillisecondsSinceEpoch(
//           _calculateTimestamp(querySnapshot.docs.last['created']));
//       querySnapshot.docs.forEach((doc) {
//         final uid = doc.get('user_id');
//         final textMessage = types.TextMessage(
//             author: types.User(
//                 id: uid,
//                 firstName: userList.firstWhere((element) => element.userID == uid).firstName),
//             id: doc.id,
//             metadata: {'type': doc.get('type')},
//             text: doc.get('text'),
//             createdAt: _calculateTimestamp(doc.get('created')));
//         _messageList.add(textMessage);
//         _messageList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
//         _messageList.reversed;
//         List<types.Message> messageList = _messageList.reversed.toList();
//         _messagesStream.sink.add(messageList);
//       });
//     });
//   }
//
//   Widget _mockedChatScreenView({String color, String chatName}) {
//     return Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: ColorManipulator.lighten(HexColor(color)),
//           leading: IconButton(
//             icon:
//                 Icon(CupertinoIcons.chevron_left, color: ColorManipulator.darken(HexColor(color))),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: Text(
//             chatName.toUpperCase(),
//             style: Theme.of(context)
//                 .textTheme
//                 .headline1
//                 .copyWith(color: ColorManipulator.darken(HexColor(color))),
//           ),
//         ),
//         body: Center(
//             child: CircularProgressIndicator(
//           color: Colors.teal[400],
//         )));
//   }
// }
