import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../additional_widgets/color_manipulator.dart';
import '../../additional_widgets/hex_color.dart';

class MockedChatScreenView extends StatelessWidget {
  final String color;
  final String chatName;

  const MockedChatScreenView({this.chatName, this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ColorManipulator.lighten(HexColor(color)),
          leading: IconButton(
            icon:
                Icon(CupertinoIcons.chevron_left, color: ColorManipulator.darken(HexColor(color))),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            chatName.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(color: ColorManipulator.darken(HexColor(color))),
          ),
        ),
        body: Center(
            child: CircularProgressIndicator(
          color: Colors.teal[400],
        )));
  }
}
