import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:newappc/additional_widgets/hex_color.dart';
import 'package:newappc/models/ColorM.dart';

class CustomColorPicker extends StatelessWidget {
  final List<ColorM> colorList;
  final ColorM chosenColor;
  final Function(ColorM color) notifyParent;

  const CustomColorPicker({Key key, this.colorList, this.chosenColor, this.notifyParent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: colorList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            notifyParent(colorList[index]);
          },
          child: Card(
            margin: EdgeInsets.all(5),
            color: HexColor(colorList[index].colorHex),
          ),
        );
      },
    );
  }
}
