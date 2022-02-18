import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

import 'package:universal_platform/universal_platform.dart';

import 'colors.dart';


//mixin Login on State<MyHomePage> {
//mixin Login <T extends StatefulWidget> on State<T> {



  Widget build_login_logo(BuildContext context){
    return Image.asset('assets/hipstur.png');
  }

/*
Widget buildlogin(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Hipstur'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildlogin_logo(context),
          const Text('Login')
        ],
      ),
    )
  );
}
*/

  void do_login(){
    //see if online
    //
  }



  Widget build_login_buttons(BuildContext context ) {

    //if ( UniversalPlatform.isIOS || UniversalPlatform.isMacOS) {
      //
    //}

    return Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: <Widget>[
          const Text('Login'),
          const Text('Google Login'),
          const Text('Facebook Login'),
          const Text('Apple Login'),
          const Text('Demo'),
        ]
    );
  }


  Widget build_login(BuildContext context, @required void _callback(), String errormsg ) {
    return Scaffold(
        backgroundColor: color_bg,
        //appBar: AppBar(
        //  title: Text('Hipstur'),
        //),
        body: Center(
            child: InkWell(
              onTap: () { _callback(); }, // Handle your callback
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  build_login_logo(context),
                  Text(errormsg, style: TextStyle(color:color_errmsg)),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                  ),
                  build_login_buttons(context),
                ],
              ),
            )
        )
    );
  }
