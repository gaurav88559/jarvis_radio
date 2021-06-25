// ignore: unused_import
// ignore: avoid_web_libraries_in_flutter

import 'package:ai_radio/model/radio.dart';
import 'package:ai_radio/utils/ai_util.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: unused_import
import 'package:velocity_x/velocity_x.dart'; // velocity x ye flutter ka framework he design ka

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MyRadio> radios;
  MyRadio _selectedRadio;
  // ignore: unused_field
  Color _selectedColor;
  bool _isPlaying = false;

  final sugg = [
    "Play",
    "Stop",
    "Play rock music",
    "Play 107 FM",
    "Play next",
    "Play 104 FM",
    "Pause",
    "Play previous",
    "Play pop music"
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    fetchRadios();

    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == AudioPlayerState.PLAYING) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      setState(() {});
    });
  }

  fetchRadios() async {
    // ignore: unused_local_variable
    final radioJson = await rootBundle.loadString("assets/radio.json");
    // ignore: unused_local_variable
    var radio;
    radios = MyRadioList.fromJson(radioJson).radios;
    print(radios);
    setState(() {});
  }

  // ignore: non_constant_identifier_names
  _PlayMusic(String url) {
    _audioPlayer.play(url);
    _selectedRadio = radios.firstWhere((element) => element.url == url);
    print(_selectedRadio.name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: _selectedColor ?? AIColors.primaryColor2,
          child: radios != null
              ? [
                  100.heightBox,
                  "All Channels".text.xl.white.semiBold.make().px16(),
                  20.heightBox,
                  ListView(
                    padding: Vx.m0,
                    shrinkWrap: true,
                    children: radios
                        .map((e) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(e.icon),
                              ),
                              title: "${e.name} FM".text.white.make(),
                              subtitle: e.tagline.text.white.make(),
                            ))
                        .toList(),
                  ).expand()
                ].vStack(crossAlignment: CrossAxisAlignment.start)
              : const Offstage(),
        ),
      ), // drawer ka kam he side me 3 line side bar lana
      body: Stack(
        //mene ek body banaya usme uski stack banya stack me children class liya
        children: [
          VxAnimatedBox() // vxanimatedbox ne ky kiya ki hum ne use bola bhai tu .size le complete screen aur height
              .size(context.screenWidth, context.screenHeight)
              .withGradient(LinearGradient(colors: [
                // .whithGradint ne muze muze dono colors mix karke de diya jo mene ultils me banaya
                AIColors.primaryColor2,
                _selectedColor ?? AIColors.primaryColor1,
              ], begin: Alignment.topLeft, end: Alignment.bottomRight))
              .make(),
          [
            AppBar(
              // App ne muze App var diya
              title: "J.A.R.V.I.S Radio".text.xl4.bold.white.make().shimmer(
                  //.shimmer ne ky kiya jo hamera jarvis radio hal rah he hena o kiya
                  primaryColor: Vx.blue500,
                  secondaryColor: Vx
                      .white), // then mene app bar ka tile diya jarvis radio hum vilocity x use kar rahe he is liye hum yesa likh sakte he
              backgroundColor: Colors
                  .transparent, //background color is liye transperent karna pada q ki dfaukt app bar color blue hota he aur o apne gridentscolors me match nahi hoga is liye
              elevation:
                  0.0, // jo chiz trasprent kiya he use complete gayab ya transprent karta he
              centerTitle: true, // is ne title ko centre me kiya he
            ).h(80).p16(),
            20.heightBox,
            " WHEN  WORDS  FAIL ❣️ 🥰 ❣️ MUSIC  SPEAKS"
                .text
                .semiBold
                .white
                .make(),
            10.heightBox,
            VxSwiper.builder(
              itemCount: sugg.length,
              // ignore: missing_return
              itemBuilder: (context, index) {},
            )
          ].vStack(), //is .h means height 80 pixle aur p16() means padding
          radios != null
              ? VxSwiper.builder(
                  itemCount: radios.length,
                  aspectRatio: 1.0,
                  enlargeCenterPage: true,
                  onPageChanged: (index) {
                    final colorHex = radios[index].color;
                    _selectedColor = Color(int.tryParse(colorHex));
                    setState(() {});
                  },
                  itemBuilder: (context, index) {
                    final rad = radios[index];
                    return VxBox(
                            child: ZStack(
                      [
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: VxBox(
                                  child: rad.category.text.uppercase.white
                                      .make()
                                      .px16())
                              .height(40)
                              .black
                              .alignCenter
                              .withRounded(value: 10.0)
                              .make(),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: VStack(
                            [
                              rad.name.text.xl3.white.bold.make(),
                              5.heightBox,
                              rad.tagline.text.sm.white.semiBold.make(),
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: [
                              Icon(
                                CupertinoIcons.play_circle,
                                color: Colors.white,
                              ),
                              10.heightBox,
                              "Double tap to play".text.gray300.make()
                            ].vStack())
                      ],
                      clip: Clip.antiAlias,
                    ))
                        .clip(Clip.antiAlias)
                        .bgImage(DecorationImage(
                            image: NetworkImage(rad.image),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken)))
                        .border(color: Colors.black, width: 5.0)
                        .withRounded(value: 60.0)
                        .make()
                        .onInkDoubleTap(() {
                      _PlayMusic(rad.url);
                    }).p16();
                  },
                ).centered()
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: [
              if (_isPlaying)
                "Playing Now - ${_selectedRadio.name}FM".text.makeCentered(),
              Icon(
                _isPlaying
                    ? CupertinoIcons.stop_circle
                    : CupertinoIcons.play_circle,
                color: Colors.white,
                size: 50.0,
              ).onInkTap(() {
                if (_isPlaying) {
                  _audioPlayer.stop();
                } else {
                  _PlayMusic(_selectedRadio.url);
                }
              })
            ].vStack(),
          ).pOnly(bottom: context.percentHeight * 12)
        ],
        fit: StackFit.expand,
        clipBehavior: Clip.antiAlias,
      ),
    ); // ye ek material app ki property hote he jisme hum design kar sakte he
  }
}
