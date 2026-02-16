import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'compandactvariables.dart';
import 'dart:convert';

import 'gameview.dart';
import 'package:path/path.dart' as path;

String imagespath = "";
String soundspath = "";
String scenespath = "";
String variablespath = "";
String statespath = "";
String projpathcore = "";
String currentscenecore = "scene1";

String physicalmemory = "";
String virtualmemory = "";
bool isInteger(num value) => (value % 1) == 0;
List<Clsgameobjectitem> gameobjectitemscore = [];
List<Clscameracomponent> cameracomponentscore = [];
List<Clssettings> projectsettingscore = [];
List<Clsvariable> globalvariablescore = [];
List<Clssoundcomponent> soundslistscore = [];
List<Clsuicomponent> uicomponentscore = [];

Function? refreshuicomponents;

Map<String, ui.Image> loadedimages = Map();
bool isprojectloaded = false;
late ui.Image noimage;

bool isdefloaded = false;
bool gameisdebug = false;
bool isworkspace = false;

late Gameview gv;

Future loadimagesfromfile(BuildContext context) async {
  if (isdefloaded == false) {
    initdefimage(context);
    return;
  }
  List<FileSystemEntity> theimages = Directory(imagespath).listSync();
  for (int a = theimages.length - 1; a >= 0; a--) {
    if (!path.basename(theimages[a].path).endsWith(".png") &&
        !path.basename(theimages[a].path).endsWith(".jpeg") &&
        !path.basename(theimages[a].path).endsWith(".jpg")) {
      theimages.removeAt(a);
    }
  }

  ImageStream _imageStream;
  loadedimages.clear();
  loadedimages.addAll({"noimage": noimage});
  for (int a = 0; a < theimages.length; a++) {
    String thepath = theimages[a].path;

    File imagepath = File(thepath);

    ImageProvider temp = Image.file(imagepath).image;

    _imageStream = temp.resolve(createLocalImageConfiguration(context));
    loadedimages.addAll({path.basename(thepath): noimage});
    _imageStream.addListener(
        new ImageStreamListener((ImageInfo info, bool synchronousCall) {
      loadedimages.update(path.basename(thepath), (value) => info.image);
      // print(info.image);
    }));
  }
}

void initdefimage(BuildContext context) {
  ImageStream _imageStream;
  ImageProvider temp = Image.asset("assets/defimage.png").image;

  _imageStream = temp.resolve(createLocalImageConfiguration(context));

  _imageStream.addListener(
      new ImageStreamListener((ImageInfo info, bool synchronousCall) {
    noimage = info.image;
    isdefloaded = true;
    loadimagesfromfile(context);
  }));
}

class Spriteanimation {
  int currentindex = 0;
  double counter = 0;
  String id = "";
  double frameinterval = 0;
  double? interval = 0;
  List<String> images = [];

  Spriteanimation({required this.id, required this.images, required this.interval}) {
    frameinterval = (60 * interval!) / this.images.length;
  }

  void loadimages() async {}
  String getcurrentimagepath() {
    return images[currentindex];
  }

  void update(double t) {
    counter = counter + 1 + 1 * t;
    if (counter > frameinterval) {
      counter = 0;

      currentindex++;

      if (currentindex == images.length) {
        currentindex = 0;
      }
    }
  }
}

bool checkvariableduplicate(List<dynamic> whatglobalvariable,
    String variablename, Clsvariable currentvariable) {
  for (int a = 0; a < whatglobalvariable.length; a++) {
    Clsvariable t = whatglobalvariable[a];
    if (currentvariable != t) {
      if (t is Clsvariabletext) {
        if (t.name == variablename) {
          return true;
        }
      }
      if (t is Clsvariablenumber) {
        if (t.name == variablename) {
          return true;
        }
      }
      if (t is Clsvariableboolean) {
        if (t.name == variablename) {
          return true;
        }
      }
    }
  }
  return false;
}

