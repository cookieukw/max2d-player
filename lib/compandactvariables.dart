import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'actions.dart';
import 'globalvars.dart';

String? codeisnan = "{mobilegameengine.double.nan}";
String? codeisnull = "{mobilegameengine.text.null}";
String? codeseparator = "{mobilegameengine.separator}";

double? miclevel = 0;

class Xyz {
  double? x, y, z;
}

Xyz accelerometervalue = Xyz();
Xyz gyroscopevalue = Xyz();

int? objectcount = 0;

class Clsgameobjectitem {
  List<Clscomponent> components = [];
  Clsgameobjectitem({this.components});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> thelist = {};
    for (int a = 0; a < components.length; a++) {
      Clscomponent t = components[a];
      if (t is Clscompgameobject) {
        thelist.addAll({"compgameobject": t.toJson()});
      }
      if (t is Clscomptransform) {
        thelist.addAll({"comptransform": t.toJson()});
      }
      if (t is Clscompsprite) {
        thelist.addAll({"compsprite$a": t.toJson()});
      }
      if (t is Clscomprigidbody) {
        thelist.addAll({"comprigidbody$a": t.toJson()});
      }
      if (t is Clscompboxcollider) {
        thelist.addAll({"compboxcollider$a": t.toJson()});
      }
      if (t is Clscompcirclecollider) {
        thelist.addAll({"compcirclecollider$a": t.toJson()});
      }
      if (t is Clscompspriteanimation) {
        thelist.addAll({"comp_spriteanimation$a": t.toJson()});
      }

      if (t is Clscomptext) {
        thelist.addAll({"comptext$a": t.toJson()});
      }
      if (t is Clscomplifebar) {
        thelist.addAll({"complifebar$a": t.toJson()});
      }
      if (t is Clscompscript) {
        thelist.addAll({"compscript$a": t.toJson()});
      }
      if (t is Clscomprevolutejoint) {
        thelist.addAll({"comprevolutejoint$a": t.toJson()});
      }
      if (t is Clscompwheeljoint) {
        thelist.addAll({"compwheeljoint$a": t.toJson()});
      }
    }
    return thelist;
  }

  factory Clsgameobjectitem.fromJson(Map<String, dynamic> json) {
    List<Clscomponent> components2 = [];
    json.forEach((key, value) {
      if (key == "compgameobject") {
        components2.add(Clscompgameobject.fromJson(objectcount, value));
        objectcount++;
      }
      if (key == "comptransform") {
        components2.add(Clscomptransform.fromJson((value)));
      }
      if (key.contains("compsprite")) {
        components2.add(Clscompsprite.fromJson((value)));
      }
      if (key.contains("comprigidbody")) {
        components2.add(Clscomprigidbody.fromJson((value)));
      }
      if (key.contains("compboxcollider")) {
        components2.add(Clscompboxcollider.fromJson((value)));
      }
      if (key.contains("compcirclecollider")) {
        components2.add(Clscompcirclecollider.fromJson((value)));
      }
      if (key.contains("comp_spriteanimation")) {
        components2.add(Clscompspriteanimation.fromJson((value)));
      }
      if (key.contains("comptext")) {
        components2.add(Clscomptext.fromJson(value));
      }
      if (key.contains("complifebar")) {
        components2.add(Clscomplifebar.fromJson(value));
      }
      if (key.contains("compscript")) {
        components2.add(Clscompscript.fromJson(value));
      }
      if (key.contains("comprevolutejoint")) {
        components2.add(Clscomprevolutejoint.fromJson(value));
      }
      if (key.contains("compwheeljoint")) {
        components2.add(Clscompwheeljoint.fromJson(value));
      }
    });

    return Clsgameobjectitem(components: components2);
  }

  void setsprite(Map tvalue) {
    bool? isnaa = false;
    for (int a = 0; a < components.length; a++) {
      Clscomponent t = components[a];
      if (t is Clscompsprite) {
        components.remove(t);
        components.insert(a, Clscompsprite.fromJson(tvalue));
        isnaa = true;
      }
    }
    if (isnaa == false) {
      components.add(Clscompsprite.fromJson(tvalue));
    }
  }

  Clscompsprite getsprite({bool isnullvalues = false}) {
    Clscompsprite gameobject;
    if (isnullvalues == false) {
      for (int a = 0; a < components.length; a++) {
        if (components[a] is Clscompsprite) {
          gameobject = components[a];
        }
      }
    }
    if (isnullvalues) {
      for (int a = 0; a < components.length; a++) {
        if (components[a] is Clscompsprite) {
          gameobject = components[a];
          if (gameobject.spriteanimation == null) {
            if (gameobject.imagepath == null) {
              return null;
            }
          }
        }
      }
    }
    if (gameobject != null) {
      if (gameobject.imagepath != null) {
        File f = File(imagespath + gameobject.imagepath);
        // print(f.path);
        if (!f.existsSync()) {
          gameobject.imagepath = "noimage";
        }
      }
    }

    return gameobject;
  }

  Clscompscript getscript() {
    Clscompscript gameobject;
    for (int a = 0; a < components.length; a++) {
      if (components[a] is Clscompscript) {
        gameobject = components[a];
      }
    }
    return gameobject;
  }

  void setscript(Map tvalue) {
    bool? isnaa = false;
    for (int a = 0; a < components.length; a++) {
      Clscomponent t = components[a];
      if (t is Clscompscript) {
        components.remove(t);
        components.insert(a, Clscompscript.fromJson(tvalue));

        isnaa = true;
      }
    }
    if (isnaa == false) {
      components.add(Clscompscript.fromJson(tvalue));
    }
  }

  Clscomptext gettext() {
    Clscomptext gameobject;
    for (int a = 0; a < components.length; a++) {
      if (components[a] is Clscomptext) {
        gameobject = components[a];
      }
    }
    return gameobject;
  }

  Clscomplifebar getlifebar() {
    Clscomplifebar gameobject;
    for (int a = 0; a < components.length; a++) {
      if (components[a] is Clscomplifebar) {
        gameobject = components[a];
      }
    }
    return gameobject;
  }

  String? getspriteanimationimage(String animation) {
    for (int b = 0; b < components.length; b++) {
      Clscomponent t = components[b];
      if (t is Clscompspriteanimation) {
        if (animation == t.variablename) {
          for (int c = 0; c < t.images.length; c++) {
            if (t.images[c] != null) {
              File f = File(imagespath + t.images[c]);
              // print(f.path);
              if (!f.existsSync()) {
                return "noimage";
              }
              return t.images[c];
            }
          }
        }
      }
    }
    return null;
  }

  List<String> getspriteanimationimagelists(String animation) {
    for (int b = 0; b < components.length; b++) {
      Clscomponent t = components[b];
      if (t is Clscompspriteanimation) {
        if (animation == t.variablename) {
          for (int c = 0; c < t.images.length; c++) {
            File f = File(imagespath + t.images[c]);
            if (!f.existsSync()) {
              t.images[c] = "noimage";
            }
          }
          return t.images;
        }
      }
    }
    return null;
  }

  double? getspriteanimationimageinterval(String animation) {
    for (int b = 0; b < components.length; b++) {
      Clscomponent t = components[b];
      if (t is Clscompspriteanimation) {
        if (animation == t.variablename) {
          return t.interval;
        }
      }
    }
    return null;
  }

  void setgameobject({String? name}) {
    for (int a = 0; a < components.length; a++) {
      Clscomponent t = components[a];
      if (t is Clscompgameobject) {
        if (name != null) {
          t.name = name;
        }
      }
    }
  }

  Clscompgameobject getgameobject() {
    Clscompgameobject gameobject;
    for (int a = 0; a < components.length; a++) {
      if (components[a] is Clscompgameobject) {
        gameobject = components[a];
      }
    }
    return gameobject;
  }

  void settransform(
      {double x,
      double? y,
      double? angle,
      @required double sx,
      @required double sy}) {
    for (int a = 0; a < components.length; a++) {
      Clscomponent t = components[a];
      if (t is Clscomptransform) {
        if (x != null) {
          t.x = x;
        }
        if (y != null) {
          t.y = y;
        }

        if (angle != null) {
          t.angle = angle;
        }
        if (sx != null) {
          t.sx = sx;
        }
        if (sy != null) {
          t.sy = sy;
        }
      }
    }
  }

  Clscomptransform gettransform() {
    Clscomptransform transform;
    for (int a = 0; a < components.length; a++) {
      if (components[a] is Clscomptransform) {
        transform = components[a];
      }
    }
    return transform;
  }

  Clscompboxcollider getboxcollider() {
    Clscompboxcollider boxcollider;
    for (int a = 0; a < components.length; a++) {
      if (components[a] is Clscompboxcollider) {
        boxcollider = components[a];
      }
    }
    return boxcollider;
  }

  void setwheeljoint(Map tvalue) {
    bool? isnaa = false;
    for (int a = 0; a < components.length; a++) {
      Clscomponent t = components[a];
      if (t is Clscompwheeljoint) {
        t = Clscompwheeljoint.fromJson(tvalue);

        isnaa = true;
      }
    }
    if (isnaa == false) {
      components.add(Clscompwheeljoint.fromJson(tvalue));
    }
  }

  void setrevolutejoint(Map tvalue) {
    bool? isnaa = false;
    for (int a = 0; a < components.length; a++) {
      Clscomponent t = components[a];
      if (t is Clscomprevolutejoint) {
        t = Clscomprevolutejoint.fromJson(tvalue);

        isnaa = true;
      }
    }
    if (isnaa == false) {
      components.add(Clscomprevolutejoint.fromJson(tvalue));
    }
  }

  void setboxcollider({
    double? posx,
    double? posy,
    double? width,
    double? height,
  }) {
    bool? isnaa = false;
    for (int a = 0; a < components.length; a++) {
      Clscomponent t = components[a];
      if (t is Clscompboxcollider) {
        if (posx != null) {
          t.x = posx;
        }
        if (posy != null) {
          t.y = posy;
        }
        if (width != null) {
          t.w = width;
        }
        if (height != null) {
          t.h = height;
        }
        isnaa = true;
      }
    }
    if (isnaa == false) {
      components.add(Clscompboxcollider(x: posx, y: posy, h: height, w: width));
    }
  }

  void setcirclecollider({
    double? posx,
    double? posy,
    double? radius,
  }) {
    bool? isnaa = false;
    for (int a = 0; a < components.length; a++) {
      Clscomponent t = components[a];
      if (t is Clscompcirclecollider) {
        if (posx != null) {
          t.x = posx;
        }
        if (posy != null) {
          t.y = posy;
        }
        if (radius != null) {
          t.radius = radius;
        }
        isnaa = true;
      }
    }
    if (isnaa == false) {
      components.add(Clscompcirclecollider(x: posx, y: posy, radius: radius));
    }
  }

  void setspriteanimation(
      {List images,
      String? variablename,
      double? interval,
      bool? addifnone = false}) {
    Map<int, dynamic> temp = images.as{};

    List<String> newlist = [];
    temp.forEach((index, value) {
      newlist.add(value);
    });
    bool? isnaa = false;
    for (int a = 0; a < components.length; a++) {
      Clscomponent t = components[a];
      if (t is Clscompspriteanimation) {
        if (images != null) {
          t.images = newlist;
        }
        if (variablename != null) {
          t.variablename = variablename;
        }
        if (interval != null) {
          t.interval = interval;
        }
        isnaa = true;
      }
    }
    if (isnaa == false) {
      components.add(Clscompspriteanimation(
          images: newlist, interval: interval, variablename: variablename));
    }
  }

  String? getlastcollider() {
    String? lastcollider = "";
    for (int a = 0; a < components.length; a++) {
      if (components[a] is Clscompboxcollider) {
        lastcollider = "box";
      }
      if (components[a] is Clscompcirclecollider) {
        lastcollider = "circle";
      }
    }
    return lastcollider;
  }

  Clscompcirclecollider getcirclecollider() {
    Clscompcirclecollider circlecollider;
    for (int a = 0; a < components.length; a++) {
      if (components[a] is Clscompcirclecollider) {
        circlecollider = components[a];
      }
    }
    return circlecollider;
  }

  void settext(Map tvalue) {
    bool? isnaa = false;
    for (int a = 0; a < components.length; a++) {
      Clscomponent t = components[a];
      if (t is Clscomptext) {
        t = Clscomptext.fromJson(tvalue);

        isnaa = true;
      }
    }
    if (isnaa == false) {
      components.add(Clscomptext.fromJson(tvalue));
    }
  }

  void setlifebar(Map tvalue) {
    bool? isnaa = false;
    for (int a = 0; a < components.length; a++) {
      Clscomponent t = components[a];
      if (t is Clscomplifebar) {
        t = Clscomplifebar.fromJson(tvalue);

        isnaa = true;
      }
    }
    if (isnaa == false) {
      components.add(Clscomplifebar.fromJson(tvalue));
    }
  }

  void setrigidbody(Map tvalue) {
    //
    bool? isnaa = false;
    for (int a = 0; a < components.length; a++) {
      Clscomponent t = components[a];
      if (t is Clscomprigidbody) {
        components.removeAt(a);

        components.insert(a, Clscomprigidbody.fromJson(tvalue));

        isnaa = true;
      }
    }
    if (isnaa == false) {
      components.add(Clscomprigidbody.fromJson(tvalue));
    }
  }

  Clscomprigidbody getrigidbody() {
    Clscomprigidbody rigidbody;
    for (int a = 0; a < components.length; a++) {
      if (components[a] is Clscomprigidbody) {
        rigidbody = components[a];
      }
    }
    return rigidbody;
  }
}

