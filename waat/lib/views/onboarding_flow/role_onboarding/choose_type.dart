import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/globals/styles/colors.dart';

enum ChosenRole { joinTeam, createTeam }

class ChooseType extends StatelessWidget {
  final Function(ChosenRole value) chooseTypeCallback;
  final Function(int index) notifyParent;
  final ChosenRole chosenRole;

  const ChooseType({Key key, this.chooseTypeCallback, this.chosenRole, this.notifyParent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        roleCard(
            text: 'Join team',
            chosenRole: ChosenRole.joinTeam,
            iconData: CupertinoIcons.person_add),
        roleCard(
            text: 'Create team', chosenRole: ChosenRole.createTeam, iconData: CupertinoIcons.group),
      ],
    );
  }

  Widget roleCard({String text, ChosenRole chosenRole, IconData iconData}) {
    return this.chosenRole == chosenRole
        ? Padding(
            padding: EdgeInsets.only(top: 32),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), side: BorderSide(color: primaryTeal)),
              padding: EdgeInsets.all(32),
              color: primaryTeal,
              child: Row(
                children: [
                  Icon(
                    iconData,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
              onPressed: () => chooseTypeCallback(chosenRole),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: 32),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), side: BorderSide(color: primaryTeal)),
              padding: EdgeInsets.all(32),
              color: Colors.white,
              child: Row(
                children: [
                  Icon(
                    iconData,
                    color: primaryTeal,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(text, style: TextStyle(color: primaryTeal, fontSize: 16)),
                ],
              ),
              onPressed: () {
                chooseTypeCallback(chosenRole);
                notifyParent(0);
              },
            ),
          );
  }
}
