import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_academy_capstone/view/badges/badges_list.dart';
import 'package:flutter_academy_capstone/view/study/study_list.dart';

class MainViewModel {
  String title = 'Flutter Academy';

  List<BottomNavigationBarItem> tabBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.bookmark),
      label: 'Study',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.emoji_events),
      label: 'Badges',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.topic),
      label: 'Resources',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  Widget cupertinoTabScreen(int index) {
    switch (index) {
      case 0:
        return CupertinoTabView(builder: (context) => StudyList());
      case 1:
        return CupertinoTabView(builder: (context) => BadgesList());
      case 2:
        return CupertinoTabView(
            builder: (context) => Container(
                  color: Colors.lightBlue[50],
                  child: Center(child: Text('Resources not implemented')),
                ));
      case 3:
        return CupertinoTabView(
            builder: (context) => Container(
                  color: Colors.lightBlue[50],
                  child: Center(child: Text('Settings not implemented')),
                ));
      default:
        return Text('1');
    }
  }
}