class Clscomponent {}

class Clscompgameobject extends Clscomponent {
  String? name;
  String? isactive;
  String? ischild;
  int? priority;
  double? vsoffsetx = 0;
  double? vsoffsety = 0;
  double? vsscale = 0;
  int? theid;
  Clscompgameobject(
      {this.name,
      this.isactive,
      this.theid,
      this.ischild,
      this.priority,
      this.vsoffsetx,
      this.vsoffsety,
      this.vsscale});
  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "isactive": this.isactive,
      "ischild": this.ischild,
      "priority": this.priority,
      "theid": this.theid,
      "vsoffsetx": this.vsoffsetx,
      "vsoffsety": this.vsoffsety,
      "vsscale": this.vsscale
    };
  }

  factory Clscompgameobject.fromJson(
      int? theobjectcount, Map<String, dynamic> json) {
    String? name = json['name'];
    String? isactive = json['isactive'];
    double? vsoffsetx = json['vsoffsetx'];
    double? vsoffsety = json['vsoffsety'];
    double? vsscale = json['vsscale'];
    String? ischild = json['ischild'];
    int? priority = 0;
    if (json['priority'] == null) {
      priority = 0;
    } else {
      priority = json['priority'];
    }
    int? theid;
    if (json['theid'] == null) {
      // print("asdfasfasdfasdf");
      theid = theobjectcount;
    } else {
      theid = json['theid'];
    }

    return Clscompgameobject(
        name: name,
        isactive: isactive,
        vsoffsetx: vsoffsetx,
        vsoffsety: vsoffsety,
        vsscale: vsscale,
        theid: theid,
        priority: priority,
        ischild: ischild);
  }
}

class Clscomptransform extends Clscomponent {
  double? x;
  double? y;

  double? sx;
  double? sy;

  double? angle;

  Clscomptransform(
      {this.x, this.y, this.angle, @required this.sx, @required this.sy});

  Map<String, dynamic> toJson() {
    return {
      "x": this.x,
      "y": this.y,
      "sx": this.sx,
      "sy": this.sy,
      "angle": this.angle,
    };
  }

  Clscomptransform.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'],
        sx = json['sx'],
        sy = json['sy'],
        angle = json['angle'];
}

class Clscomprevolutejoint extends Clscomponent {
  String? object;
  double? mainx;
  double? mainy;

  double? objectx;
  double? objecty;

  Clscomprevolutejoint(
      {this.object, this.mainx, this.mainy, this.objectx, this.objecty});

  Map<String, dynamic> toJson() {
    return {
      "object": this.object,
      "mainx": this.mainx,
      "mainy": this.mainy,
      "objectx": this.objectx,
      "objecty": this.objecty,
    };
  }

  Clscomprevolutejoint.fromJson(Map<String, dynamic> json)
      : object = json['object'],
        mainx = json['mainx'],
        mainy = json['mainy'],
        objectx = json['objectx'],
        objecty = json['objecty'];
}

class Clscompwheeljoint extends Clscomponent {
  String? object;
  double? mainx;
  double? mainy;

  double? objectx;
  double? objecty;
  double? dampingRatio;
  double? frequency;

  Clscompwheeljoint(
      {this.object,
      this.mainx,
      this.mainy,
      this.objectx,
      this.objecty,
      this.dampingRatio,
      this.frequency});

  Map<String, dynamic> toJson() {
    return {
      "object": this.object,
      "mainx": this.mainx,
      "mainy": this.mainy,
      "objectx": this.objectx,
      "objecty": this.objecty,
      "dampingRatio": this.dampingRatio,
      "frequency": this.frequency
    };
  }

  Clscompwheeljoint.fromJson(Map<String, dynamic> json)
      : object = json['object'],
        mainx = json['mainx'],
        mainy = json['mainy'],
        objectx = json['objectx'],
        objecty = json['objecty'],
        dampingRatio = json['dampingRatio'],
        frequency = json['frequency'];
}

class Clscompsprite extends Clscomponent {
  String? imagepath;
  double? w;
  double? h;
  String? spriteanimation;
  double? opacity;
  int? spriteindex;
  Clscompsprite(
      {this.imagepath,
      this.w,
      this.h,
      this.spriteanimation,
      this.opacity = 1,
      this.spriteindex = 0});
  Map<String, dynamic> toJson() {
    return {
      "imagepath": this.imagepath,
      "w": this.w,
      "h": this.h,
      "spriteindex": this.spriteindex,
      "opacity": this.opacity,
      "spriteanimation": this.spriteanimation
    };
  }

