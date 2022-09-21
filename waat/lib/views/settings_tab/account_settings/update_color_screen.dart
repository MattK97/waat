import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/additional_widgets/hex_color.dart';
import 'package:newappc/globals/widgets/custom_action_button.dart';
import 'package:newappc/globals/widgets/custom_color_picker.dart';
import 'package:newappc/models/ColorM.dart';
import 'package:newappc/screens/MainScreen.dart';

class UpdateColor extends ConsumerStatefulWidget {
  @override
  _UpdateColorState createState() => _UpdateColorState();
}

class _UpdateColorState extends ConsumerState<UpdateColor> {
  ColorM _chosenColor;
  String _userHex;

  @override
  void initState() {
    super.initState();
    _userHex = ref
        .read(usersNotifier)
        .userList
        .firstWhere((element) => element.userID == ref.read(authServiceViewModel).user.uid)
        .color;
  }

  void _updateChosenColor(ColorM color) {
    setState(() {
      _chosenColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, children) {
      final colorList = ref.watch(colorListProvider.state).state;
      final usersN = ref.watch(usersNotifier);
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor:
              _chosenColor == null ? HexColor(_userHex) : HexColor(_chosenColor.colorHex),
          leading: IconButton(
            icon: Icon(CupertinoIcons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
          title: Text(
            AppLocalizations.of(context).choose_your_color.toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 32,
            ),
            colorList.isEmpty
                ? CircularProgressIndicator()
                : CustomColorPicker(
                    colorList: colorList,
                    notifyParent: _updateChosenColor,
                    chosenColor: _chosenColor,
                  ),
            CustomActionButton(
              disabled: _chosenColor == null,
              color: _chosenColor == null ? null : HexColor(_chosenColor.colorHex),
              onPressed: () async {
                await usersN.updateUserColor(_chosenColor);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    });
  }
}
