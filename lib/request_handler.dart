import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'defs.dart';



class RequestHandler  {

  final VoidStringCallback msgcallback;
  //const Navbar({required this.msgcallback, Key? key}) : super(key: key);

  //@override
  RequestHandler( this.msgcallback ) {
    print("constructor");
    init();
  }

  @override
  void dispose() {
    print("dispose()");
  }

  Future<void> init() async {
    print("init");
  }

  //

}

