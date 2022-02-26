import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';


import 'package:universal_platform/universal_platform.dart';

import 'colors.dart';


//mixin Login on State<MyHomePage> {
//mixin Login <T extends StatefulWidget> on State<T> {


Widget Button(){
  return Padding(
    padding: const EdgeInsets.only(left: 35.0, right: 35),
    child: Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color(0xff4b8dec),
        ),
        height: 60,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sign in',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              radius: 12,
              backgroundColor: Color(0xff80aef3),
              child: FaIcon(
                FontAwesomeIcons.arrowRight,
                color: Colors.white,
                size: 12,

              ),
            )
          ],
        ),
      ),
    ),
  );
}
Container SocialIconsWidget(Widget widget) {
  return Container(
    width: 80,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Color(0xff4165ad),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: widget,
      ),
    ),
  );
}


Container textfieldWidget(BuildContext context, String? name,
    TextEditingController controller, TextInputType textType, bool obscure) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width * 0.75,
    margin: EdgeInsets.only(left: 20, right: 20),
    child: TextField(
        obscureText: obscure,
        autofocus: false,
        cursorColor: Color(0xff505969),
        keyboardType: textType,
        controller: controller,
        style: TextStyle(color: Colors.white,fontSize: 20),
        decoration: InputDecoration(

          filled: true,
          fillColor: Colors.transparent,
          labelText: name,
          hintText: name,
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
          labelStyle: TextStyle(fontSize: 15, color: Colors.grey),
          focusColor: Colors.grey[500],
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
        )),
  );
}





class Navbar extends StatefulWidget {
  const Navbar({ Key? key }) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar>
    with SingleTickerProviderStateMixin {

  var LoginemailIDController = TextEditingController();
  var LoginpasswordController = TextEditingController();
  var RegisteremailIDController = TextEditingController();
  var RegisterpasswordController = TextEditingController();
  var RegisternameController = TextEditingController();
  bool checkbox = false;

  Color ScreenColor =Color(0xff444b5d);
  Color selectedColor =Color(0xff343b4d);

  Color widgetColor =Color(0xff505969);

  final List<Tab> tabs = <Tab>[
    new Tab(text: "Login"),
    new Tab(text: "Register"),

  ];

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }


  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: ScreenColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Image(
                  image: AssetImage("assets/hipstur.png"),
                  height: 200,
                  width: 200,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xff565c6e),),
                  child: TabBar(
                    tabs: tabs,
                    labelStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),

                    unselectedLabelStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    controller: _tabController,

                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Color(0xff343b4d),


                    indicator: const BubbleTabIndicator(
                      indicatorHeight: 35.0,
                      indicatorRadius: 5,
                      indicatorColor: Color(0xff343b4d),
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: widgetColor,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 400,
                  child: TabBarView(
                      controller: _tabController,
                      children:[
                        BuildLogin(context),
                        BuildRegistration(context),
                      ]
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }


  Column BuildRegistration(BuildContext context) {
    return Column(
      children: [
        textfieldWidget(context, 'Name', RegisternameController,
            TextInputType.name, false),
        SizedBox(height: 20),
        textfieldWidget(context, 'Email', RegisteremailIDController,
            TextInputType.emailAddress, false),
        SizedBox(height: 20),
        textfieldWidget(context, 'Password', RegisterpasswordController,
            TextInputType.visiblePassword, true),
        SizedBox(
          height: 15,
        ),
        Button(),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Expanded(
              child: Divider(
                height: 1,
                thickness: 1,
                color: widgetColor,
                indent: 25,
                endIndent: 10,
              ),
            ),
            Text( "Sign in via",
                style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                    fontSize: 15)),
            Expanded(
              child: Divider(
                height: 1,
                thickness: 1,
                indent: 10,
                color: widgetColor,
                endIndent: 25,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SocialIconsWidget(FaIcon(FontAwesomeIcons.apple, color: Colors.white),),
              SocialIconsWidget(FaIcon(FontAwesomeIcons.google, color: Colors.white)),
              SocialIconsWidget(FaIcon(FontAwesomeIcons.facebook, color: Colors.white),),
              SocialIconsWidget(FaIcon(FontAwesomeIcons.vk, color: Colors.white)),

/*
              Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Colors.blue[900],
                    border: Border.all(color: Colors.grey)),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset("images/g.png",height: 20,width: 20,)
                ),
              )
                */
            ],
          ),
        ),
        SizedBox(height: 20,)

      ],
    );
  }



  Column BuildLogin(BuildContext context) {
    return Column(
      children: [
        textfieldWidget(context, 'Email', LoginemailIDController,
            TextInputType.emailAddress, false),
        SizedBox(height: 20),
        textfieldWidget(context, 'Password', LoginpasswordController,
            TextInputType.visiblePassword, true),
        // SizedBox(height: 1),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Theme(
                    data: ThemeData(
                        unselectedWidgetColor: widgetColor
                    ),
                    child: Transform.scale(scale: 1.25 ,
                      child: Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),

                          ),
                          focusColor:widgetColor,
                          activeColor: widgetColor,
                          hoverColor: widgetColor,
                          value: checkbox,
                          onChanged: (value) {
                            setState(() {
                              checkbox = value!;
                            });
                          }),
                    ),
                  ),
                  Text(
                    "Remember Me",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ],
              ),
              // SizedBox(width:02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  SizedBox(width: 25),
                  Text(
                    "Forgot Your Password?",
                    style: TextStyle(
                        color: Color(0xff3289eb),
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  )
                ],
              ),

            ],
          ),
        ),


        SizedBox(
          height: 15,
        ),
        Button(),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Expanded(
              child: Divider(
                height: 1,
                thickness: 1,
                color: widgetColor,
                indent: 25,
                endIndent: 10,
              ),
            ),
            Text( "Sign in via",
                style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                    fontSize: 15)),
            Expanded(
              child: Divider(
                height: 1,
                thickness: 1,
                indent: 10,
                color: widgetColor,
                endIndent: 25,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SocialIconsWidget(FaIcon(FontAwesomeIcons.apple, color: Colors.white),),
              SocialIconsWidget(FaIcon(FontAwesomeIcons.google, color: Colors.white)),
              SocialIconsWidget(FaIcon(FontAwesomeIcons.facebook, color: Colors.white),),
              SocialIconsWidget(FaIcon(FontAwesomeIcons.vk, color: Colors.white)),
/*
              Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Colors.blue[900],
                    border: Border.all(color: Colors.grey)),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset("images/g.png",height: 20,width: 20,)
                ),
              )

 */
            ],
          ),
        ),
        SizedBox(height: 20,),


      ],
    );
  }


}





















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
    return Navbar();
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
