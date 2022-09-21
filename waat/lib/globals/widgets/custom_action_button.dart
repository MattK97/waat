import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:newappc/globals/styles/paddings.dart';

class CustomActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color color;
  final String text;
  final bool negativeStyle;
  final bool disabled;

  CustomActionButton({this.onPressed, this.color, this.text, this.negativeStyle, this.disabled});

  @override
  _CustomActionButtonState createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton> {
  bool _performingAction = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: allSixteen,
      child: widget.disabled != null && widget.disabled
          ? ElevatedButton(
              onPressed: null,
              child: Text(
                widget.text == null ? AppLocalizations.of(context).save : widget.text,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.fromLTRB(32, 16, 32, 16)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[400]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.grey[400]),
                  ))))
          : ElevatedButton(
              onPressed: () async {
                setState(() {
                  _performingAction = true;
                });
                await widget.onPressed();
                setState(() {
                  _performingAction = false;
                });
              },
              child: _performingAction
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      widget.text == null
                          ? AppLocalizations.of(context).save
                          : widget.text, //TODO ADD LOCALIZATION
                      style: widget.negativeStyle != null && widget.negativeStyle
                          ? TextStyle(color: Colors.teal[400], fontWeight: FontWeight.bold)
                          : TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
              style: widget.negativeStyle != null && widget.negativeStyle
                  ? ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.fromLTRB(32, 16, 32, 16)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(widget.color ?? Colors.white),
                      shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.teal[400]),
                      )))
                  : ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.fromLTRB(32, 16, 32, 16)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(widget.color ?? Colors.teal[400]),
                      shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide.none,
                      ))),
            ),
    );
  }
}
