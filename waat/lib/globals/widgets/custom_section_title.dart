import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSectionTitle extends StatelessWidget {
  final Color color;
  final IconData leftIcon;
  final IconData rightIcon;
  final disableRightIcon;
  final String title;
  final VoidCallback onPressed;
  CustomSectionTitle(
      {this.color,
      this.leftIcon,
      this.rightIcon,
      this.title,
      this.onPressed,
      this.disableRightIcon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Icon(
            leftIcon,
            color: color,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
              flex: 6,
              child: Text(title,
                  style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20))),
          disableRightIcon
              ? Expanded(
              flex: 1,
              child: TextButton(
                onPressed: null,
                child: Icon(
                  rightIcon,
                  size: 27,
                  color: Colors.transparent,
                ),
              ))
              : Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: onPressed,
                    child: Icon(
                      rightIcon,
                      size: 27,
                      color: Colors.black,
                    ),
                  ))
        ],
      ),
    );
  }
}
