import 'dart:math';

import 'package:hipstur/widgets/choice_tab.dart';
import 'package:hipstur/widgets/models.dart';
import 'package:hipstur/widgets/song_title.dart';
import 'package:hipstur/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';


const coverImage =
    "https://cdn-s-www.ledauphine.com/images/C4A2656A-FDD7-40A0-A8F3-414D00B3A519/NW_raw/ariana-grande-en-janvier-2020-photo-frazer-harrison-getty-images-for-the-recording-academy-afp-1621312560.jpg";

const expandedHeight = 240.0;

class UIPage extends StatefulWidget {
  const UIPage({
    Key? key,
  }) : super(key: key);

  @override
  State<UIPage> createState() => _UIPageState();
}

class _UIPageState extends State<UIPage> {
  final _controller = ScrollController();
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(moveOffset);
  }

  moveOffset() {
    setState(() {
      _offset = min(max(0, _controller.offset / 6 - 16), 32);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(moveOffset);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: expandedHeight,
            collapsedHeight: 90,
            stretch: true,
            backgroundColor: Colors.black,
            foregroundColor: Colors.transparent,
            flexibleSpace: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Image.network(
                  coverImage,
                  fit: BoxFit.cover,
                ),
                //expandedTitleScale: 1,
                titlePadding: const EdgeInsets.all(24),
                title: const Title(),
              ),
            ),
          ),
// Used to get the stretch effect to not be above the SliverAppBar
          const SliverToBoxAdapter(),
          SliverAppBar(
            backgroundColor: Colors.black,
            toolbarHeight: _offset + kToolbarHeight,
            title: Column(
              children: [
                SizedBox(height: _offset),
                const ChoiceTab(),
              ],
            ),
            primary: false,
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return SongTile(
                  index: index,
                );
              },
              childCount: listArianaGrandeAlbums.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
            ),
          ),
        ],
      ),
    );
  }
}


Widget build_ui( BuildContext context, void _callback(String msg), String errormsg, bool isplaying ) {
  //return UIPage( msgcallback: _callback );
  //return UIPage();

  FaIcon playicon = FaIcon(FontAwesomeIcons.play, color: Colors.white);
  if( isplaying ){
    playicon = FaIcon(FontAwesomeIcons.pause, color: Colors.white);
  }

  return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
    children: <Widget>[
      Expanded(
        child: UIPage(),
      ),
      //Text('Player'),
      InkWell(
      child: playicon,
      onTap: () {
      //print("Click event on Container");
      _callback("playpause");
      },
      )
    ],
  )
  );
}