import 'package:flutter/cupertino.dart';

class NavBar {
  static CupertinoNavigationBar make(String text) {
    return CupertinoNavigationBar(
      middle: Text(
        text,
        style: TextStyle(color: CupertinoColors.darkBackgroundGray),
      ),
      backgroundColor: Color(0xFF81D4Fa),
    );
  }
}