  Clscompsprite.fromJson(Map<String, dynamic> json)
      : imagepath = json['imagepath'],
        w = json['w'],
        h = json['h'],
        spriteindex = json['spriteindex'] == null ? 0 : json['spriteindex'],
        opacity = json['opacity'] == null ? 1 : json['opacity'],
        spriteanimation = json['spriteanimation'];
}

class Clscompspriteanimation extends Clscomponent {
  List<String> images;
  double? interval;
  String? variablename;
  Clscompspriteanimation({this.images, this.interval, this.variablename});
  Map<String, dynamic> toJson() {
    return {
      "images": this.images.join(codeseparator),
      "interval": this.interval,
      "variablename": this.variablename
    };
  }

  Clscompspriteanimation.fromJson(Map<String, dynamic> json)
      : images = json['images'].toString().split(codeseparator),
        interval = json['interval'],
        variablename = json['variablename'];
}

class Clscomprigidbody extends Clscomponent {
  double? density;
  double? gravityscale;
  double? friction;
  double? bounciness;
  String? bodytype;
  bool? fixedrotation;
  bool? issensor;
  Clscomprigidbody(
      {this.density,
      this.gravityscale,
      this.friction,
      this.bounciness,
      this.bodytype,
      this.issensor = false,
      this.fixedrotation = false});

  Map<String, dynamic> toJson() {
    return {
      "density": this.density,
      "gravityscale": this.gravityscale,
      "friction": this.friction,
      "bounciness": this.bounciness,
      "bodytype": this.bodytype,
      "issensor": this.issensor,
      "fixedrotation": this.fixedrotation,
    };
  }

  Clscomprigidbody.fromJson(Map<String, dynamic> json)
      : density = json['density'],
        gravityscale = json['gravityscale'],
        friction = json['friction'],
        bounciness = json['bounciness'],
        bodytype = json['bodytype'],
        issensor = json['issensor'],
        fixedrotation = json['fixedrotation'];
}

class Clscompboxcollider extends Clscomponent {
  double? x, y, w, h, angle;
  Clscompboxcollider({this.x, this.y, this.w, this.h, this.angle});

  Map<String, dynamic> toJson() {
    return {
      "x": this.x,
      "y": this.y,
      "w": this.w,
      "h": this.h,
      "angle": this.angle,
    };
  }

  Clscompboxcollider.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'],
        w = json['w'],
        h = json['h'],
        angle = json['angle'];
}

class Clscompcirclecollider extends Clscomponent {
  double? x, y, radius;
  Clscompcirclecollider({this.x, this.y, this.radius});

  Map<String, dynamic> toJson() {
    return {
      "x": this.x,
      "y": this.y,
      "radius": this.radius,
    };
  }

  Clscompcirclecollider.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'],
        radius = json['radius'];
}

class Clscomplifebar extends Clscomponent {
  double? maxvalue;
  double? thevalue;
  int? backgroundcolor;
  int? foregroundcolor;
  double? width;
  double? height;
  double? top;
  double? left;

  String? alignment;

  Clscomplifebar({
    this.maxvalue,
    this.thevalue,
    this.alignment,
    this.top,
    this.left,
    this.width,
    this.height,
    this.backgroundcolor,
    this.foregroundcolor,
  });

  Map<String, dynamic> toJson() {
    return {
      "maxvalue": this.maxvalue,
      "thevalue": this.thevalue,
      "width": this.width,
      "height": this.height,
      "alignment": this.alignment,
      "top": this.top,
      "left": this.left,
      "backgroundcolor": this.backgroundcolor,
      "foregroundcolor": this.foregroundcolor,
    };
  }

  Clscomplifebar.fromJson(Map<String, dynamic> json)
      : maxvalue = json['maxvalue'],
        thevalue = json['thevalue'],
        width = json['width'],
        height = json['height'],
        alignment = json['alignment'],
        top = json['top'],
        left = json['left'],
        backgroundcolor = json['backgroundcolor'],
        foregroundcolor = json['foregroundcolor'];
}

class Clscomptext extends Clscomponent {
  String? text;

  double? width;
  double? height;

  double? blurradius;
  double? fontsize;
  int? textcolor;
  String? fontfamily;

  Clscomptext(
      {this.text,
      this.width,
      this.height,
      this.blurradius,
      this.fontfamily,
      this.fontsize,
      this.textcolor});

  Map<String, dynamic> toJson() {
    return {
      "text": this.text,
      "width": this.width,
      "height": this.height,
      "blurradius": this.blurradius,
      "fontsize": this.fontsize,
      "textcolor": this.textcolor,
      "fontfamily": this.fontfamily
    };
  }

  Clscomptext.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        width = json['width'],
        height = json['height'],
        blurradius = json['blurradius'],
        fontsize = json['fontsize'],
        textcolor = json['textcolor'],
        fontfamily = json['fontfamily'];
}

class Clscompscript extends Clscomponent {
  List<Clsscriptitem> components = [];
  List<Clsvariable> localvariables = [];

  Clscompscript({this.components, this.localvariables});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> thelist = {};
    for (int a = 0; a < localvariables.length; a++) {
      Clsvariable t = localvariables[a];
      if (t is Clsvariableboolean) {
        thelist.addAll({"complocalvariableboolean$a": t.toJson()});
      }
      if (t is Clsvariabletext) {
        thelist.addAll({"complocalvariabletext$a": t.toJson()});
      }
      if (t is Clsvariablenumber) {
        thelist.addAll({"complocalvariablenumber$a": t.toJson()});
      }
    }

    for (int a = 0; a < components.length; a++) {
      Clsscriptitem t = components[a];
      if (t is Clscompscreenontouch) {
        thelist.addAll({"compscreenontouch$a": t.toJson()});
      }
      if (t is Clscompobjectontouch) {
        thelist.addAll({"compobjectontouch$a": t.toJson()});
      }
      if (t is Clscomponjoystick) {
        thelist.addAll({"componjoystick$a": t.toJson()});
      }
      if (t is Clscompadbanner) {
        thelist.addAll({"compadbanner$a": t.toJson()});
      }
      if (t is Clscomponobjectloaded) {
        thelist.addAll({"componobjectloaded$a": t.toJson()});
      }
      if (t is Clscompstep) {
        thelist.addAll({"compstep$a": t.toJson()});
      }
      if (t is Clsactsetvelocity) {
        thelist.addAll({"actsetvelocity$a": t.toJson()});
      }
      if (t is Clsactsettransform) {
        thelist.addAll({"actsettransform$a": t.toJson()});
      }
      if (t is Clsactsetadvertisement) {
        thelist.addAll({"actsetadvertisement$a": t.toJson()});
      }
      if (t is Clsactiscollidingwith) {
        thelist.addAll({"actiscollidingwith$a": t.toJson()});
      }
      if (t is Clsactiscardinal) {
        thelist.addAll({"actiscardinal$a": t.toJson()});
      }
      if (t is Clsacttimerdelayed) {
        thelist.addAll({"acttimerdelayed$a": t.toJson()});
      }
      if (t is Clsacttimerperiodic) {
        thelist.addAll({"acttimerperiodic$a": t.toJson()});
      }
      if (t is Clsactcreateobject) {
        thelist.addAll({"actcreateobject$a": t.toJson()});
      }
      if (t is Clsactfollowobject) {
        thelist.addAll({"actfollowobject$a": t.toJson()});
      }
      if (t is Clsactsettext) {
        thelist.addAll({"actsettext$a": t.toJson()});
      }
      if (t is Clsactsetlifebar) {
        thelist.addAll({"actsetlifebar$a": t.toJson()});
      }
      if (t is Clsactrestartscene) {
        thelist.addAll({"actrestartscene$a": t.toJson()});
      }
      if (t is Clsactloadscene) {
        thelist.addAll({"actloadscene$a": t.toJson()});
      }
      if (t is Clsactsavevalue) {
        thelist.addAll({"actsavevalue$a": t.toJson()});
      }
      if (t is Clsactloadvalue) {
        thelist.addAll({"actloadvalue$a": t.toJson()});
      }
      if (t is Clsactsavestate) {
        thelist.addAll({"actsavestate$a": t.toJson()});
      }
      if (t is Clsactloadstate) {
        thelist.addAll({"actloadstate$a": t.toJson()});
      }
      if (t is Clsactsetvariable) {
        thelist.addAll({"actsetvariable$a": t.toJson()});
      }
      if (t is Clsactsetsound) {
        thelist.addAll({"actsetsound$a": t.toJson()});
      }
      if (t is Clsactsetcamera) {
        thelist.addAll({"actsetcamera$a": t.toJson()});
      }
      if (t is Clsactsetsprite) {
        thelist.addAll({"actsetsprite$a": t.toJson()});
      }
      if (t is Clsactbooleanexpression) {
        thelist.addAll({"actbooleanexpression$a": t.toJson()});
      }
      if (t is Clsactdestroyobject) {
        thelist.addAll({"actdestroyobject$a": t.toJson()});
      }
    }
    return thelist;
  }

  factory Clscompscript.fromJson(Map<String, dynamic> json) {
    List<Clsscriptitem> components2 = [];
    List<Clsvariable> localvariables2 = [];
    json.forEach((key, value) {
      if (key.contains("complocalvariableboolean")) {
        localvariables2.add(Clsvariableboolean.fromJson((value)));
      }
      if (key.contains("complocalvariablenumber")) {
        localvariables2.add(Clsvariablenumber.fromJson((value)));
      }
      if (key.contains("complocalvariabletext")) {
        localvariables2.add(Clsvariabletext.fromJson((value)));
      }

      if (key.contains("compscreenontouch")) {
        components2.add(Clscompscreenontouch.fromJson((value)));
      }
      if (key.contains("compobjectontouch")) {
        components2.add(Clscompobjectontouch.fromJson((value)));
      }
      if (key.contains("componjoystick")) {
        components2.add(Clscomponjoystick.fromJson((value)));
      }
      if (key.contains("compadbanner")) {
        components2.add(Clscompadbanner.fromJson((value)));
      }
      if (key.contains("componobjectloaded")) {
        components2.add(Clscomponobjectloaded.fromJson(value));
      }
      if (key.contains("compstep")) {
        components2.add(Clscompstep.fromJson(value));
      }
      if (key.contains("actsetvelocity")) {
        components2.add(Clsactsetvelocity.fromJson(value));
      }
      if (key.contains("actsettransform")) {
        components2.add(Clsactsettransform.fromJson(value));
      }
      if (key.contains("actsetadvertisement")) {
        components2.add(Clsactsetadvertisement.fromJson(value));
      }
      if (key.contains("actiscollidingwith")) {
        components2.add(Clsactiscollidingwith.fromJson(value));
      }
      if (key.contains("actiscardinal")) {
        components2.add(Clsactiscardinal.fromJson(value));
      }
      if (key.contains("acttimerdelayed")) {
        components2.add(Clsacttimerdelayed.fromJson(value));
      }
      if (key.contains("acttimerperiodic")) {
        components2.add(Clsacttimerperiodic.fromJson(value));
      }
      if (key.contains("actcreateobject")) {
        components2.add(Clsactcreateobject.fromJson(value));
      }
      if (key.contains("actrestartscene")) {
        components2.add(Clsactrestartscene.fromJson(value));
      }
      if (key.contains("actloadscene")) {
        components2.add(Clsactloadscene.fromJson(value));
      }
      if (key.contains("actfollowobject")) {
        components2.add(Clsactfollowobject.fromJson(value));
      }
      if (key.contains("actsettext")) {
        components2.add(Clsactsettext.fromJson(value));
      }
      if (key.contains("actsetlifebar")) {
        components2.add(Clsactsetlifebar.fromJson(value));
      }
      if (key.contains("actsetvariable")) {
        components2.add(Clsactsetvariable.fromJson(value));
      }
      if (key.contains("actsavestate")) {
        components2.add(Clsactsavestate.fromJson(value));
      }
      if (key.contains("actloadstate")) {
        components2.add(Clsactloadstate.fromJson(value));
      }
      if (key.contains("actsavevalue")) {
        components2.add(Clsactsavevalue.fromJson(value));
      }
      if (key.contains("actloadvalue")) {
        components2.add(Clsactloadvalue.fromJson(value));
      }
      if (key.contains("actsetsound")) {
        components2.add(Clsactsetsound.fromJson(value));
      }
      if (key.contains("actsetcamera")) {
        components2.add(Clsactsetcamera.fromJson(value));
      }
      if (key.contains("actsetsprite")) {
        components2.add(Clsactsetsprite.fromJson(value));
      }
      if (key.contains("actbooleanexpression")) {
        components2.add(Clsactbooleanexpression.fromJson(value));
      }
      if (key.contains("actdestroyobject")) {
        components2.add(Clsactdestroyobject.fromJson(value));
      }
    });

    return Clscompscript(
        components: components2, localvariables: localvariables2);
  }
}

