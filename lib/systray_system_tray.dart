
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:bitsdojo_window/bitsdojo_window.dart';

//https://pub.dev/packages/system_tray
import 'package:system_tray/system_tray.dart';

import 'defs.dart';


//pubspec system_tray:

class SysTray  {

  final VoidStringCallback msgcallback;
  //const Navbar({required this.msgcallback, Key? key}) : super(key: key);

  final SystemTray _systemTray = SystemTray();
  Timer? _timer;
  bool _toogleTrayIcon = true;

  //@override
  //void initState() {
  SysTray( this.msgcallback ) {
    print("systray constructor");
    //msgcallback = _msgcallback;
    //super.initState();
    initSystemTray();
  }

  @override
  void dispose() {
    print("systray dispose()");
    //super.dispose();
    _timer?.cancel();
  }

  Future<void> initSystemTray() async {
    print("systray initSystemTray");
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
        'tray.svg'
      ]);
      print(path);
    }

    final menu = [
      MenuItem(label: 'Play', onClicked: (){ msgcallback("systray:play"); } ),
      MenuItem(label: 'Pause', onClicked: (){ msgcallback("systray:pause"); } ),
      MenuItem(label: 'Next', onClicked: (){ msgcallback("systray:next"); } ),
      MenuItem(label: 'Previous', onClicked: (){ msgcallback("systray:previous"); } ),
      MenuItem(label: 'Stop', onClicked: (){ msgcallback("systray:stop"); } ),
      MenuItem(label: 'Show', onClicked: (){ msgcallback("systray:show"); } ),
      MenuItem(label: 'Hide', onClicked: (){ msgcallback("systray:hide"); } ),
      MenuItem(label: 'Exit', onClicked: (){ msgcallback("systray:exit"); } ),
    ];

    // We first init the systray menu and then add the menu entries
    await _systemTray.initSystemTray(
      title: "system tray",
      iconPath: path,
    );

    await _systemTray.setContextMenu(menu);

    // handle system tray event
    _systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      print("eventName: $eventName");
    });
  }

}
