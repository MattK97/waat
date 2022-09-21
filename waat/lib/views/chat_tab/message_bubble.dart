import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/chat_tab/bottom_widget/bottom_widget.dart';
import 'package:newappc/views/chat_tab/message_bubble/app_user_message_bubble.dart';
import 'package:newappc/views/chat_tab/message_bubble/interlocutor_message_bubble.dart';

class MessageBubble extends ConsumerStatefulWidget {
  final types.TextMessage message;

  MessageBubble({this.message});

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<MessageBubble> {
  List<AudioWaveBar> _unreadWaveBars;
  List<AudioWaveBar> _readWaveBars;
  ChatMessageType _chatMessageType;

  @override
  void initState() {
    super.initState();
    Color unreadColor = Colors.white;
    Color readColor = ref.read(appUserProvider).userID == widget.message.author.id
        ? Colors.teal[600]
        : Colors.grey[600];
    _chatMessageType = ChatMessageType.values.byName(widget.message.metadata['type']);

    _initializeWaveBars(unreadColor, readColor);
  }

  void _initializeWaveBars(Color unreadColor, Color readColor) {
    _unreadWaveBars = [
      AudioWaveBar(heightFactor: 0.10, color: unreadColor),
      AudioWaveBar(heightFactor: 0.30, color: unreadColor),
      AudioWaveBar(heightFactor: 0.70, color: unreadColor),
      AudioWaveBar(heightFactor: 0.40, color: unreadColor),
      AudioWaveBar(heightFactor: 0.20, color: unreadColor),
      AudioWaveBar(heightFactor: 0.10, color: unreadColor),
      AudioWaveBar(heightFactor: 0.30, color: unreadColor),
      AudioWaveBar(heightFactor: 0.70, color: unreadColor),
      AudioWaveBar(heightFactor: 0.40, color: unreadColor),
      AudioWaveBar(heightFactor: 0.20, color: unreadColor),
      AudioWaveBar(heightFactor: 0.10, color: unreadColor),
      AudioWaveBar(heightFactor: 0.30, color: unreadColor),
      AudioWaveBar(heightFactor: 0.70, color: unreadColor),
      AudioWaveBar(heightFactor: 0.40, color: unreadColor),
      AudioWaveBar(heightFactor: 0.20, color: unreadColor),
      AudioWaveBar(heightFactor: 0.10, color: unreadColor),
      AudioWaveBar(heightFactor: 0.30, color: unreadColor),
      AudioWaveBar(heightFactor: 0.70, color: unreadColor),
      AudioWaveBar(heightFactor: 0.40, color: unreadColor),
      AudioWaveBar(heightFactor: 0.20, color: unreadColor),
      AudioWaveBar(heightFactor: 0.10, color: unreadColor),
    ];

    _readWaveBars = [
      AudioWaveBar(heightFactor: 0.10, color: readColor),
      AudioWaveBar(heightFactor: 0.30, color: readColor),
      AudioWaveBar(heightFactor: 0.70, color: readColor),
      AudioWaveBar(heightFactor: 0.40, color: readColor),
      AudioWaveBar(heightFactor: 0.20, color: readColor),
      AudioWaveBar(heightFactor: 0.10, color: readColor),
      AudioWaveBar(heightFactor: 0.30, color: readColor),
      AudioWaveBar(heightFactor: 0.70, color: readColor),
      AudioWaveBar(heightFactor: 0.40, color: readColor),
      AudioWaveBar(heightFactor: 0.20, color: readColor),
      AudioWaveBar(heightFactor: 0.10, color: readColor),
      AudioWaveBar(heightFactor: 0.30, color: readColor),
      AudioWaveBar(heightFactor: 0.70, color: readColor),
      AudioWaveBar(heightFactor: 0.40, color: readColor),
      AudioWaveBar(heightFactor: 0.20, color: readColor),
      AudioWaveBar(heightFactor: 0.10, color: readColor),
      AudioWaveBar(heightFactor: 0.30, color: readColor),
      AudioWaveBar(heightFactor: 0.70, color: readColor),
      AudioWaveBar(heightFactor: 0.40, color: readColor),
      AudioWaveBar(heightFactor: 0.20, color: readColor),
      AudioWaveBar(heightFactor: 0.10, color: readColor),
    ];
  }

  List<AudioWaveBar> _calculateWaveBars(double value) {
    if (value == 0 || value == null) return _unreadWaveBars;
    int end = ((value * 10).toInt() * 2);

    List<AudioWaveBar> result = [];
    result.addAll(_readWaveBars.getRange(0, end));
    result.addAll(_unreadWaveBars.getRange(end, 20));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ref.read(appUserProvider).userID == widget.message.author.id
        ? AppUserMessageBubble(
            message: widget.message,
          )
        : InterlocutorMessageBubble(
            message: widget.message,
          );
  }

// Widget _buildInterlocutorBubbleWidget() {
//   return _chatMessageType == ChatMessageType.file
//       ? _buildInterlocutorBubble()
//       : _buildCardInterlocutorBubble();
// }
//
// Widget _buildInterlocutorBubble() {
//   return Builder(
//     builder: (context) {
//       if (widget.chatMessageType == ChatMessageType.text) {
//         return Text(
//           widget.message.text,
//           style: TextStyle(color: Colors.white, fontSize: 16),
//         );
//       } else if (widget.chatMessageType == ChatMessageType.voice) {
//         return _buildAudioMessageContent();
//       } else if (widget.chatMessageType == ChatMessageType.file) {
//         return _buildFileContent(context: context);
//       }
//       return Text(
//         widget.message.text,
//         style: TextStyle(color: Colors.white, fontSize: 16),
//       );
//     },
//   );
// }
//
// Widget _buildCardUserBubble() {
//   return Card(
//       elevation: 0,
//       margin: EdgeInsets.all(0),
//       color: Colors.teal[400],
//       child: Padding(
//           padding: EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 12),
//           child: _buildUserBubble()));
// }
//
// Widget _buildCardInterlocutorBubble() {
//   return Card(
//       elevation: 0,
//       margin: EdgeInsets.all(0),
//       color: Colors.grey[400],
//       child: Padding(
//           padding: EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 12),
//           child: _buildInterlocutorBubble()));
// }
//
// Widget _buildTextMessageContent() {
//   if (widget.message.text.startsWith('http') || widget.message.text.startsWith('www.')) {
//     return Linkify(
//       onOpen: (link) async {
//         if (await canLaunch(link.url)) {
//           await launch(link.url);
//         } else {
//           throw 'Could not launch $link';
//         }
//       },
//       text: widget.message.text,
//       style: TextStyle(color: Colors.white),
//       linkStyle: TextStyle(color: Colors.white),
//     );
//   }
//   return Text(
//     widget.message.text,
//     style: TextStyle(color: Colors.white, fontSize: 16),
//   );
// }
//
// Widget _buildAudioMessageContent() {
//   return Row(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       widget.message.text == widget.playingVoiceMessageDataSource
//           ? StreamBuilder<Object>(
//           stream: widget.audioPlayer.isPlayingStream,
//           builder: (context, isPlayingSnapshot) {
//             if (!isPlayingSnapshot.hasData) {
//               return IconButton(
//                   icon: Icon(
//                     CupertinoIcons.play_circle,
//                     color: Colors.white,
//                   ));
//             }
//             return IconButton(
//               icon: isPlayingSnapshot.data
//                   ? StreamBuilder<bool>(
//                   stream: widget.audioPlayer.isLoadingStream,
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return SizedBox(
//                         height: 16,
//                         width: 16,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       );
//                     }
//                     if (!snapshot.data) {
//                       if (!snapshot.hasData) {
//                         return SizedBox(
//                           height: 16,
//                           width: 16,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         );
//                       }
//                     }
//                     return Icon(
//                       CupertinoIcons.stop_circle,
//                       color: Colors.white,
//                     );
//                   })
//                   : Icon(
//                 CupertinoIcons.play_circle,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 if (isPlayingSnapshot.data) {
//                   widget.audioPlayer.stop();
//                 } else {
//                   widget.audioPlayer.playFromUrl(widget.message.text);
//                 }
//               },
//             );
//           })
//           : IconButton(
//           onPressed: () {
//             widget.choseAudioFileSource(widget.message.text);
//             widget.audioPlayer.playFromUrl(widget.message.text);
//           },
//           icon: Icon(
//             CupertinoIcons.play_circle,
//             color: Colors.white,
//           )),
//       _buildAudioProgressWave(),
//     ],
//   );
// }
//
// Route _createRoute(String url) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) =>
//         ImageDisplay(
//           url: url,
//         ),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       return child;
//     },
//   );
// }
//
// Widget _buildFileContent({BuildContext context}) {
//   return ConstrainedBox(
//       constraints: BoxConstraints(
//           maxHeight: MediaQuery
//               .of(context)
//               .size
//               .height / 3,
//           maxWidth: MediaQuery
//               .of(context)
//               .size
//               .width / 3),
//       child: InkWell(
//         onTap: () {
//           Navigator.of(context).push(_createRoute(widget.message.text));
//         },
//         child: ClipRRect(
//             borderRadius: BorderRadius.circular(16.0),
//             child: widget.message.id != 'none'
//                 ? Image.network(
//               widget.message.text,
//               loadingBuilder:
//                   (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Container(
//                   height: 160,
//                   width: 100,
//                   color: Colors.grey[400],
//                 );
//               },
//             )
//                 : Image.file(
//               File(widget.message.text),
//             )),
//       ));
// }
//
// Widget _buildAudioProgressWave() {
//   return StreamBuilder<Object>(
//       stream: widget.audioPlayer.playingProgressStream,
//       builder: (context, snapshot) {
//         if (snapshot.data == null || snapshot.data == 0) {
//           return AudioWave(
//             animation: false,
//             height: 32,
//             width: 148,
//             spacing: 2.5,
//             bars: _unreadWaveBars,
//           );
//         }
//         if (widget.message.text != widget.playingVoiceMessageDataSource) {
//           return AudioWave(
//             animation: false,
//             height: 32,
//             width: 148,
//             spacing: 2.5,
//             bars: _unreadWaveBars,
//           );
//         }
//         return AudioWave(
//           animation: false,
//           height: 32,
//           width: 148,
//           spacing: 2.5,
//           bars: _calculateWaveBars(snapshot.data),
//         );
//       });
// }
}

///TODO
///replace with [custom_image_display.dart]
///
class ImageDisplay extends StatelessWidget {
  final String url;

  ImageDisplay({this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.clear),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
