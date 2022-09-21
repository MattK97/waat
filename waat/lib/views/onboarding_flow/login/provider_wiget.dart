import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderWidget extends StatelessWidget {
  final String fileName;

  const ProviderWidget({Key key, this.fileName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        shape: const CircleBorder(),
        color: Colors.white,
        child: ClipOval(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset(
            'assets/images/$fileName',
            fit: BoxFit.scaleDown,
            width: 42.0,
            height: 42.0,
          ),
        )));
  }
}
