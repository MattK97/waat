// import 'dart:io';
//
// import 'package:audio_wave/audio_wave.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:newappc/additional_widgets/color_manipulator.dart';
// import 'package:newappc/additional_widgets/hex_color.dart';
// import 'package:newappc/globals/styles/colors.dart';
// import 'package:newappc/globals/widgets/custom_divider.dart';
// import 'package:newappc/models/Chat.dart';
// import 'package:newappc/models/Team.dart';
// import 'package:newappc/models/User.dart';
// import 'package:newappc/services/AudioRecorder.dart';
// import 'package:newappc/views/chat_tab/typing_indicator.dart';
//
// enum ChatMessageType { text, voice, file }
//
// enum VoiceRecordingState { idle, recording }
//
// class ChatScreenCustomBottomWidget extends StatefulWidget {
//   final User user;
//   final Team team;
//   final Chat chat;
//   final String chatId;
//   final AudioRecorder audioRecorder;
//   final Function(String chatID, List<types.Message> messages, bool interlocutorIsOnScreen)
//       sendTextMessage;
//   final Function(
//           String chatID, String filePath, List<types.Message> messages, bool interlocutorIsOnScreen)
//       sendFileMessage;
//   final Function(String chatID, List<types.Message> messages, bool interlocutorIsOnScreen)
//       sendVoiceMessage;
//   final Function(Map<String, dynamic> details) updateChatDetails;
//   final TextEditingController textEditingController;
//   final List<types.Message> messages;
//   final List<String> typing;
//   final List<String> read;
//
//   ChatScreenCustomBottomWidget(
//       {this.user,
//       this.chat,
//       this.team,
//       this.chatId,
//       this.audioRecorder,
//       this.sendTextMessage,
//       this.sendFileMessage,
//       this.sendVoiceMessage,
//       this.updateChatDetails,
//       this.textEditingController,
//       this.messages,
//       this.typing,
//       this.read});
//
//   @override
//   _ChatScreenCustomBottomWidgetState createState() => _ChatScreenCustomBottomWidgetState();
// }
//
// class _ChatScreenCustomBottomWidgetState extends State<ChatScreenCustomBottomWidget> {
//   XFile pickedFile;
//   ChatMessageType _chatMessageType = ChatMessageType.text;
//   final databaseReference = FirebaseFirestore.instance;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
//       child: Column(
//         children: [
//           Align(
//             alignment: Alignment.bottomLeft,
//             child: TypingIndicator(
//               height: 28,
//               width: 45,
//               showIndicator:
//                   widget.typing.where((element) => element != widget.user.userID).isNotEmpty,
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(
//                   color: Colors.grey, // set border color
//                   width: 1.0), // set border width
//               borderRadius: BorderRadius.all(Radius.circular(32.0)), // set rounded corner radius
//             ),
//             child: _chatMessageType == ChatMessageType.voice
//                 ? _buildAudioInput()
//                 : _buildTextOrFilesInput(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAudioInput() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildVoiceRecorderButton(),
//           flex: 1,
//         ),
//         Expanded(
//           child: Center(
//             child: Container(
//               child: AudioWave(
//                 height: 32,
//                 width: 148,
//                 spacing: 2.5,
//                 bars: [
//                   AudioWaveBar(
//                       heightFactor: 10,
//                       color: ColorManipulator.lighten(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 30,
//                       color: ColorManipulator.darken(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 70,
//                       color: ColorManipulator.lighten(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 40,
//                       color: ColorManipulator.darken(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 20,
//                       color: ColorManipulator.lighten(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 10,
//                       color: ColorManipulator.darken(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 30,
//                       color: ColorManipulator.lighten(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 70,
//                       color: ColorManipulator.darken(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 40,
//                       color: ColorManipulator.lighten(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 20,
//                       color: ColorManipulator.lighten(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 10,
//                       color: ColorManipulator.darken(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 30,
//                       color: ColorManipulator.lighten(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 70,
//                       color: ColorManipulator.darken(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 40,
//                       color: ColorManipulator.lighten(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 20,
//                       color: ColorManipulator.lighten(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 10,
//                       color: ColorManipulator.darken(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 30,
//                       color: ColorManipulator.lighten(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 70,
//                       color: ColorManipulator.darken(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 40,
//                       color: ColorManipulator.lighten(HexColor(widget.user.color))),
//                   AudioWaveBar(
//                       heightFactor: 20,
//                       color: ColorManipulator.lighten(HexColor(widget.user.color))),
//                 ],
//               ),
//             ),
//           ),
//           flex: 7,
//         ),
//         Expanded(
//           child: _buildSendButton(),
//           flex: 1,
//         )
//       ],
//     );
//   }
//
//   Widget _buildTextOrFilesInput() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildMoreButton(),
//           flex: 1,
//         ),
//         Expanded(
//           child: _buildVoiceRecorderButton(),
//           flex: 1,
//         ),
//         Expanded(
//           child: Builder(
//             builder: (context) {
//               if (_chatMessageType == ChatMessageType.text) {
//                 return _buildTextInput();
//               } else if (_chatMessageType == ChatMessageType.file) {
//                 return _buildFileInput();
//               }
//               return _buildTextInput();
//             },
//           ),
//           flex: 7,
//         ),
//         Expanded(
//           child: _buildSendButton(),
//           flex: 1,
//         )
//       ],
//     );
//   }
//
//   Widget _buildSendButton() {
//     return IconButton(
//       icon: Icon(CupertinoIcons.arrow_up_circle),
//       onPressed: () async {
//         if (_chatMessageType == ChatMessageType.file) {
//           widget.sendFileMessage(widget.chatId, pickedFile.path, widget.messages, true);
//           setState(() {
//             _chatMessageType = ChatMessageType.text;
//             pickedFile = null;
//           });
//         } else if (_chatMessageType == ChatMessageType.voice) {
//           widget.audioRecorder.stopRecording();
//           widget.sendVoiceMessage(widget.chatId, widget.messages, true);
//           setState(() {
//             _chatMessageType = ChatMessageType.text;
//           });
//         } else if (_chatMessageType == ChatMessageType.text) {
//           widget.sendTextMessage(widget.chatId, widget.messages, true);
//           _isTyping = false;
//           widget.textEditingController.text = '';
//         }
//       },
//     );
//   }
//
//   bool _isTyping = false;
//
//   Widget _buildTextInput() {
//     return TextField(
//         onChanged: (value) {
//           if (value.isNotEmpty && !_isTyping) {
//             widget.chat.typing.add(widget.user.userID);
//             widget.updateChatDetails({"typing": widget.chat.typing});
//           } else if (value.isEmpty) {
//             widget.chat.typing.remove(widget.user.userID);
//             widget.updateChatDetails({"typing": widget.chat.typing});
//           }
//         },
//         controller: widget.textEditingController,
//         maxLines: null,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: "Wyślij wiadomość",
//         ));
//   }
//
//   Widget _buildFileInput() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Stack(fit: StackFit.passthrough, children: [
//         Container(
//           width: 100,
//           height: 170,
//           child: Image.file(File(pickedFile.path)),
//         ),
//         Align(
//           alignment: Alignment.center,
//           child: IconButton(
//             icon: Icon(
//               CupertinoIcons.clear_circled,
//               color: Colors.red,
//             ),
//             onPressed: () {
//               setState(() {
//                 _chatMessageType = ChatMessageType.text;
//                 pickedFile = null;
//               });
//             },
//           ),
//         ),
//       ]),
//     );
//   }
//
//   Widget _buildMoreButton() {
//     return IconButton(
//       icon: Icon(CupertinoIcons.add),
//       onPressed: () async {
//         showDialog(
//             context: context,
//             builder: (context) {
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//
//                         borderRadius:
//                             BorderRadius.all(Radius.circular(15.0)), // set rounded corner radius
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [_buildCameraButton(), CustomDivider(), _buildImageButton()],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 16,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         decoration: BoxDecoration(
//                           color: primaryPurple,
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(15.0)), // set rounded corner radius
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Center(
//                               child: Text(
//                             "CANCEL",
//                             style: TextStyle(color: Colors.white, fontSize: 20),
//                           )),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             });
//       },
//     );
//   }
//
//   Widget _buildCameraButton() {
//     return GestureDetector(
//       onTap: () async {
//         Navigator.pop(context);
//         pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
//         if (pickedFile != null) {
//           setState(() {
//             _chatMessageType = ChatMessageType.file;
//           });
//         }
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 1,
//               child: Icon(CupertinoIcons.camera),
//             ),
//             Expanded(
//               flex: 4,
//               child: Text("Camera"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageButton() {
//     return GestureDetector(
//       onTap: () async {
//         Navigator.pop(context);
//         pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//         if (pickedFile != null) {
//           setState(() {
//             _chatMessageType = ChatMessageType.file;
//           });
//         }
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 1,
//               child: Icon(CupertinoIcons.photo),
//             ),
//             Expanded(
//               flex: 4,
//               child: Text("Photo"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildVoiceRecorderButton() {
//     return IconButton(
//       icon: Icon(_chatMessageType == ChatMessageType.voice
//           ? CupertinoIcons.clear_circled
//           : CupertinoIcons.mic),
//       onPressed: () {
//         if (_chatMessageType != ChatMessageType.voice) {
//           widget.audioRecorder.startRecording();
//         }
//         setState(() {
//           _chatMessageType == ChatMessageType.voice
//               ? _chatMessageType = ChatMessageType.text
//               : _chatMessageType = ChatMessageType.voice;
//         });
//         // chatScreenVM.sendTextMessage(userID, chatId);
//       },
//     );
//   }
// }
