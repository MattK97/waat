import 'package:flutter/cupertino.dart';
import 'package:newappc/additional_widgets/color_manipulator.dart';
import 'package:newappc/additional_widgets/hex_color.dart';

class AnnouncementCommenterIcon extends StatelessWidget {
  final String name;
  final String hexColor;

  AnnouncementCommenterIcon(this.name, this.hexColor);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 30.0,
        height: 30.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle, color: ColorManipulator.lighten(HexColor(hexColor), 0.03)),
        child: Center(
            child: Text(
          name[0],
          style: TextStyle(
              color: ColorManipulator.darken(HexColor(hexColor), 0.4),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        )));
  }
}