bool checkvariableduplicatelocal(List<dynamic> whatglobalvariable,
    String variablename, Clsvariable currentvariable) {
  for (int a = 0; a < whatglobalvariable.length; a++) {
    Clsvariable t = whatglobalvariable[a];
    if (currentvariable != t) {
      if (t is Clsvariabletext) {
        if (t.name == variablename) {
          return true;
        }
      }
      if (t is Clsvariablenumber) {
        if (t.name == variablename) {
          return true;
        }
      }
      if (t is Clsvariableboolean) {
        if (t.name == variablename) {
          return true;
        }
      }
    }
  }
  return false;
}

Future loadprojectcore(String scenename) async {
  currentscenecore = scenename;
  // print(projpath);
  File file = File(projpathcore + "/scenes/" + scenename + ".mobilegameengine");

  String contents = await file.readAsString();
  Map<String, dynamic> tojson = json.decode(contents);
  gameobjectitemscore.clear();
  cameracomponentscore.clear();
  globalvariablescore.clear();
  soundslistscore.clear();
  uicomponentscore.clear();

  tojson.forEach((key, value) {
    if (key.contains('gameobjectitem')) {
      gameobjectitemscore.add(Clsgameobjectitem.fromJson(value));
    }
    if (key.contains('cameracomponentscontroller')) {
      cameracomponentscore.add(Clscompcameracontroller.fromJson(value));
    }
    if (key.contains('globalvariabletext')) {
      globalvariablescore.add(Clsvariabletext.fromJson(value));
    }
    if (key.contains('globalvariablenumber')) {
      globalvariablescore.add(Clsvariablenumber.fromJson(value));
    }
    if (key.contains('globalvariableboolean')) {
      globalvariablescore.add(Clsvariableboolean.fromJson(value));
    }
    if (key.contains('soundcomponent')) {
      Clscompsound t = Clscompsound.fromJson(value);
      soundslistscore.add(t);
      if (t.playertstate == "playing") {
        t.play();
      }
    }
    if (key.contains('uijoystickdirectional')) {
      uicomponentscore.add(Clsuijoystickdirectional.fromJson(value));
    }
    if (key.contains('uiadbanner')) {
      uicomponentscore.add(Clsuiadbanner.fromJson(value));
    }
  });

  Directory asdf = Directory(projpathcore + "/tempvariables");

  if (!asdf.existsSync()) {
    asdf.createSync();
  }

  variablespath = asdf.path;

  Directory asdf2 = Directory(projpathcore + "/tempstates");

  if (!asdf2.existsSync()) {
    asdf2.createSync();
  }
  statespath = asdf2.path;
}

Future loadprojectsettings() async {
  projectsettingscore.clear();

  File fileprojectsettings =
      File(projpathcore + "/projectsettings.mobilegameengine");

  String contents2 = await fileprojectsettings.readAsString();

  Map<String, dynamic> tojson2 = json.decode(contents2);

  tojson2.forEach((key, value) {
    if (key.contains('projectsettings')) {
      projectsettingscore.add(Clscompprojectsettings.fromJson(value));
    }
  });
}

Future loadprojectcore2(String scenename) async {
  currentscenecore = scenename;
  // print(currentscenecore);
  File file = File(projpathcore + "/scenes/" + scenename + ".mobilegameengine");

  String contents = await file.readAsString();

  for (int a1 = 0; a1 < soundslistscore.length; a1++) {
    var t = soundslistscore[a1];
    if (t is Clscompsound) {
      t.stop();
    }
  }

  Map<String, dynamic> tojson = json.decode(contents);
  gameobjectitemscore.clear();
  cameracomponentscore.clear();
  globalvariablescore.clear();
  soundslistscore.clear();
  uicomponentscore.clear();

  tojson.forEach((key, value) {
    if (key.contains('gameobjectitem')) {
      gameobjectitemscore.add(Clsgameobjectitem.fromJson(value));
    }
    if (key.contains('cameracomponentscontroller')) {
      cameracomponentscore.add(Clscompcameracontroller.fromJson(value));
    }
    if (key.contains('globalvariabletext')) {
      globalvariablescore.add(Clsvariabletext.fromJson(value));
    }
    if (key.contains('globalvariablenumber')) {
      globalvariablescore.add(Clsvariablenumber.fromJson(value));
    }
    if (key.contains('globalvariableboolean')) {
      globalvariablescore.add(Clsvariableboolean.fromJson(value));
    }
    if (key.contains('soundcomponent')) {
      Clscompsound t = Clscompsound.fromJson(value);
      soundslistscore.add(t);
      if (t.playertstate == "playing") {
        t.play();
      }
    }
    if (key.contains('uijoystickdirectional')) {
      uicomponentscore.add(Clsuijoystickdirectional.fromJson(value));
    }
    if (key.contains('uiadbanner')) {
      uicomponentscore.add(Clsuiadbanner.fromJson(value));
    }
  });

  projectsettingscore.clear();

  File fileprojectsettings =
      File(projpathcore + "/projectsettings.mobilegameengine");

  String contents2 = await fileprojectsettings.readAsString();

  Map<String, dynamic> tojson2 = json.decode(contents2);

  tojson2.forEach((key, value) {
    if (key.contains('projectsettings')) {
      projectsettingscore.add(Clscompprojectsettings.fromJson(value));
    }
  });
}

