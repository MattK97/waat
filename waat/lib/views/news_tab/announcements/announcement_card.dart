import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/additional_widgets/color_manipulator.dart';
import 'package:newappc/additional_widgets/hex_color.dart';

class AnnouncementCard extends StatelessWidget {
  final String hexColor;
  final String announcementTitle;
  final String announcementInfo;
  final DateTime announcementCreationDateTime;
  final String announcementCreator;
  final height;
  final width;

  AnnouncementCard(
      {this.hexColor,
      this.height,
      this.width,
      this.announcementTitle,
      this.announcementInfo,
      this.announcementCreationDateTime,
      this.announcementCreator});

  @override
  Widget build(BuildContext context) {
    final GlobalKey key = GlobalKey();
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 5,
        child: Container(
          key: key,
          height: height,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: ColorManipulator.lighten(HexColor(hexColor))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 15, top: 15, bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.pin_fill,
                      color: ColorManipulator.darken(HexColor(hexColor)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 6,
                        child: Text(announcementTitle,
                            style: Theme.of(context).textTheme.headline6.copyWith(
                                color: ColorManipulator.darken(HexColor(hexColor)),
                                fontWeight: FontWeight.bold,
                                fontSize: 16))),
                    Expanded(
                      flex: 2,
                      child: Icon(
                        CupertinoIcons.ellipsis,
                        color: ColorManipulator.darken(HexColor(hexColor)),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  color: ColorManipulator.darken(HexColor(hexColor)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Text(
                  announcementInfo,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: ColorManipulator.darken(HexColor(hexColor))),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 20, bottom: 20),
                child: Row(
                  children: [
                    Spacer(),
                    Column(
                      children: [
                        Text(
                          announcementCreator,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 12, color: ColorManipulator.darken(HexColor(hexColor))),
                        ),
                        Text(
                          Jiffy(announcementCreationDateTime).yMMMd,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 12, color: ColorManipulator.darken(HexColor(hexColor))),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
