import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/additional_widgets/color_manipulator.dart';
import 'package:newappc/additional_widgets/hex_color.dart';

class ConversationIcon extends StatelessWidget {
  final String name;
  final String hexColor;
  final bool isOnline;

  ConversationIcon(this.name, this.hexColor, this.isOnline);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 80.0,
        height: 80.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle, color: ColorManipulator.lighten(HexColor(hexColor), 0.03)),
        child: Stack(
          children: [
            isOnline
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4, right: 10),
                      child: Container(
                        width: 15.0,
                        height: 15.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.greenAccent,
                            border: Border.all(color: Colors.white, width: 2)),
                      ),
                    ),
                  )
                : SizedBox(),
            Center(
                child: Text(
              name[0],
              style: TextStyle(
                  color: ColorManipulator.darken(HexColor(hexColor), 0.4),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )),
          ],
        ));
  }
}