void expressionmathvariables(Map<String, dynamic> context) {
  var temprandom = math.Random();

  context.addAll({
    "math_random": (int number, [int? number2]) {
      if (number2 == null) {
        return temprandom.nextInt(number);
      } else {
        return number + temprandom.nextInt(number2 - number);
      }
    }
  });
  context.addAll({
    "math_cos": (num number) {
      return math.cos(number);
    }
  });
  context.addAll({
    "math_sin": (num number) {
      return math.sin(number);
    }
  });
  context.addAll({
    "math_exp": (num number) {
      return math.exp(number);
    }
  });
  context.addAll({
    "math_sqrt": (num number) {
      return math.sqrt(number);
    }
  });
  context.addAll({
    "math_atan": (num number) {
      return math.atan(number);
    }
  });
  context.addAll({
    "math_atan2": (num number1, num number2) {
      return math.atan2(number1, number2);
    }
  });
  context.addAll({
    "math_max": (num number1, num number2) {
      return math.max(number1, number2);
    }
  });
  context.addAll({
    "math_min": (num number1, num number2) {
      return math.min(number1, number2);
    }
  });
  context.addAll({
    "math_acos": (num number) {
      return math.acos(number);
    }
  });
  context.addAll({
    "math_asin": (num number) {
      return math.asin(number);
    }
  });
  context.addAll({
    "math_tan": (num number) {
      return math.tan(number);
    }
  });
  context.addAll({"math_pi": math.pi});
  context.addAll({
    "math_pow": (num number, num exponent) {
      return math.pow(number, exponent);
    }
  });
  context.addAll({
    "math_abs": (num number) {
      return number.abs();
    }
  });
  context.addAll({
    "math_value_limit": (num number1, num number2, num number3) {
      if (number1 < number2) {
        return number2;
      }
      if (number1 > number3) {
        return number3;
      }
      return number1;
    }
  });
  context.addAll({
    "math_round": (num number) {
      return number.round();
    }
  });
  context.addAll({
    "math_lerp": (num number1, num number2, num number3) {
      return ui.lerpDouble(number1, number2, number3.toDouble());
    }
  });
}

bool checkifcardinal(double angle, String cardinal) {
  String thecardinal = getCardinal(angle);
  if (thecardinal == cardinal) {
    return true;
  }
  return false;
}

String getCardinal(double angle) {
  double degrees = angle * 180 / math.pi;

  degrees = degrees + 90;

  if (degrees < 0) {
    degrees = 360 + degrees;
  }

  return (degrees >= 337.5 || degrees <= 22.5)
      ? "N"
      : (degrees >= 22.5 && degrees <= 67.5)
          ? "NE"
          : (degrees >= 67.5 && degrees <= 112.5)
              ? "E"
              : (degrees >= 112.5 && degrees <= 157.5)
                  ? "SE"
                  : (degrees >= 157.5 && degrees <= 202.5)
                      ? "S"
                      : (degrees >= 202.5 && degrees <= 247.5)
                          ? "SW"
                          : (degrees >= 247.5 && degrees <= 292.5)
                              ? "W"
                              : "NW";
}
