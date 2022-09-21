import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/globals/styles/colors.dart';

enum TileType { task, meeting, schedule }

class CustomTile extends StatelessWidget {
  final VoidCallback onTap;
  final TileType tileType;
  final String title;
  final String startSubtitle;
  final Color iconColor;

  CustomTile({this.onTap, this.tileType, this.title, this.startSubtitle, this.iconColor});

  Widget _icon() {
    if (tileType == TileType.schedule) {
      return CustomScheduleIcon(
        color: iconColor,
      );
    } else if (tileType == TileType.task) {
      return CustomTaskIcon(
        color: iconColor,
      );
    } else if (tileType == TileType.meeting) {
      return CustomMeetingIcon(
        color: iconColor,
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      leading: _icon(),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline5,
      ),
      subtitle: tileType == TileType.meeting && startSubtitle != null ? Text(startSubtitle) : null,
    );
    ;
  }
}

class CustomTaskIcon extends StatelessWidget {
  final Color color;
  CustomTaskIcon({this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(color: color ?? primaryTeal, width: 2)),
      child: Center(
        child: Icon(CupertinoIcons.tag_fill, color: color ?? primaryTeal),
      ),
    );
  }
}

class CustomMeetingIcon extends StatelessWidget {
  final Color color;
  CustomMeetingIcon({this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(color: color ?? primaryPurple, width: 2)),
      child: Center(
        child: Icon(
          CupertinoIcons.person_3_fill,
          color: color ?? primaryPurple,
        ),
      ),
    );
  }
}

class CustomScheduleIcon extends StatelessWidget {
  final Color color;
  CustomScheduleIcon({this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(color: color ?? primaryVinted, width: 2)),
      child: Center(
        child: Icon(CupertinoIcons.clock, color: color ?? primaryVinted),
      ),
    );
  }
}
