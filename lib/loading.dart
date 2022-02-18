import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

import 'colors.dart';


Widget build_loading(BuildContext context){
/*
  return MaterialApp(
    title: 'Hipstur',
    home: new Scaffold(
      //Here you can set what ever background color you need.
      backgroundColor: Colors.black,
    ),
  );

 */

  return Scaffold(
      backgroundColor: color_bg,
      //appBar: AppBar(
      //  title: Text('Hipstur'),
      //),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/hipstur.png')
          ],
        ),
      )
  );

}