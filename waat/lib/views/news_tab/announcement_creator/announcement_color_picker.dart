import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:newappc/additional_widgets/hex_color.dart';
import 'package:newappc/globals/styles/paddings.dart';
import 'package:newappc/globals/styles/radiuses.dart';
import 'package:newappc/models/ColorM.dart';

class AnnouncementColorPicker extends StatelessWidget {
  final ColorM colorM;
  final List<ColorM> listOfColors;
  final Function(ColorM chosenColor) notifyParent;
  AnnouncementColorPicker({this.colorM, this.listOfColors, this.notifyParent});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: inputFieldPadding,
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: borderRadius,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: AppLocalizations.of(context).flag,
        ),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: listOfColors.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  notifyParent(listOfColors[index]);
                },
                child: Icon(
                  CupertinoIcons.pin_fill,
                  color: HexColor(listOfColors[index].colorHex),
                ));
          },
        ),
      ),
    );
  }
}
