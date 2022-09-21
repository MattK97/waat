import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/globals/widgets/custom_input_field.dart';

class CreateTeam extends StatelessWidget {
  final Function(int index) notifyParent;
  final PageController pageController;
  final TextEditingController controller;

  const CreateTeam({Key key, this.notifyParent, this.pageController, this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
            onPressed: () {
              pageController.animateToPage(0,
                  duration: Duration(milliseconds: 300), curve: Curves.linear);
            },
            icon: Icon(CupertinoIcons.chevron_back)),
        CustomInputField(
          notifyParent: (value) => notifyParent(2),
          fieldName: 'Team name',
          textEditingController: controller,
        ),
      ],
    );
  }
}
