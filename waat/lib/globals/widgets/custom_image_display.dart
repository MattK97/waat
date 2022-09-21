import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomImageDisplay extends StatelessWidget {
  final String url;
  CustomImageDisplay({this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.clear),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