class Clsscriptitem {
  dynamic getproperties(String whattoget) {
    Clsscriptitem t = this;

    if (t is Clscompstep) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "isstart") {
        return true;
      }
    }
    if (t is Clscomponobjectloaded) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "isstart") {
        return true;
      }
    }
    if (t is Clsactsetvelocity) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactcreateobject) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactfollowobject) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactsettext) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactsetlifebar) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactsetvariable) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactsetsound) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactsetcamera) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactsetsprite) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactdestroyobject) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactsettransform) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactsetadvertisement) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactsavevalue) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactloadvalue) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactsavestate) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }
    if (t is Clsactloadstate) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      }
    }

    if (t is Clsactrestartscene) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "isend") {
        return true;
      }
    }
    if (t is Clsactloadscene) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "isend") {
        return true;
      }
    }
    if (t is Clsactiscollidingwith) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "iscondition") {
        return true;
      } else if (whattoget == "falseindex") {
        return t.falseindex;
      } else if (whattoget == "trueindex") {
        return t.trueindex;
      }
    }
    if (t is Clsactiscardinal) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "iscondition") {
        return true;
      } else if (whattoget == "falseindex") {
        return t.falseindex;
      } else if (whattoget == "trueindex") {
        return t.trueindex;
      }
    }
    if (t is Clsactbooleanexpression) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "iscondition") {
        return true;
      } else if (whattoget == "falseindex") {
        return t.falseindex;
      } else if (whattoget == "trueindex") {
        return t.trueindex;
      }
    }
    if (t is Clscompscreenontouch) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "isstart") {
        return true;
      }
    }
    if (t is Clscompobjectontouch) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "isstart") {
        return true;
      }
    }
    if (t is Clscomponjoystick) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "isstart") {
        return true;
      }
    }
    if (t is Clsacttimerdelayed) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "isasync") {
        return true;
      } else if (whattoget == "asyncindex") {
        return t.asyncindex;
      }
    }
    if (t is Clsactsavevalue) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "isasync") {
        return true;
      } else if (whattoget == "asyncindex") {
        return t.asyncindex;
      }
    }
    if (t is Clsactloadvalue) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "isasync") {
        return true;
      } else if (whattoget == "asyncindex") {
        return t.asyncindex;
      }
    }
    if (t is Clsactsavestate) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "isasync") {
        return true;
      } else if (whattoget == "asyncindex") {
        return t.asyncindex;
      }
    }

    if (t is Clsactloadstate) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "isasync") {
        return true;
      } else if (whattoget == "asyncindex") {
        return t.asyncindex;
      }
    }
    if (t is Clsacttimerperiodic) {
      if (whattoget == "pos") {
        if (t.vsPosX == null || t.vsPosY == null) {
          return Offset(0, 0);
        }
        return Offset(t.vsPosX, t.vsPosY);
      } else if (whattoget == "childindex") {
        return t.childindex;
      } else if (whattoget == "vswidth") {
        return t.vswidth;
      } else if (whattoget == "isasync") {
        return true;
      } else if (whattoget == "asyncindex") {
        return t.asyncindex;
      }
    }
    if (whattoget == "pos") {
      return Offset(0, 0);
    } else if (whattoget == "childindex") {
      return -1;
    } else if (whattoget == "vswidth") {
      return 0;
    } else if (whattoget == "isstart") {
      return false;
    } else if (whattoget == "iscondition") {
      return false;
    } else if (whattoget == "falseindex") {
      return -1;
    } else if (whattoget == "trueindex") {
      return -1;
    } else if (whattoget == "asyncindex") {
      return -1;
    } else if (whattoget == "isasync") {
      return false;
    } else if (whattoget == "isend") {
      return false;
    }
  }

  Offset getpos() {
    return getproperties("pos");
  }

  double? getvswidth() {
    return getproperties("vswidth");
  }

  bool? getisstart() {
    return getproperties('isstart');
  }

  int? getchildindex() {
    return getproperties("childindex");
  }

  int? getfalseindex() {
    return getproperties("falseindex");
  }

  int? gettrueindex() {
    return getproperties("trueindex");
  }

  int? getasyncindex() {
    return getproperties("asyncindex");
  }

  bool? getiscondition() {
    return getproperties("iscondition");
  }

  bool? getisasync() {
    return getproperties("isasync");
  }

  bool? getisend() {
    return getproperties("isend");
  }

  void setproperties(dynamic value, String whattoset) {
    Clsscriptitem t = this;

    if (t is Clscompstep) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clscomponobjectloaded) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clsactsetvelocity) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clsactcreateobject) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clsactfollowobject) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clsactsetlifebar) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clsactsettext) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clsactsetvariable) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }

    if (t is Clsactdestroyobject) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clsactsetsound) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clsactsetcamera) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clsactsetsprite) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clsactrestartscene) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clsactloadscene) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clsactsettransform) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }

    if (t is Clsactiscollidingwith) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
      if (whattoset == "falseindex") {
        t.falseindex = value;
      }
      if (whattoset == "trueindex") {
        t.trueindex = value;
      }
    }
    if (t is Clsactiscardinal) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
      if (whattoset == "falseindex") {
        t.falseindex = value;
      }
      if (whattoset == "trueindex") {
        t.trueindex = value;
      }
    }
    if (t is Clsactbooleanexpression) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
      if (whattoset == "falseindex") {
        t.falseindex = value;
      }
      if (whattoset == "trueindex") {
        t.trueindex = value;
      }
    }
    if (t is Clscompscreenontouch) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clscompobjectontouch) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clscomponjoystick) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clsactsetadvertisement) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
    }
    if (t is Clsacttimerdelayed) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
      if (whattoset == "asyncindex") {
        t.asyncindex = value;
      }
    }
    if (t is Clsacttimerperiodic) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
      if (whattoset == "asyncindex") {
        t.asyncindex = value;
      }
    }

    if (t is Clsactsavevalue) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
      if (whattoset == "asyncindex") {
        t.asyncindex = value;
      }
    }
    if (t is Clsactloadvalue) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
      if (whattoset == "asyncindex") {
        t.asyncindex = value;
      }
    }
    if (t is Clsactsavestate) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
      if (whattoset == "asyncindex") {
        t.asyncindex = value;
      }
    }
    if (t is Clsactloadstate) {
      if (whattoset == "pos") {
        t.vsPosX = value.dx;
        t.vsPosY = value.dy;
      }
      if (whattoset == "childindex") {
        t.childindex = value;
      }
      if (whattoset == "asyncindex") {
        t.asyncindex = value;
      }
    }
  }

  void setpos(Offset pos) {
    setproperties(pos, "pos");
  }

  void setchildindex(int index) {
    setproperties(index, "childindex");
  }

  void setfalseindex(int index) {
    setproperties(index, "falseindex");
  }

  void settrueindex(int index) {
    setproperties(index, "trueindex");
  }

  void setasyncindex(int index) {
    setproperties(index, "asyncindex");
  }
}

