import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'loading.dart';
import 'login.dart';
import 'menu.dart';
import 'systray.dart';

//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:just_audio/just_audio.dart';
import 'package:localstorage/localstorage.dart';


void main() {
  if( UniversalPlatform.isAndroid || UniversalPlatform.isIOS ) {
    WidgetsFlutterBinding.ensureInitialized();
    //MobileAds.instance.initialize();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key: key);


    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Hipstur',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Hipstur'),
      );
    }
  }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  AudioPlayer player = AudioPlayer();
  bool isloading = true;
  bool isloggedin = false;
  String token = "";
  final LocalStorage storage = new LocalStorage('hipstur_data.json');

  _MyHomePageState() {
    if (UniversalPlatform.isWindows || UniversalPlatform.isLinux || UniversalPlatform.isMacOS) {
      SysTray st = SysTray();
    }
  }


  void connectiontest() async{
    /*
    try {
      final result = await InternetAddress.lookup('hipstur.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        //return;
      }
    } on SocketException catch (_) {
      print('not connected');
      return;
    }
    */

    // load page
    try {
      final response = await http.get(Uri.parse("https://hipstur.com/"));
      //print("response code: "+response.statusCode);
      if (response.statusCode == 200) {
        print("connected");
      }
    } catch (e) {
      // Fallback for all errors
      print(e.toString());
    }
  }

  void loadaudio() async{
    //player = AudioPlayer();
    //player.setUrl('https://hipstur.com/test.flac');
    //player.load();
    try {
      //await player.setUrl("https://hipstur.com/test.flac");
    player.setAudioSource(
    AudioSource.uri(Uri.parse(
    "https://hipstur.com/test.flac")),
    preload: false);
      player.load();
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      // Linux/Windows: maps to PlayerErrorCode.index
      print("Error code: ${e.code}");
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web/Linux: a generic message
      // Windows: MediaPlayerError.message
      print("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      print("Connection aborted: ${e.message}");
    } catch (e) {
      // Fallback for all errors
      print(e);
    }
  }

  void init() async{
    //start connection test
    connectiontest();

    //check if we have a token
    var hold = storage.getItem('token') ?? "";
    //print("token: "+ hold);
    if( hold==Null || hold=="" ){
      setState(() {
        isloggedin = false;
        isloading = false;
      });
      return;
    }
    //check if were online
    //see if we need to check immediatly (if it hasnt been checked in a week or so)
    //still trigger a check but dont wait on it
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void login() async{

    try {
      final response = await http.post(
        Uri.parse("https://hipstur.com/api/login"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: "email=demo&pass=demo",
        encoding: Encoding.getByName("utf-8")
      );

      //print("response code: "+response.statusCode);
      if (response.statusCode == 200) {
        print("login response");
        print(response.body);
        Map<String, dynamic> data = jsonDecode(response.body);

        if( data.containsKey("error") ){
          //errormsg
          print("erromsg");
          print( data['error']);
          return;
        }

        //print('Howdy, ${user['name']}!');
        setState(() {
          isloggedin=true;
        });
      } else {
        print("login response code not 200");
        print(response.statusCode);
      }
    } catch (e) {
      // Fallback for all errors
      print(e.toString());
    }
  }

  void login_demo(){
    setState(() {
      token="demo";
      isloggedin=true;
    });
  }

  void login_google(){

  }

  void login_facebook(){

  }

  void login_apple(){

  }

  void logout(){
    //clear everything
    //set state to login
    setState(() {
      storage.clear();
      token="";
      isloggedin=false;
    });
  }

  void _messageCallback(String message){
    print("_messageCallback: "+message);
    if( message=="logout" ){
      logout();
      return;
    }
    if( message=="" ) {
    }
  }

  void _incrementCounter() {
    //player.setUrl('https://hipstur.com/test.flac');
    //player.load();
    player.play();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }



  @override
  Widget build(BuildContext context) {

    if( isloading ){
      return build_loading(context);
    }

    if( !isloggedin ){
      return build_login(context, _messageCallback, "");
    }



    return Scaffold(
      drawer: Menu(),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


