import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as flyer_types;
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class TextMessageContent extends StatelessWidget {
  final flyer_types.TextMessage message;

  TextMessageContent({this.message});

  @override
  Widget build(BuildContext context) {
    if (message.text.startsWith('http') || message.text.startsWith('www.')) {
      return Linkify(
        onOpen: (link) async {
          if (await canLaunchUrl(UriData.fromString(link.url).uri)) {
            await launchUrl(UriData.fromString(link.url).uri);
          } else {
            throw 'Could not launch $link';
          }
        },
        text: message.text,
        style: TextStyle(color: Colors.white),
        linkStyle: TextStyle(color: Colors.white),
      );
    }
    return Text(
      message.text,
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }
}
