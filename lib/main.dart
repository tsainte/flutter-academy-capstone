import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_academy_capstone/Network/study_aid_api.dart';
import 'package:flutter_academy_capstone/view/main/main_cupertino_app.dart';

void main() {
  //TODO: Material version
  Widget mainApp = Platform.isIOS ? MainCupertinoApp() : MainCupertinoApp();
  runApp(mainApp);
}
