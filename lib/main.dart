import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'loading.dart';
import 'login.dart';
import 'menu.dart';
import 'systray_system_tray.dart';
//import 'systray_tray_manager.dart';
import 'ui.dart' ;

//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';



Future<void> main() async {
  if( UniversalPlatform.isAndroid || UniversalPlatform.isIOS ) {
    WidgetsFlutterBinding.ensureInitialized();
    //MobileAds.instance.initialize();
  }

  if( UniversalPlatform.isAndroid || UniversalPlatform.isIOS || UniversalPlatform.isWeb ) {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      //androidNotificationIcon: p.joinAll([p.dirname(Platform.resolvedExecutable), 'data/flutter_assets/assets', 'tray.png']),
    );
  }

  runApp(const MyApp());

  if( UniversalPlatform.isLinux ) {
    doWhenWindowReady(() {
      const initialSize = Size(1280, 720);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.title = "Hipstur";
      appWindow.show();
    });
  }
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

  AudioPlayer player = AudioPlayer();
  bool isloading = true;
  bool isloggedin = false;
  bool isplaying = false;
  String token = "";
  List<String> requestqueue = [];
  int requestdelay = 1000;
  final LocalStorage storage = LocalStorage('hipstur_data.json');

  Map<String, String> playlistdata = {};

  _MyHomePageState() {
    if (UniversalPlatform.isWindows || UniversalPlatform.isLinux || UniversalPlatform.isMacOS) {
      print("SysTray");
      final SysTray st = new SysTray( _messageCallback );
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



  void requestadd( url ){
    if( !requestqueue.contains(url) ) {
      requestqueue.add(url);
      requestprocess();
    }
  }
  void requesthandle(){
    //parse
    //update ui
  }

  void requestprocess() async {
    //see if we have requests to process
    if( requestqueue.isEmpty ){
      return;
    }

    //get url
    String url = requestqueue.first;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        //print(url);
        //print("response code: "+response.statusCode);
        //print(response.body);
        //handle response.body;
        if( url=="https://hipstur.com/playlist/demo.txt" ){
          setState(() {
            playlistdata["demo"] = response.body;
          });
        }
        //success so lets process the next one
        requestdelay = 100;
        requestqueue.removeAt(0);
        requestprocess();
        return;
      }
      print("response code: ");
      print( response.statusCode );
    } catch (e) {
      // Fallback for all errors
      print(e.toString());
    }
    //move first to last just in case its a server issue other things can process
    requestqueue.removeAt(0);
    requestqueue.add(url);
    //if failed increase delay up to max
    if( requestdelay < 60000 ){
      if( requestdelay < 1000 ){
        requestdelay = 1000;
      } else {
        requestdelay = (requestdelay * 1.1).round();
      }
    }
    //if still requests in queue
    if( requestqueue.isNotEmpty ) {
      Future.delayed(Duration(milliseconds: requestdelay), () {
        requestprocess();
      });
    }
  }

  void loadplaylistdata( String listid ){
    listid="demo";
    if( !playlistdata.containsKey(listid) ){
      requestadd("https://hipstur.com/playlist/"+listid+".txt");
      return;
    }
  }


  ConcatenatingAudioSource loadplaylist( String listid ){
    //song|album|artists|duration|id
    //imageurl songurl lyricsurl all derived from id
    String? data = "";
    //data=data+"song1\tdemo\tartist\t60\tdemo1\n";
    //data=data+"song2\tdemo\tartist\t60\tdemo2\n";
    //data=data+"song3\tdemo\tartist\t60\tdemo3\n";
    listid="demo";

    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);

    //playlistdata
    if( !playlistdata.containsKey(listid) ){
      requestadd("https://hipstur.com/playlist/"+listid+".txt");
      return playlist;
    }

    data = playlistdata[listid];
    if( data == null ){
      requestadd("https://hipstur.com/playlist/"+listid+".txt");
      return playlist;
    }

    int _nextMediaId = 0;
    LineSplitter.split(data).forEach((line){
      line = line.trim();
      if( line!="" ) {
        //get pieces
        List pieces = line.split("\t");
        //print("pieces length");
        //print(pieces.length);
        if( pieces.length==5 ) {
          print("https://hipstur.com/song/"+pieces[4]+".mp3");
          playlist.add( AudioSource.uri(
            Uri.parse("https://hipstur.com/song/"+pieces[4]+"/1.mp3"),
            tag: MediaItem(
              id: '${_nextMediaId++}',
              album: pieces[1],
              title: pieces[0],
              artUri: Uri.parse("https://hipstur.com/song/"+pieces[4]+"/t.jpg"),
            ),
          ) );
        }
      }
    });

    return playlist;
  }


  void loadaudio() async{
    //player = AudioPlayer();
    //player.setUrl('https://hipstur.com/test.flac');
    //player.load();
    try {

      int _nextMediaId = 0;
      //late AudioPlayer _player;
      /*
      final _playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(
          Uri.parse("https://hipstur.com/test.flac"),
          tag: MediaItem(
            id: '${_nextMediaId++}',
            album: "Science Friday",
            title: "A Salute To Head-Scratching Science",
            artUri: Uri.parse("https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
          ),
        ),
        AudioSource.uri(
          Uri.parse("https://hipstur.com/test.mp3"),
          tag: MediaItem(
            id: '${_nextMediaId++}',
            album: "Science Friday",
            title: "From Cat Rheology To Operatic Incompetence",
            artUri: Uri.parse("https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
          ),
        ),
        AudioSource.uri(
          Uri.parse("https://hipstur.com/test.mp3"),
          tag: MediaItem(
            id: '${_nextMediaId++}',
            album: "Public Domain",
            title: "Nature Sounds",
            artUri: Uri.parse("https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
          ),
        ),
      ]);
       */

      ConcatenatingAudioSource _playlist = loadplaylist( "demo" );
      print("playlist length: ");
      print(_playlist.children.length);
      if( _playlist.children.length<=0 ){
        player.stop();
        return;
      }


      //await player.setUrl("https://hipstur.com/test.flac");
      //player.setAudioSource(AudioSource.uri(Uri.parse("https://hipstur.com/test.mp3")), preload: false);
      //player.setAudioSource(AudioSource.uri(Uri.parse("/home/user/test.mp3")), preload: false);
      player.setAudioSource( _playlist, preload: false);
      player.load();
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      // Linux/Windows: maps to PlayerErrorCode.index
      print("loadaudio error PlayerException");
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

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, webOnlyWindowName:'_self');
    } else {
      throw 'Could not launch $url';
    }
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
      loadplaylistdata( "demo" );
    });
  }

  void login_google(){
    if (UniversalPlatform.isWindows || UniversalPlatform.isLinux || UniversalPlatform.isMacOS) {
      //
    }
    if( UniversalPlatform.isWeb ){
      launchURL("https://hipstur.com/api/login-google");
      return;
    }
  }

  void login_facebook(){

  }

  void login_apple(){

  }

  void logout(){
    //clear everything
    //set state to login
    setState(() {
      //storage.clear();
      storage.setItem("token", "");
      token="";
      isloggedin=false;
    });
  }

  void _messageCallback(String message){
    print("_messageCallback: "+message);
    if( message=="playpause" ){
      setState(() {
        if( isplaying ){
          isplaying = false;
          player.pause();
        } else {
          loadaudio();
          print("player.play");
          player.play();
          isplaying = true;
        }
      });
      return;
    }
    if( message=="next" ){
      return;
    }
    if( message=="previous" ){
      return;
    }
    if( message=="logout" ){
      logout();
      return;
    }
    if( message=="loginbtn:Demo" ) {
      login_demo();
      return;
    }
    if( message=="loginbtn:Google" ) {
      login_google();
      return;
    }

    if( message=="systray:exit" ) {
      //SystemNavigator.pop();
      exit(0);
      return;
    }
  }



  @override
  Widget build(BuildContext context) {

    if( isloading ){
      return build_loading(context);
    }

    if( !isloggedin ){
      return build_login(context, _messageCallback, "");
    }

    return build_ui(context, _messageCallback, "", isplaying);
  }
}


