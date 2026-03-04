import 'dart:async';
import 'dart:io';

import 'package:control_pad/control_pad.dart';
// import 'package:draggable_fab/draggable_fab.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:mobilegameengine/gamecore/lib/compandactvariables.dart';

import 'admobads2.dart';
import 'compandactvariables.dart';
import 'gameview.dart';

import 'globalvars.dart';

import 'package:record/record.dart';
import 'dart:math' as math;

import 'package:sensors_plus/sensors_plus.dart';

import 'dart:ui' as ui;

late BuildContext playercontext;
Offset listeneroffset = Offset(0, 0);

class Gameplayer extends StatefulWidget {
  final String currentscene;
  final bool isdebug;
  final bool isplayground;
  final bool isworkspace2;

  Gameplayer(this.currentscene,
      {this.isdebug = false,
      this.isplayground = false,
      this.isworkspace2 = false});
  @override
  _GameplayerState createState() => _GameplayerState();
}

class _GameplayerState extends State<Gameplayer> {
  final _audioRecorder = AudioRecorder();
  StreamSubscription<Uint8List>? listener;

  void start() async {
    if (await _audioRecorder.hasPermission()) {
      final stream = await _audioRecorder.startStream(const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 2,
      ));
      listener = stream.listen((samples) {
        if (samples.isNotEmpty) {
          miclevel = samples.reduce(math.max).toDouble() - 130;
        }
      });
    }
  }

  void stop() async {
    if (listener != null) {
      listener!.cancel();
    }
    await _audioRecorder.stop();
  }

  StreamSubscription? accelerometerEvent;
  StreamSubscription? gyroscopeEvent;
  int splashbackground = Color(0xFF2A2E49).value;
  String splashtext = "M A D E  W I T H";

  bool ismanaprojecsettingsloaded = false;

  Image splashimage = Image.asset("assets/logo.png");
  String splashimagepath = imagespath;

  void loadsplashimage() {
    if (getprojectsettingscore()!.splashimage == null) {
      return;
    }
    if (getprojectsettingscore()!.splashimage == "Max2D Logo") {
      return;
    }
    File imagepath = File(imagespath + getprojectsettingscore()!.splashimage!);

    splashimage = Image.file(imagepath);

    // ImageStream _imageStream;
    // ImageProvider temp = Image.file(imagepath).image;

    // _imageStream = temp.resolve(createLocalImageConfiguration(context));
    // // loadedimages.addAll({path.basename(thepath): noimage});
    // _imageStream.addListener(
    //     new ImageStreamListener((ImageInfo info, bool synchronousCall) {
    //   splashimage = info.image;
    //   // loadedimages.update(path.basename(thepath), (value) => info.image);
    //   // print(info.image);
    // }));
  }

  @override
  void initState() {
    isprojectloaded = false;
    isworkspace = widget.isworkspace2;

    loadprojectsettings().then((onValue) async {
      loadsplashimage();
      ismanaprojecsettingsloaded = true;
      setState(() {});
      var settings = getprojectsettingscore();
      if (settings != null) {
        if (settings.orientation == "portrait") {
          Flame.device.setPortrait();
        } else if (settings.orientation == "landscape") {
          Flame.device.setLandscape();
        }
      }
      if (settings != null && settings.splashbackground != null) {
        // print(splashbackground);
        splashbackground = settings.splashbackground ?? 0xFF2A2E49;
        splashtext = settings.splashtext ?? "M A D E  W I T H";
        // print(splashbackground);
      }
      await theads2.initialize(widget.isdebug);
      loadprojectcore(widget.isplayground
              ? (getprojectsettingscore()?.startingscene ?? "scene1")
              : widget.currentscene)
          .then((onValue) async {
        await loadimagesfromfile(context);

        Future.delayed(
            Duration(milliseconds: widget.isplayground ? 2000 : 1000), () {
          isprojectloaded = true;
          setState(() {});
        });

        if (settings != null && (settings.usingmicrophone == true)) {
          start();
        }
      });
    });

    accelerometerEvent = accelerometerEventStream().listen((AccelerometerEvent event) {
      accelerometervalue.x = event.x;
      accelerometervalue.y = event.y;
      accelerometervalue.z = event.z;
    });

    gyroscopeEvent = gyroscopeEventStream().listen((GyroscopeEvent event) {
      gyroscopevalue.x = event.x;
      gyroscopevalue.y = event.y;
      gyroscopevalue.z = event.z;
    });

    super.initState();
  }

  @override
  void dispose() {
    Flame.device.setLandscape();
    for (int a = 0; a < soundslistscore.length; a++) {
      Clscompsound t = soundslistscore[a] as Clscompsound;
      t.stop();
    }
    var settings = getprojectsettingscore();
    if (settings != null && (settings.usingmicrophone == true)) {
      stop();
    }

    gameobjectitemscore.clear();
    cameracomponentscore.clear();
    globalvariablescore.clear();
    soundslistscore.clear();

    theads2.hideBannerAd();

    accelerometerEvent?.cancel();
    gyroscopeEvent?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!ismanaprojecsettingsloaded) {
      return Container();
    }
    playercontext = context;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (isprojectloaded) {
      gv = Gameview(context, isdebug: widget.isdebug);
    }

    return Scaffold(
      backgroundColor: Color(splashbackground),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: isprojectloaded
                ? Stack(
                    children: [
                      Listener(
                          onPointerDown: (event) {
                            gv.onTouchDown(event);
                          },
                          onPointerUp: (event) {
                            // if (!checkbuttonlocations("up")) {
                            gv.onTouchUp(event);
                            //  }
                          },
                          onPointerMove: (event) {
                            // listeneroffset = event.position;
                            //  if (!checkbuttonlocations("move")) {
                            gv.onTouchMove(event);
                            //   }
                          },
                          onPointerCancel: (event) {},
                          child: GameWidget(game: gv)),
                      TheUIcomponents()
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text(
                          splashtext,
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        Container(width: 100, height: 100, child: splashimage),
                        Spacer(),
                        //
                        Text(
                          "Loading resources...",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        Container(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: widget.isplayground == false
          ? FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 70, 70, 70),
                onPressed: () {
                  for (int a1 = 0; a1 < soundslistscore.length; a1++) {
                    Clscompsound t = soundslistscore[a1] as Clscompsound;
                    t.stop();
                  }
                  Flame.device.setLandscape();
                  var settings = getprojectsettingscore();
                  if (settings != null && settings.orientation == "portrait") {
                    Future.delayed(Duration(milliseconds: 100), () {
                      Navigator.of(context).pop();
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: FaIcon(
                  FontAwesomeIcons.stop,
                  size: 16,
                ),
              )
          : Container(),
    );
  }
}

class TheUIcomponents extends StatefulWidget {
  // final bool isdebug;
  TheUIcomponents();
  @override
  _TheUIcomponentsState createState() => _TheUIcomponentsState();
}

class _TheUIcomponentsState extends State<TheUIcomponents> {
  @override
  void initState() {
    // TODO: implement initState
    refreshuicomponents = () {
      if (mounted) setState(() {});
    };
    theads2.onBannerLoaded = refreshuicomponents;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(uicomponentscore.length);
    return Stack(
        children: List.generate(uicomponentscore.length, (index) {
      Clsuicomponent t = uicomponentscore[index];
      if (t is Clsuijoystickdirectional) {
        return Positioned(
          bottom: (t.posbottom ?? double.nan).isNaN ? null : t.posbottom!,
          left: (t.posleft ?? double.nan).isNaN ? null : t.posleft!,
          right: (t.posright ?? double.nan).isNaN ? null : t.posright!,
          top: (t.postop ?? double.nan).isNaN ? null : t.postop!,
          child: JoystickView(
            backgroundColor: Color(t.backgroundcolor ?? 0xFF000000),
            innerCircleColor: Color(t.knobcolor ?? 0xFF000000),
            size: t.size ?? 100.0,
            showArrows: false,
            interval: Duration(milliseconds: 16),
            onDirectionChanged: (val, val2, x, y) {
              gv.onJoystickDirectionChanged(Joystickvalues(
                  val,
                  val2,
                  x == 0 ? 0 : math.cos(val),
                  y == 0 ? 0 : -math.sin(val),
                  t.variablename));
            },
          ),
        );
      }

      if (t is Clsuibutton) {
        // buttonlisteners.add(t);
        return Positioned(
            bottom: (t.posbottom ?? double.nan).isNaN ? null : t.posbottom!,
            left: (t.posleft ?? double.nan).isNaN ? null : t.posleft!,
            right: (t.posright ?? double.nan).isNaN ? null : t.posright!,
            top: (t.postop ?? double.nan).isNaN ? null : t.postop!,
            child: theuibutton(t));
      }
      if (t is Clsuiadbanner) {
        theads2.anchor = t.anchor ?? "bottom";
        theads2.bannersize = t.bannersize ?? "banner";
        if (t.bannerid != null) {
          if (t.bannerid!.length > 0) {
            // bannerid is final - would need to recreate theads2 to change it
            // theads2.bannerid = t.bannerid!;
          }
        }
        if (getprojectsettingscore()!.admobapplicationid != null) {
          if (getprojectsettingscore()!.admobapplicationid!.length > 0) {
            theads2.appid = getprojectsettingscore()!.admobapplicationid!;
          }
        }
        
        // Render the banner if ready
        return Positioned(
          top: theads2.anchor == "top" ? 0 : null,
          bottom: theads2.anchor == "bottom" ? 0 : null,
          left: 0,
          right: 0,
          child: theads2.getBannerWidget(),
        );
      }

      return Container();
    }));
  }
}

// List<Clsuibutton> buttonlisteners = List();

// bool checkbuttonlocations(String whatevent,int index) {
//   double screenheight = MediaQuery.of(playercontext).size.height;
//   double screenwidth = MediaQuery.of(playercontext).size.width;
//   bool naaynaigo = false;
//   for (int a = 0; a < buttonlisteners.length; a++) {
//     double top = buttonlisteners[a].postop;
//     double bottom = buttonlisteners[a].posbottom;
//     double left = buttonlisteners[a].posleft;
//     double right = buttonlisteners[a].posright;

//     double height = buttonlisteners[a].height;
//     double width = buttonlisteners[a].width;

//     if (top.isNaN) {
//       top = screenheight - bottom - height;
//     }
//     if (left.isNaN) {
//       left = screenwidth - right - width;
//     }
//     bool isnaa = false;
//     if (listeneroffset.dx > left && listeneroffset.dx < left + width) {
//       if (listeneroffset.dy > top && listeneroffset.dy < top + height) {
//         isnaa = true;
//         naaynaigo = true;
//       }
//     }
//     if (isnaa && whatevent != "up") {
//       if (buttonlisteners[a].isentering == false) {
//         buttonlisteners[a].isenteredoutside=true;
//         buttononfocus(buttonlisteners[a]);

//       }
//     } else {
//       if (buttonlisteners[a].isentering == true && buttonlisteners[a].isenteredoutside) {
//         buttononfocusout(buttonlisteners[a]);
//       }
//     }
//   }
//   return naaynaigo;
// }

void buttononfocus(Clsuibutton t) {
  if (t.isentering == false) {
    t.isentering = true;
    t.scale = 1.1;
    refreshuicomponents?.call();
    gv.onButtonEvent(Buttonvalues(t.variablename, "tapdown"));
  }
}

void buttononfocusout(Clsuibutton t) {
  if (t.isentering == true) {
    t.isentering = false;
    t.scale = 1;
    refreshuicomponents?.call();
    gv.onButtonEvent(Buttonvalues(t.variablename, "tapup"));
  }
}

void buttononcancel(Clsuibutton t) {
  if (t.isentering == true) {
    t.isentering = false;
    t.scale = 1;
    refreshuicomponents?.call();
    gv.onButtonEvent(Buttonvalues(t.variablename, "tapcancel"));
  }
}

Widget theuibutton(Clsuibutton t) {
  return Listener(
    onPointerDown: (details) {
      buttononfocus(t);
    },
    onPointerUp: (details) {
      buttononfocusout(t);
    },
    onPointerMove: (details) {
      listeneroffset = details.position;
      double screenheight = MediaQuery.of(playercontext).size.height;
      double screenwidth = MediaQuery.of(playercontext).size.width;

      double top = t.postop ?? double.nan;
      double bottom = t.posbottom ?? double.nan;
      double left = t.posleft ?? double.nan;
      double right = t.posright ?? double.nan;

      double height = t.height ?? 0;
      double width = t.width ?? 0;

      if (top.isNaN) {
        top = screenheight - bottom - height;
      }
      if (left.isNaN) {
        left = screenwidth - right - width;
      }
      bool isnaa = false;
      if (listeneroffset.dx > left && listeneroffset.dx < left + width) {
        if (listeneroffset.dy > top && listeneroffset.dy < top + height) {
          isnaa = true;
        }
      }
      if (isnaa == false) {
        buttononcancel(t);
      }
    },
    child: Transform.scale(
      scale: t.scale ?? 1.0,
      child: Container(
        color: Color(t.color ?? 0xFF000000),
        width: t.width ?? 0,
        height: t.height ?? 0,
      ),
    ),
  );
}
