
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

//import 'package:bitsdojo_window/bitsdojo_window.dart';

//https://pub.dev/packages/system_tray
//import 'package:system_tray/system_tray.dart';

import 'package:tray_manager/tray_manager.dart';


//pubspec tray_manager:

class SysTray  {

  //@override
  //void initState() {
  SysTray() {
    print("here systray");
    initSystemTray();
  }

  Future<void> initSystemTray() async {
    print("initSystemTray");
    String path;
    if (Platform.isWindows) {
      path = p.joinAll([
        p.dirname(Platform.resolvedExecutable),
        'data/flutter_assets/assets',
        'app_icon.ico'
      ]);
    } else if (Platform.isMacOS) {
      path = p.joinAll(['AppIcon']);
    } else {
      path = p.joinAll([
        p.dirname(Platform.resolvedExecutable),
        'data/flutter_assets/assets',
        'app_icon.png'
      ]);
      print(path);
    }

    //await _systemTray.initSystemTray(title:"system tray", iconPath: path, toolTip: "How to use system tray with Flutter");


    await trayManager.setIcon(path);
    List<MenuItem> items = [
      MenuItem(
        key: 'show_window',
        title: 'Show Window',
      ),
      MenuItem.separator,
      MenuItem(
        key: 'exit_app',
        title: 'Exit App',
      ),
    ];
    await trayManager.setContextMenu(items);

  }
/*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: WindowBorder(
          color: const Color(0xFF805306),
          width: 1,
          child: Row(
            children: [
              const LeftSide(),
              const RightSide(),
            ],
          ),
        ),
      ),
    );
  }
 */
}
