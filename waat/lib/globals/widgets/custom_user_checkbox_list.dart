import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/additional_widgets/color_manipulator.dart';
import 'package:newappc/additional_widgets/hex_color.dart';
import 'package:newappc/globals/styles/paddings.dart';
import 'package:newappc/models/user_checkbox_item.dart';

class CustomUserCheckboxList extends StatefulWidget {
  final Function(List<UserCheckboxItem> updatedUserCheckboxItemList) notifyParent;
  final List<UserCheckboxItem> userCheckboxItemList;

  CustomUserCheckboxList({this.notifyParent, this.userCheckboxItemList});

  @override
  _CustomUserCheckboxListState createState() => _CustomUserCheckboxListState();
}

class _CustomUserCheckboxListState extends State<CustomUserCheckboxList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: inputFieldPadding,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.userCheckboxItemList.length,
          itemBuilder: (context, index) {
            final UserCheckboxItem userCheckboxItem = widget.userCheckboxItemList[index];
            return Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: ColorManipulator.lighten(HexColor(userCheckboxItem.user.color), 0.03)),
              margin: const EdgeInsets.only(bottom: 5),
              child: CheckboxListTile(
                activeColor: ColorManipulator.darken(HexColor(userCheckboxItem.user.color)),
                selectedTileColor: ColorManipulator.lighten(HexColor(userCheckboxItem.user.color)),
                checkColor: Colors.white,
                dense: true,
                title: Text(
                  userCheckboxItem.user.firstName,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                      color: ColorManipulator.darken(HexColor(userCheckboxItem.user.color), 0.4)),
                ),
                value: userCheckboxItem.isSelected,
                onChanged: (bool value) {
                  setState(() {
                    userCheckboxItem.isSelected = value;
                    widget.notifyParent(widget.userCheckboxItemList);
                  });
                },
              ),
            );
          },
        ));
  }
}
