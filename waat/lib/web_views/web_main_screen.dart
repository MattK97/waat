import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/views/schedule_tab/schedule_tab.dart';
import 'package:newappc/views/settings_tab/settings_tab.dart';
import 'package:newappc/web_views/calendar_tab/web_calendar_tab.dart';
import 'package:newappc/web_views/pinboard_tab/web_pinboard_tab.dart';
import 'package:newappc/web_views/task_tab/web_task_tab.dart';

import '../views/chat_tab/chat_tab.dart';

class WebMainScreen extends StatefulWidget {
  const WebMainScreen({Key key}) : super(key: key);

  @override
  State<WebMainScreen> createState() => _WebMainScreenState();
}

class _WebMainScreenState extends State<WebMainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                label: Text('Calendar'),
                icon: _selectedIndex == 0
                    ? Icon(CupertinoIcons.calendar_circle_fill)
                    : Icon(CupertinoIcons.calendar_circle),
              ),
              NavigationRailDestination(
                label: Text('Pinboard'),
                icon:
                    _selectedIndex == 1 ? Icon(CupertinoIcons.pin_fill) : Icon(CupertinoIcons.pin),
              ),
              NavigationRailDestination(
                label: Text('Tasks'),
                icon:
                    _selectedIndex == 2 ? Icon(CupertinoIcons.tag_fill) : Icon(CupertinoIcons.tag),
              ),
              NavigationRailDestination(
                label: Text('Schedule'),
                icon: _selectedIndex == 3
                    ? Icon(CupertinoIcons.person_fill)
                    : Icon(CupertinoIcons.person),
              ),
              NavigationRailDestination(
                label: Text('Chat'),
                icon: Badge(
                  child: _selectedIndex == 4
                      ? Icon(CupertinoIcons.chat_bubble_fill)
                      : Icon(CupertinoIcons.chat_bubble),
                ),
              ),
              NavigationRailDestination(
                label: Text('Settings'),
                icon: _selectedIndex == 5
                    ? Icon(CupertinoIcons.line_horizontal_3)
                    : Icon(CupertinoIcons.line_horizontal_3),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: Stack(
              children: <Widget>[
                new Offstage(
                  offstage: _selectedIndex != 0,
                  child: new TickerMode(
                    enabled: _selectedIndex == 0,
                    child: WebCalendarAnimatedSwitcher(),
                  ),
                ),
                new Offstage(
                  offstage: _selectedIndex != 1,
                  child: new TickerMode(
                    enabled: _selectedIndex == 1,
                    child: WebPinboardAnimatedSwitcher(),
                  ),
                ),
                new Offstage(
                  offstage: _selectedIndex != 2,
                  child: new TickerMode(
                    enabled: _selectedIndex == 2,
                    child: WebTaskAnimatedSwitcher(),
                  ),
                ),
                new Offstage(
                  offstage: _selectedIndex != 3,
                  child: new TickerMode(
                    enabled: _selectedIndex == 3,
                    child: ScheduleTab(),
                  ),
                ),
                new Offstage(
                  offstage: _selectedIndex != 4,
                  child: new TickerMode(enabled: _selectedIndex == 4, child: ChatTab() //WallTab()
                      ),
                ),
                new Offstage(
                  offstage: _selectedIndex != 5,
                  child: new TickerMode(
                      enabled: _selectedIndex == 5, child: SettingsTabAnimatedSwitcher()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
