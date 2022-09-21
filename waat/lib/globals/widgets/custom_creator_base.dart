import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:newappc/globals/widgets/custom_action_button.dart';

class CustomCreatorBase extends StatelessWidget {
  final Color saveButtonColor;
  final Widget title;
  final List<Widget> children;
  final VoidCallback onSaveButtonPressed;
  final bool isButtonDisabled;

  CustomCreatorBase(
      {this.title,
      this.children,
      this.onSaveButtonPressed,
      this.saveButtonColor,
      this.isButtonDisabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: double.infinity,
        transform: Matrix4.translationValues(0.0, 10.0, 0.0),
        child: SingleChildScrollView(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              title,
              Column(
                children: children.map((e) => e).toList(),
              ),
              onSaveButtonPressed == null
                  ? Container()
                  : CustomActionButton(
                      disabled: isButtonDisabled,
                      onPressed: onSaveButtonPressed,
                      color: saveButtonColor),
              SizedBox(
                height: 32,
              )
            ],
          ),
        ),
      ),
    );
  }
}
