import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newappc/views/chat_tab/bottom_widget/widgets/more_button/camera_button.dart';
import 'package:newappc/views/chat_tab/bottom_widget/widgets/more_button/image_button.dart';

import '../../../../../globals/styles/colors.dart';
import '../../../../../globals/widgets/custom_divider.dart';

final pickedFileProvider = StateProvider<XFile>((ref) => null);

class MoreButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(CupertinoIcons.add),
      onPressed: () async {
        showDialog(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.all(Radius.circular(15.0)), // set rounded corner radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [CameraButton(), CustomDivider(), ImageButton()],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: primaryPurple,
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0)), // set rounded corner radius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                              child: Text(
                            "CANCEL",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
      },
    );
  }
}