class Clscompadbanner extends Clsscriptitem {
  String? variable;
  String? joystickevent;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 160;

  Clscompadbanner({this.variable, this.joystickevent});

  Map<String, dynamic> toJson() {
    return {
      "variable": this.variable,
      "joystickevent": this.joystickevent,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex
    };
  }

  Clscompadbanner.fromJson(Map<String, dynamic> json)
      : variable = json['variable'],
        joystickevent = json['joystickevent'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clscomponjoystick extends Clsscriptitem {
  String? variable;
  String? joystickevent;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 160;

  Clscomponjoystick({this.variable, this.joystickevent});

  Map<String, dynamic> toJson() {
    return {
      "variable": this.variable,
      "joystickevent": this.joystickevent,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex
    };
  }

  Clscomponjoystick.fromJson(Map<String, dynamic> json)
      : variable = json['variable'],
        joystickevent = json['joystickevent'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clscompobjectontouch extends Clsscriptitem {
  String? touchevent;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 160;
  String? continuous;

  Clscompobjectontouch({this.touchevent});

  Map<String, dynamic> toJson() {
    return {
      "touchevent": this.touchevent,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
      "continuous": this.continuous
    };
  }

  Clscompobjectontouch.fromJson(Map<String, dynamic> json)
      : touchevent = json['touchevent'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'],
        continuous = json['continuous'];
}

class Clscompscreenontouch extends Clsscriptitem {
  String? touchevent;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 150;
  String? continuous;
  String? location;

  Clscompscreenontouch({this.touchevent});

  Map<String, dynamic> toJson() {
    return {
      "touchevent": this.touchevent,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
      "continuous": this.continuous,
      "location": this.location
    };
  }

  Clscompscreenontouch.fromJson(Map<String, dynamic> json)
      : touchevent = json['touchevent'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'],
        continuous = json['continuous'],
        location = json['location'];
}

class Clscomponobjectloaded extends Clsscriptitem {
  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 120;

  Clscomponobjectloaded();

  Map<String, dynamic> toJson() {
    return {
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex
    };
  }

  Clscomponobjectloaded.fromJson(Map<String, dynamic> json)
      : vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clscompstep extends Clsscriptitem {
  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 100;
  Clscompstep();

  Map<String, dynamic> toJson() {
    return {
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex
    };
  }

  Clscompstep.fromJson(Map<String, dynamic> json)
      : vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clsactsetvelocity extends Clsscriptitem {
  double? x;
  double? y;
  double? angular;
  double? anglelimit;
  String? expx;
  String? expy;
  String? expangular;
  String? expanglelimit;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 150;

  Clsactsetvelocity(
      {this.x,
      this.y,
      this.angular,
      this.anglelimit,
      this.expanglelimit,
      this.expangular,
      this.expx,
      this.expy});
  Map<String, dynamic> toJson() {
    return {
      "x": tojsondouble(this.x),
      "y": tojsondouble(this.y),
      "angular": tojsondouble(this.angular),
      "anglelimit": tojsondouble(this.anglelimit),
      "expx": this.expx,
      "expy": this.expy,
      "expangular": this.expangular,
      "expanglelimit": this.expanglelimit,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
    };
  }

  Clsactsetvelocity.fromJson(Map<String, dynamic> json)
      : x = fromjsondouble(json['x']),
        y = fromjsondouble(json['y']),
        angular = fromjsondouble(json['angular']),
        anglelimit = fromjsondouble(json['anglelimit']),
        expx = json['expx'],
        expy = json['expy'],
        expanglelimit = json['expanglelimit'],
        expangular = json['expangular'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clsactsetadvertisement extends Clsscriptitem {
  String? network;
  String? adtype;
  String? action;
  // String expanglelimit;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 150;

  Clsactsetadvertisement({this.network, this.adtype, this.action});
  Map<String, dynamic> toJson() {
    return {
      "network": this.network,
      "adtype": this.adtype,
      "action": this.action,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
    };
  }

  Clsactsetadvertisement.fromJson(Map<String, dynamic> json)
      : network = json['network'],
        adtype = json['adtype'],
        action = json['action'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clsactsettransform extends Clsscriptitem {
  double? x;
  String? expx;
  double? y;
  String? expy;
  double? sx;
  String? expsx;
  double? sy;
  String? expsy;
  double? angle;
  String? expangle;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 150;

  bool? isnew;

  Clsactsettransform({
    this.x = double.nan,
    this.expx,
    this.expsy,
    this.expsx,
    this.expy,
    this.expangle,
    this.y = double.nan,
    this.sx = double.nan,
    this.sy = double.nan,
    this.angle = double.nan,
    // this.isnew
  });

  Map<String, dynamic> toJson() {
    return {
      "x": tojsondouble(this.x),
      "y": tojsondouble(this.y),
      "sx": tojsondouble(this.sx),
      "sy": tojsondouble(this.sy),
      "angle": tojsondouble(this.angle),
      "expx": this.expx,
      "expy": this.expy,
      "expsx": this.expsx,
      "expsy": this.expsy,
      "expangle": this.expangle,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
      // "isnew":this.isnew
    };
  }

  Clsactsettransform.fromJson(Map<String, dynamic> json)
      : x = fromjsondouble(json['x']),
        y = fromjsondouble(json['y']),
        sx = fromjsondouble(json['sx']),
        sy = fromjsondouble(json['sy']),
        angle = fromjsondouble(json['angle']),
        expx = json['expx'],
        expy = json['expy'],
        expsx = json['expsx'],
        expsy = json['expsy'],
        expangle = json['expangle'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        isnew = json['isnew'],
        childindex = json['childindex'];
}

class Clsactiscollidingwith extends Clsscriptitem {
  String? objectname;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  int? trueindex = -1;
  int? falseindex = -1;
  double? vswidth = 150;
  // bool isstart = false;
  Clsactiscollidingwith({this.objectname});
  Map<String, dynamic> toJson() {
    return {
      "objectname": this.objectname,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
      "trueindex": this.trueindex,
      "falseindex": this.falseindex,
    };
  }

  Clsactiscollidingwith.fromJson(Map<String, dynamic> json)
      : objectname = json['objectname'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'],
        trueindex = json['trueindex'],
        falseindex = json['falseindex'];
}

class Clsactiscardinal extends Clsscriptitem {
  double? angle = double.nan;
  String? expangle;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  int? trueindex = -1;
  int? falseindex = -1;
  double? vswidth = 150;
  String? direction;
  Clsactiscardinal({this.angle = double.nan, this.direction});
  Map<String, dynamic> toJson() {
    return {
      "direction": this.direction,
      "angle": tojsondouble(this.angle),
      "expangle": this.expangle,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
      "trueindex": this.trueindex,
      "falseindex": this.falseindex,
    };
  }

  Clsactiscardinal.fromJson(Map<String, dynamic> json)
      : direction = json['direction'],
        angle = fromjsondouble(json['angle']),
        expangle = json['expangle'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'],
        trueindex = json['trueindex'],
        falseindex = json['falseindex'];
}

class Clsacttimerdelayed extends Clsscriptitem {
  double? seconds;

  Timer timer;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  int? asyncindex = -1;
  double? vswidth = 150;
  bool? cancel;
  bool? iscancelled = false;

  Clsacttimerdelayed({this.seconds, this.cancel});

  void start(Function function) {
    if (cancel == true) {
      if (timer != null) {
        timer.cancel();
      }
    }

    timer = Timer(Duration(milliseconds: (seconds * 1000).toInt()), () async {
      if (iscancelled == false) {
        function();
      }
    });
  }

  void stop() {
    if (timer != null) {
      timer.cancel();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "seconds": tojsondouble(this.seconds),
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
      "asyncindex": this.asyncindex,
      "cancel": this.cancel
    };
  }

  Clsacttimerdelayed.fromJson(Map<String, dynamic> json)
      : seconds = fromjsondouble(json['seconds']),
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        cancel = json['cancel'],
        childindex = json['childindex'],
        asyncindex = json['asyncindex'];
}

class Clsacttimerperiodic extends Clsscriptitem {
  double? seconds;

  Timer timer;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  int? asyncindex = -1;
  double? vswidth = 150;
  bool? cancel;
  bool? iscancelled = false;
  Clsacttimerperiodic({this.seconds, this.cancel});

  void start(Function function) {
    if (cancel == true) {
      if (timer != null) {
        timer.cancel();
      }
    }
    timer = Timer.periodic(Duration(milliseconds: (seconds * 1000).toInt()),
        (timer) async {
      if (iscancelled == false) {
        function();
      }
    });
  }

  void stop() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "seconds": tojsondouble(this.seconds),
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
      "asyncindex": this.asyncindex,
      "cancel": this.cancel
    };
  }

  Clsacttimerperiodic.fromJson(Map<String, dynamic> json)
      : seconds = fromjsondouble(json['seconds']),
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'],
        cancel = json['cancel'],
        asyncindex = json['asyncindex'];
}

class Clsactcreateobject extends Clsscriptitem {
  double? x;
  double? y;
  String? expx;
  String? expy;
  String? objectname;
  bool? isrelative;
  double? velx;
  double? vely;
  String? expvelx;
  String? expvely;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 150;
  Clsactcreateobject(
      {this.expx,
      this.expy,
      this.x,
      this.y,
      this.objectname,
      this.isrelative,
      this.velx,
      this.vely,
      this.expvelx,
      this.expvely});
  Map<String, dynamic> toJson() {
    return {
      "x": tojsondouble(this.x),
      "y": tojsondouble(this.y),
      "expx": this.expx,
      "expy": this.expy,
      "velx": tojsondouble(this.velx),
      "vely": tojsondouble(this.vely),
      "expvelx": this.expvelx,
      "expvely": this.expvely,
      "objectname": this.objectname,
      "isrelative": this.isrelative,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
    };
  }

  Clsactcreateobject.fromJson(Map<String, dynamic> json)
      : x = fromjsondouble(json['x']),
        y = fromjsondouble(json['y']),
        expx = json['expx'],
        expy = json['expy'],
        velx = fromjsondouble(json['velx']),
        vely = fromjsondouble(json['vely']),
        expvelx = json['expvelx'],
        expvely = json['expvely'],
        objectname = json['objectname'],
        isrelative = json['isrelative'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clsactfollowobject extends Clsscriptitem {
  String? objectname;
  double? speed;
  String? expspeed;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 150;

  Clsactfollowobject({this.objectname, this.speed, this.expspeed});
  Map<String, dynamic> toJson() {
    return {
      "objectname": this.objectname,
      "speed": tojsondouble(this.speed),
      "expspeed": this.expspeed,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
    };
  }

  Clsactfollowobject.fromJson(Map<String, dynamic> json)
      : objectname = json['objectname'],
        speed = fromjsondouble(json['speed']),
        expspeed = json['expspeed'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

enum Variabletype { text, number, boolean }

class Clsactvariablecomparison extends Clsscriptitem {}

class Clsactdestroyobject extends Clsscriptitem {
  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 120;
  Clsactdestroyobject();
  Map<String, dynamic> toJson() {
    return {
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
    };
  }

  Clsactdestroyobject.fromJson(Map<String, dynamic> json)
      : vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clsactsettext extends Clsscriptitem {
  String? text;
  String? exptext;
  double? width;
  double? height;

  double? blurradius;
  double? fontsize;
  int? textcolor;
  String? fontfamily;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 150;
  Clsactsettext({
    this.text,
    this.exptext,
    this.width,
    this.height,
    this.blurradius,
    this.fontsize,
    this.textcolor,
    this.fontfamily,
  });
  Map<String, dynamic> toJson() {
    return {
      "text": this.text,
      "exptext": this.exptext,
      "width": tojsondouble(this.width),
      "height": tojsondouble(this.height),
      "blurradius": tojsondouble(this.blurradius),
      "fontsize": tojsondouble(this.fontsize),
      "textcolor": this.textcolor,
      "fontfamily": this.fontfamily,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
    };
  }

  Clsactsettext.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        exptext = json['exptext'],
        width = fromjsondouble(json['width']),
        height = fromjsondouble(json['height']),
        blurradius = fromjsondouble(json['blurradius']),
        fontsize = fromjsondouble(json['fontsize']),
        textcolor = json['textcolor'],
        fontfamily = json['fontfamily'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clsactsetlifebar extends Clsscriptitem {
  double? maxvalue;
  double? thevalue;
  int? backgroundcolor;
  int? foregroundcolor;

  String? expmaxvalue;
  String? expthevalue;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 150;
  Clsactsetlifebar({
    this.maxvalue,
    this.thevalue,
    this.expmaxvalue,
    this.expthevalue,
    this.backgroundcolor,
    this.foregroundcolor,
  });
  Map<String, dynamic> toJson() {
    return {
      "maxvalue": tojsondouble(this.maxvalue),
      "thevalue": tojsondouble(this.thevalue),
      "expmaxvalue": this.expmaxvalue,
      "expthevalue": this.expthevalue,
      "backgroundcolor": this.backgroundcolor,
      "foregroundcolor": this.foregroundcolor,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
    };
  }

  Clsactsetlifebar.fromJson(Map<String, dynamic> json)
      : maxvalue = fromjsondouble(json['maxvalue']),
        thevalue = fromjsondouble(json['thevalue']),
        backgroundcolor = json['backgroundcolor'],
        foregroundcolor = json['foregroundcolor'],
        expmaxvalue = json['expmaxvalue'],
        expthevalue = json['expthevalue'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clsactsetvariable extends Clsscriptitem {
  String? variablename;
  double? numbervalue;
  String? textvalue;
  bool? booleanvalue;
  String? expnumbervalue;
  String? scope;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 150;
  Clsactsetvariable(
      {this.variablename,
      this.numbervalue,
      this.textvalue,
      this.scope,
      this.booleanvalue,
      this.expnumbervalue});
  Map<String, dynamic> toJson() {
    return {
      "scope": this.scope,
      "variablename": this.variablename,
      "numbervalue": tojsondouble(this.numbervalue),
      "expnumbervalue": this.expnumbervalue,
      "textvalue": this.textvalue,
      "booleanvalue": this.booleanvalue,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
    };
  }

  Clsactsetvariable.fromJson(Map<String, dynamic> json)
      : variablename = json['variablename'],
        scope = json['scope'],
        numbervalue = fromjsondouble(json['numbervalue']),
        expnumbervalue = json['expnumbervalue'],
        textvalue = json['textvalue'],
        booleanvalue = json['booleanvalue'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clsactsetcamera extends Clsscriptitem {
  // String variablename;
  double? posx;
  double? posy;
  double? scale;
  double? smoothvalue;

  String? expposx;
  String? expposy;
  String? expscale;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 150;
  Clsactsetcamera(
      {this.posx, this.posy, this.scale, this.smoothvalue = double.nan});
  Map<String, dynamic> toJson() {
    return {
      "posx": tojsondouble(this.posx),
      "posy": tojsondouble(this.posy),
      "scale": tojsondouble(this.scale),
      "smoothvalue": tojsondouble(this.smoothvalue),
      "expposx": this.expposx,
      "expposy": this.expposy,
      "expscale": this.expscale,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
    };
  }

  Clsactsetcamera.fromJson(Map<String, dynamic> json)
      : posx = fromjsondouble(json['posx']),
        posy = fromjsondouble(json['posy']),
        scale = fromjsondouble(json['scale']),
        smoothvalue = fromjsondouble(json['smoothvalue']),
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        expposx = json['expposx'],
        expposy = json['expposy'],
        expscale = json['expscale'],
        childindex = json['childindex'];
}

class Clsactsetsprite extends Clsscriptitem {
  String? image;
  String? animation;
  double? opacity = 0;
  String? expopacity = "";

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 150;
  Clsactsetsprite({
    this.image,
    this.animation,
    this.opacity,
  });
  Map<String, dynamic> toJson() {
    return {
      "image": this.image,
      "animation": this.animation,
      "opacity": tojsondouble(this.opacity == null ? 1 : this.opacity),
      "expopacity": this.expopacity,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
    };
  }

  Clsactsetsprite.fromJson(Map<String, dynamic> json)
      : image = json['image'],
        animation = json['animation'],
        opacity = fromjsondouble(json['opacity']),
        expopacity = json['expopacity'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clsactsetsound extends Clsscriptitem {
  String? variablename;
  String? playerstate;
  double? volume;
  String? expvolume;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 150;
  Clsactsetsound(
      {this.variablename, this.playerstate, this.volume, this.expvolume});
  Map<String, dynamic> toJson() {
    return {
      "variablename": this.variablename,
      "playerstate": this.playerstate,
      "volume": tojsondouble(volume),
      "expvolume": this.expvolume,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
    };
  }

  Clsactsetsound.fromJson(Map<String, dynamic> json)
      : variablename = json['variablename'],
        playerstate = json['playerstate'],
        expvolume = json['expvolume'],
        volume = fromjsondouble(json['volume']),
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clsactloadscene extends Clsscriptitem {
  String? scenename;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 150;

  Clsactloadscene({this.scenename});
  Map<String, dynamic> toJson() {
    return {
      "scenename": this.scenename,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
    };
  }

  Clsactloadscene.fromJson(Map<String, dynamic> json)
      : scenename = json['scenename'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clsactrestartscene extends Clsscriptitem {
  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  double? vswidth = 120;

  Clsactrestartscene();
  Map<String, dynamic> toJson() {
    return {
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
    };
  }

  Clsactrestartscene.fromJson(Map<String, dynamic> json)
      : vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'];
}

class Clsactsavevalue extends Clsscriptitem {
  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  int? asyncindex = -1;
  double? vswidth = 150;
  String? filename;
  String? variable;

  Clsactsavevalue();
  Map<String, dynamic> toJson() {
    return {
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
      "filename": this.filename,
      "asyncindex": this.asyncindex,
      "variable": this.variable,
    };
  }

  Clsactsavevalue.fromJson(Map<String, dynamic> json)
      : vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'],
        filename = json['filename'],
        asyncindex = json['asyncindex'],
        variable = json['variable'];
}

class Clsactloadvalue extends Clsscriptitem {
  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  int? asyncindex = -1;
  double? vswidth = 150;
  String? filename;
  String? variable;

  Clsactloadvalue();
  Map<String, dynamic> toJson() {
    return {
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
      "asyncindex": this.asyncindex,
      "filename": this.filename,
      "variable": this.variable,
    };
  }

  Clsactloadvalue.fromJson(Map<String, dynamic> json)
      : vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'],
        asyncindex = json['asyncindex'],
        filename = json['filename'],
        variable = json['variable'];
}

class Clsactsavestate extends Clsscriptitem {
  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  int? asyncindex = -1;
  double? vswidth = 150;
  String? filename;

  Clsactsavestate();
  Map<String, dynamic> toJson() {
    return {
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
      "filename": this.filename,
      "asyncindex": this.asyncindex,
    };
  }

  Clsactsavestate.fromJson(Map<String, dynamic> json)
      : vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'],
        filename = json['filename'],
        asyncindex = json['asyncindex'];
}

class Clsactloadstate extends Clsscriptitem {
  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  int? asyncindex = -1;
  double? vswidth = 150;
  String? filename;
  bool? ignorephysics = false;

  Clsactloadstate();
  Map<String, dynamic> toJson() {
    return {
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
      "asyncindex": this.asyncindex,
      "filename": this.filename,
      "ignorephysics": this.ignorephysics
    };
  }

  Clsactloadstate.fromJson(Map<String, dynamic> json)
      : vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'],
        asyncindex = json['asyncindex'],
        ignorephysics = json['ignorephysics'],
        filename = json['filename'];
}

class Clsactbooleanexpression extends Clsscriptitem {
  String? expexpression;

  double? vsPosX = 0;
  double? vsPosY = 0;
  int? childindex = -1;
  int? trueindex = -1;
  int? falseindex = -1;
  double? vswidth = 150;
  // bool isstart = false;
  Clsactbooleanexpression({this.expexpression});
  Map<String, dynamic> toJson() {
    return {
      "expexpression": this.expexpression,
      "vsPosX": this.vsPosX,
      "vsPosY": this.vsPosY,
      "childindex": this.childindex,
      "trueindex": this.trueindex,
      "falseindex": this.falseindex,
    };
  }

  Clsactbooleanexpression.fromJson(Map<String, dynamic> json)
      : expexpression = json['expexpression'],
        vsPosX = json['vsPosX'],
        vsPosY = json['vsPosY'],
        childindex = json['childindex'],
        trueindex = json['trueindex'],
        falseindex = json['falseindex'];
}

class Clsvariable {}

List<Clsvariable> globalvariables = [];

class Clsvariablenumber extends Clsvariable {
  String? name;
  double? value;
  bool? showdebug;

  Clsvariablenumber({this.name, this.value, this.showdebug = false});
  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "value": this.value,
      "showdebug": this.showdebug
    };
  }

  Clsvariablenumber.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        showdebug = json['showdebug'],
        value = json['value'];
}

class Clsvariabletext extends Clsvariable {
  String? name;
  String? value;
  bool? showdebug;
  Clsvariabletext({this.name, this.value, this.showdebug = false});
  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "showdebug": this.showdebug,
      "value": this.value
    };
  }

  Clsvariabletext.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        showdebug = json['showdebug'],
        value = json['value'];
}

class Clsvariableboolean extends Clsvariable {
  String? name;
  bool? value;
  bool? showdebug;
  Clsvariableboolean({this.name, this.value, this.showdebug = false});
  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "showdebug": this.showdebug,
      "value": this.value
    };
  }

  Clsvariableboolean.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        showdebug = json['showdebug'],
        value = json['value'];
}

class Clscameracomponent {}

class Clscompcameracontroller extends Clscameracomponent {
  String? objecttofollow;
  double? x;
  double? y;
  double? scale;
  double? h;
  double? v;
  int? backgroundcolor;
  Clscompcameracontroller(
      {this.objecttofollow,
      this.x = double.nan,
      this.y = double.nan,
      this.h,
      this.v,
      this.backgroundcolor = 0,
      this.scale = 1});

  Map<String, dynamic> toJson() {
    return {
      "objecttofollow": this.objecttofollow,
      "x": this.x,
      "y": this.y,
      "scale": this.scale,
      "h": this.h,
      "v": this.v,
      "backgroundcolor": this.backgroundcolor
    };
  }

  Clscompcameracontroller.fromJson(Map<String, dynamic> json)
      : objecttofollow = json['objecttofollow'],
        x = json['x'],
        y = json['y'],
        scale = json['scale'],
        h = json['h'],
        v = json['v'],
        backgroundcolor = json['backgroundcolor'];
}

dynamic tojsondouble(double? thenum) {
  if (thenum == null) return null;
  return thenum.isNaN ? codeisnan : thenum;
}

double? fromjsondouble(dynamic thenum) {
  if (thenum == null) return null;
  if (thenum == codeisnan) return double.nan;
  if (thenum is int) return thenum.toDouble();
  if (thenum is String) return double.tryParse(thenum);
  return thenum;
}

Clscompcameracontroller? cameragetcameracontrollercore() {
  for (int b = 0; b < cameracomponentscore.length; b++) {
    Clscameracomponent t = cameracomponentscore[b];
    if (t is Clscompcameracontroller) {
      return t;
    }
  }
  return null;
}

List<Clscameracomponent> cameracomponents = [];

Clscompcameracontroller? cameragetcameracontroller() {
  for (int b = 0; b < cameracomponents.length; b++) {
    Clscameracomponent t = cameracomponents[b];
    if (t is Clscompcameracontroller) {
      return t;
    }
  }
  return null;
}

enum Eevents {
  onjoystickdirectionchanged,
  onscenestart,
  screentouchdown,
  screentouchdowncontinuous,
  screentouchup,
  screentouchmove,
  objecttouchdown,
  objecttouchdowncontinuous,
  objecttouchup,
  objecttouchmove,
  onobjectloaded,
  onobjectdestroyed,
  step
}

List<Clssoundcomponent> soundslists = [];

class Clssoundcomponent {}

class Clscompsound extends Clssoundcomponent {
  String? variablename;
  String? soundpath;
  double? volume;
  String? playertstate;
  bool? isloop;
  AudioPlayer audioPlayer = AudioPlayer();
  void play() {
    if (audioPlayer.state == AudioPlayerState.PLAYING) {
    } else {
      if (volume > 0) {
        audioPlayer.play(soundspath + soundpath, isLocal: true);
        audioPlayer.setVolume(volume);
      }
    }
  }

  void stop() {
    audioPlayer.stop();
  }

  void pause() {
    audioPlayer.pause();
  }

  void setvolume(double volume) {
    this.volume = volume;
    audioPlayer.setVolume(volume);
  }

  Clscompsound(
      {this.variablename,
      this.soundpath,
      this.volume,
      this.playertstate,
      this.isloop});
  Map<String, dynamic> toJson() {
    return {
      "variablename": this.variablename,
      "soundpath": this.soundpath,
      "volume": tojsondouble(this.volume),
      "playertstate": this.playertstate,
      "isloop": this.isloop
    };
  }

  Clscompsound.fromJson(Map<String, dynamic> json)
      : variablename = json['variablename'],
        soundpath = json['soundpath'],
        volume = fromjsondouble(json['volume']),
        playertstate = json['playertstate'],
        isloop = json['isloop'];
}

class Clssettings {}

List<Clssettings> thesettings = [];

Clscompprojectsettings? getprojectsettings() {
  for (int b = 0; b < thesettings.length; b++) {
    Clssettings t = thesettings[b];

    if (t is Clscompprojectsettings) {
      return t;
    }
  }
  return null;
}

Clscompprojectsettings? getprojectsettingscore() {
  for (int b = 0; b < projectsettingscore.length; b++) {
    Clssettings t = projectsettingscore[b];

    if (t is Clscompprojectsettings) {
      return t;
    }
  }
  return null;
}

class Clscompprojectsettings extends Clssettings {
  bool? usingmicrophone;
  bool? usinggyroscope;
  bool? usingaccelerometer;
  String? packagename;
  String? orientation;
  String? projectname;
  String? version;
  String? startingscene;
  String? icon;
  String? playgroundid;
  String? backupid;
  bool? opensource;
  String? repositorylink;
  String? optimization = "smooth";
  String? imagequality = "low";
  int? appversion = 0;
  double? gridspacing = 32;
  String? admobapplicationid = "";
  String? splashtext = "M A D E  W I T H";
  String? splashimage = "Max2D Logo";
  int? splashbackground = Color(0xFF2A2E49).value;

  Clscompprojectsettings(
      {this.usinggyroscope = false,
      this.orientation,
      this.startingscene,
      this.packagename,
      this.projectname,
      this.backupid,
      this.usingmicrophone = false,
      this.usingaccelerometer = false,
      this.version,
      this.icon,
      this.opensource = false,
      this.repositorylink = "",
      this.optimization = "smooth",
      this.imagequality = "low",
      this.appversion = 0,
      this.gridspacing = 32,
      this.admobapplicationid,
      this.splashbackground,
      this.splashimage = "Max2D Logo",
      this.splashtext = "M A D E  W I T H",
      this.playgroundid = ""});
  Map<String, dynamic> toJson() {
    return {
      "usingmicrophone": this.usingmicrophone,
      "usinggyroscope": this.usinggyroscope,
      "usingaccelerometer": this.usingaccelerometer,
      "packagename": this.packagename,
      "startingscene": this.startingscene,
      "projectname": this.projectname,
      "version": this.version,
      "orientation": this.orientation,
      "backupid": this.backupid,
      "icon": this.icon,
      "gridspacing": this.gridspacing,
      "optimization": this.optimization,
      "opensource": this.opensource,
      "appversion": this.appversion,
      "repositorylink": this.repositorylink,
      "playgroundid": this.playgroundid,
      "admobapplicationid": this.admobapplicationid,
      "splashbackground": this.splashbackground,
      "splashtext": this.splashtext,
      "splashimage": this.splashimage,
      "imagequality": this.imagequality,
    };
  }

  Clscompprojectsettings.fromJson(Map<String, dynamic> json)
      : usingmicrophone = json['usingmicrophone'],
        usinggyroscope = json['usinggyroscope'],
        usingaccelerometer = json['usingaccelerometer'],
        packagename = json['packagename'],
        startingscene = json['startingscene'],
        projectname = json['projectname'],
        version = json['version'],
        icon = json['icon'],
        splashbackground = json['splashbackground'] == null
            ? Color(0xFF2A2E49).value
            : json['splashbackground'],
        splashimage = json['splashimage'],
        splashtext = json['splashtext'] == null
            ? "M A D E  W I T H"
            : json['splashtext'],
        backupid = json['backupid'],
        gridspacing = json['gridspacing'] == null ? 8 : json['gridspacing'],
        repositorylink = json['repositorylink'],
        opensource = json['opensource'],
        playgroundid = json['playgroundid'],
        orientation = json['orientation'],
        admobapplicationid = json['admobapplicationid'] == null
            ? ""
            : json['admobapplicationid'],
        appversion = json['appversion'] == null ? 0 : json['appversion'],
        optimization =
            json['optimization'] == null ? "smooth" : json['optimization'],
        imagequality =
            json['imagequality'] == null ? "low" : json['imagequality'];
}

// class Clsworkspacesettings extends Clssettings {
//   bool showgrid;
//   bool aligngrid;
//   double gridvalue;
//   Clsworkspacesettings({this.showgrid, this.aligngrid, this.gridvalue});
//   Map<String, dynamic> toJson() {
//     return {
//       "showgrid": this.showgrid,
//       "aligngrid": this.aligngrid,
//       "gridvalue": this.gridvalue
//     };
//   }

//   Clsworkspacesettings.fromJson(Map<String, dynamic> json)
//       : showgrid = json['showgrid'],
//         aligngrid = json['aligngrid'],
//         gridvalue = json['gridvalue'];
// }

List<Clsuicomponent> uicomponents = [];

class Clsuicomponent {}

class Joystickvalues {
  String? variable;
  double? angle;
  double? distance;
  double? valx;
  double? valy;
  Joystickvalues(
      this.angle, this.distance, this.valx, this.valy, this.variable);
}

class Clsuijoystickdirectional extends Clsuicomponent {
  int? backgroundcolor;
  int? knobcolor;
  double? size;

  double? postop;
  double? posleft;
  double? posright;
  double? posbottom;

  String? variablename;

  Clsuijoystickdirectional(
      {this.size = 100,
      this.posbottom = 50,
      this.posleft = 50,
      this.backgroundcolor = 0x1F000000,
      this.knobcolor = 0x42000000,
      this.posright = double.nan,
      this.postop = double.nan,
      this.variablename = "joystick"});

  Map<String, dynamic> toJson() {
    return {
      "backgroundcolor": this.backgroundcolor,
      "knobcolor": this.knobcolor,
      "size": tojsondouble(this.size),
      "postop": tojsondouble(this.postop),
      "posleft": tojsondouble(this.posleft),
      "posright": tojsondouble(this.posright),
      "posbottom": tojsondouble(this.posbottom),
      "variablename": this.variablename
    };
  }

  Clsuijoystickdirectional.fromJson(Map<String, dynamic> json)
      : backgroundcolor = json['backgroundcolor'],
        knobcolor = json['knobcolor'],
        size = fromjsondouble(json['size']),
        postop = fromjsondouble(json['postop']),
        posright = fromjsondouble(json['posright']),
        posbottom = fromjsondouble(json['posbottom']),
        posleft = fromjsondouble(json['posleft']),
        variablename = json['variablename'];
}

class Clsuiadbanner extends Clsuicomponent {
  String? network;
  String? bannerid;
  String? anchor;
  String? bannersize;

  Clsuiadbanner({
    this.network = "admob",
    this.bannerid,
    this.anchor = "bottom",
    this.bannersize = "banner",
  });

  Map<String, dynamic> toJson() {
    return {
      "network": this.network,
      "bannerid": this.bannerid,
      "anchor": this.anchor,
      "bannersize": this.bannersize
    };
  }

  Clsuiadbanner.fromJson(Map<String, dynamic> json)
      : bannersize = json['bannersize'],
        anchor = json['anchor'],
        bannerid = json['bannerid'] == null ? "" : json['bannerid'],
        network = json['network'];
}

class Buttonvalues {
  String? variable;
  String? event;
  Buttonvalues(this.variable, this.event);
}

class Clsuibutton extends Clsuicomponent {
  String? variablename;
  double? postop;
  double? posleft;
  double? posright;
  double? posbottom;

  double? width;
  double? height;

  double? borderradius;

  int? color;
  String? image;
  String? imagefilltype;

  String? text;

  double? fontsize;
  int? textcolor;
  String? fontfamily;

  bool? isenteredoutside = false;
  bool? istappingdown = false;

  bool? isentering = false;
  double? scale = 1;

  Clsuibutton(
      {this.variablename = "button",
      this.postop = double.nan,
      this.posbottom = double.nan,
      this.posleft = double.nan,
      this.posright = double.nan,
      this.width = 50,
      this.height = 25,
      this.borderradius = 3,
      this.color = 0xFFFFFFFF,
      this.text = "button",
      this.fontsize = 12,
      this.fontfamily = "default",
      // this.image = null,
      this.imagefilltype = "fit",
      this.textcolor = 0xFF000000});
  Map<String, dynamic> toJson() {
    return {
      "variablename": this.variablename,
      "postop": tojsondouble(this.postop),
      "posbottom": tojsondouble(this.posbottom),
      "posleft": tojsondouble(this.posleft),
      "posright": tojsondouble(this.posright),
      "width": tojsondouble(this.width),
      "height": tojsondouble(this.height),
      "borderradius": tojsondouble(this.borderradius),
      "color": this.color,
      "image": this.image,
      "imagefilltype": this.image,
      "text": this.text,
      "fontsize": tojsondouble(this.fontsize),
      "textcolor": this.textcolor,
      "fontfamily": this.fontfamily,
    };
  }

  Clsuibutton.fromJson(Map<String, dynamic> json)
      : this.variablename = json['variablename'],
        this.postop = fromjsondouble(json['postop']),
        this.posbottom = fromjsondouble(json['posbottom']),
        this.posleft = fromjsondouble(json['posleft']),
        this.posright = fromjsondouble(json['posright']),
        this.width = fromjsondouble(json['width']),
        this.height = fromjsondouble(json['height']),
        this.borderradius = fromjsondouble(json['borderradius']),
        this.color = json['color'],
        this.image = json['image'],
        this.imagefilltype = json['imagefilltype'],
        this.text = json['text'],
        this.fontsize = fromjsondouble(json['fontsize']),
        this.textcolor = json['textcolor'],
        this.fontfamily = json['fontfamily'];
}
