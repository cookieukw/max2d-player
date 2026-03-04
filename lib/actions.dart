import 'dart:io';

import 'package:expressions/expressions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart' hide Vector2, World;
import 'package:flame/game.dart' hide Vector2;

import 'package:flutter/material.dart';
// import 'package:mobilegameengine/gamecore/lib/globalvars.dart';
// import 'package:mobilegameengine/gamecore/lib/compandactvariables.dart';

import 'admobads2.dart';
import 'compandactvariables.dart';
import 'globalvars.dart';
// import 'package:box2d_flame/box2d.dart'; // Exported by flame_forge2d
import 'package:vector_math/vector_math_64.dart' as v_math hide Vector2;
import 'package:vector_math/vector_math.dart' as v32;

import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:math' as math;

bool isbanneradshowing = false;

Actionsinitiator actionsinitiator = Actionsinitiator();
BComponent? bComponent;

Size screensize = Size(0, 0);

Vector2 touchmovelocation = Vector2(0, 0);
Vector2 touchdownlocation = Vector2(0, 0);
Vector2 touchuplocation = Vector2(0, 0);
Offset touchdownlocationphysical = Offset(0, 0);
Offset touchmovelocationphysical = Offset(0, 0);
Offset touchuplocationphysical = Offset(0, 0);

MyContactListener? contactListener;
double deltatime = 0.0;

Map<String, dynamic> uijoystickvalues = Map();

class Cameraproperties {
  double x = 0;
  double y = 0;
  double scale = 0;
  Cameraproperties(x, y, scale);
}

late Cameraproperties currentcamerasettings;

class MyContactListener extends ContactListener {
  //Box2d Object collision detection listener
  // List<Gameobject> bodies = List();
  MyContactListener();
  // Map<String, dynamic> contactlist = Map();
  List<Contact> contactlists2 = [];
  @override
  void beginContact(Contact contact) {
    //when object collision detected then add to lists contactlists2
    contactlists2.add(contact);
    // print(contact.fixtureA.userData.toString()    + "           " + contact.fixtureB.userData.toString());
    // print();
  }

  bool iscolliding(String object1, String object2, Gameobject thegameobject) {
    //check if object1 and object2 is colliding. goindex is gameobject index used for unique id if gameobjects have the same name
    for (int a = 0; a < contactlists2.length; a++) {
      Map<String, dynamic> userdataA = contactlists2[a].fixtureA.userData as Map<String, dynamic>;
      Map<String, dynamic> userdataB = contactlists2[a].fixtureB.userData as Map<String, dynamic>;

      if (object1 == userdataA['objectname'] &&
          thegameobject.bodyindex == userdataA['bodyindex']) {
        if (object2 == userdataB['objectname']) {
          return true;
        }
      }
      if (object1 == userdataB['objectname'] &&
          thegameobject.bodyindex == userdataB['bodyindex']) {
        if (object2 == userdataA['objectname']) {
          return true;
        }
      }
    }

    return false;
  }

  bool isnaa(String object, Gameobject thegameobject) {
    for (int a = 0; a < contactlists2.length; a++) {
      Map<String, dynamic> userdataA = contactlists2[a].fixtureA.userData as Map<String, dynamic>;
      Map<String, dynamic> userdataB = contactlists2[a].fixtureB.userData as Map<String, dynamic>;
      if (object == userdataA['objectname'] &&
          thegameobject.bodyindex == userdataA['bodyindex']) {
        return true;
      }

      if (object == userdataB['objectname'] &&
          thegameobject.bodyindex == userdataB['bodyindex']) {
        return true;
      }
    }
    return false;
  }

  @override
  void endContact(Contact contact) {
    contactlists2.remove(
        contact); //when objects end colliding then remove from contactlists
  }

  @override
  void postSolve(Contact contact, ContactImpulse impulse) {}

  @override
  void preSolve(Contact contact, Manifold oldManifold) {}
}

class Actionsinitiator {
  final Forge2DWorld? world;
  // final v.Viewport? camera.viewport; // Viewport is in game.camera

  Forge2DGame? box2d; // Using box2d name to minimize churn, but it's the game

  BuildContext? context;

  // List<Gameobject> bodies = List();
  bool isended = false;

  double camerasmoothx = double.nan;
  double camerasmoothy = double.nan;
  double camerasmoothscale = double.nan;

  Actionsinitiator({this.box2d, this.context, this.world}) {}

  void destroytimers() {
    for (int a = 0; a < gameobjectitemscore.length; a++) {
      var script = gameobjectitemscore[a].getscript();
      if (script == null) continue;
      for (int b = 0;
          b < script.components.length;
          b++) {
        Clsscriptitem t = script.components[b];
        if (t is Clsacttimerdelayed) {
          t.stop();
          t.iscancelled = true;
        }
        if (t is Clsacttimerperiodic) {
          t.stop();
          t.iscancelled = true;
        }
      }
    }
  }

  void getchildactions(int scriptindex, String curobjectname, Clsscriptitem si,
      int goindex, Gameobject thegameobject) {
    if (isended) {
      return;
    }

    int childindex = si.getchildindex() ?? -1;
    // print(scriptindex);
    initiateactions4(scriptindex,
        t: si, goindex: goindex, thegameobject: thegameobject);

    if (si is Clsactiscollidingwith) {
      checkiscollidingwith(scriptindex, curobjectname, si.objectname ?? "", si,
          goindex, thegameobject);
    } else if (si is Clsactiscardinal) {
      checkiscardinal(scriptindex, curobjectname, si, goindex, thegameobject);
    } else if (si is Clsactbooleanexpression) {
      checkbooleanexpression(
          scriptindex, curobjectname, si, goindex, thegameobject);
    } else if (si is Clsacttimerdelayed) {
      checkistimerdelayed(
          scriptindex, curobjectname, si, goindex, thegameobject);
    } else if (si is Clsacttimerperiodic) {
      checkistimerperiodic(
          scriptindex, curobjectname, si, goindex, thegameobject);
    } else if (si is Clsactsavevalue) {
      checkissavevalue(scriptindex, curobjectname, si, goindex, thegameobject);
    } else if (si is Clsactloadvalue) {
      checkisloadvalue(scriptindex, curobjectname, si, goindex, thegameobject);
    } else if (si is Clsactsavestate) {
      checkissavestate(scriptindex, curobjectname, si, goindex, thegameobject);
    } else if (si is Clsactloadstate) {
      checkisloadstate(scriptindex, curobjectname, si, goindex, thegameobject);
    }

    if (childindex != -1) {
      var script = gameobjectitemscore[goindex].getscript();
      if (script != null) {
        Clsscriptitem si2 = script.components[childindex];

        getchildactions(childindex, curobjectname, si2, goindex, thegameobject);
      }
    }
  }

  void checkiscollidingwith(
      int scriptindex,
      String curobjectname,
      String objectname,
      Clsscriptitem si,
      int goindex,
      Gameobject thegameobject) {
    int trueindex = si.gettrueindex() ?? -1;
    int falseindex = si.getfalseindex() ?? -1;

    if (trueindex == null && falseindex == null) return;

    bool iscollisiontrue =
        contactListener!.iscolliding(curobjectname, objectname, thegameobject);

    var script = gameobjectitemscore[goindex].getscript();
    if (trueindex != -1 && iscollisiontrue && script != null) {
      Clsscriptitem si2 = script.components[trueindex];

      getchildactions(scriptindex, curobjectname, si2, goindex, thegameobject);
    }
    var script2 = gameobjectitemscore[goindex].getscript();
    if (falseindex != -1 && !iscollisiontrue && script2 != null) {
      Clsscriptitem si2 = script2.components[falseindex];

      getchildactions(scriptindex, curobjectname, si2, goindex, thegameobject);
    }
  }

  void checkiscardinal(int scriptindex, String curobjectname, Clsscriptitem si,
      int goindex, Gameobject thegameobject) {
    int trueindex = si.gettrueindex() ?? -1;
    int falseindex = si.getfalseindex() ?? -1;

    if (trueindex == null && falseindex == null) return;

    if (si is! Clsactiscardinal) return;
    Clsactiscardinal thet = si;

    double theangle = 0;

    if (!thet.angle.isNaN || thet.expangle != null) {
      if (thet.expangle == null) {
        theangle = thet.angle;
      } else {
        double r = evaluateexpression(thet.expangle ?? "", thegameobject);
        theangle = r;
      }
    }

    bool iscardinal = checkifcardinal(theangle, thet.direction ?? "");

    var script = gameobjectitemscore[goindex].getscript();
    if (trueindex != -1 && iscardinal && script != null) {
      Clsscriptitem si2 = script.components[trueindex];

      getchildactions(scriptindex, curobjectname, si2, goindex, thegameobject);
    }
    var script2 = gameobjectitemscore[goindex].getscript();
    if (falseindex != -1 && !iscardinal && script2 != null) {
      Clsscriptitem si2 = script2.components[falseindex];

      getchildactions(scriptindex, curobjectname, si2, goindex, thegameobject);
    }
  }

  void checkbooleanexpression(int scriptindex, String curobjectname,
      Clsscriptitem si, int goindex, Gameobject thegameobject) {
    int trueindex = si.gettrueindex() ?? -1;
    int falseindex = si.getfalseindex() ?? -1;

    if (trueindex == null && falseindex == null) return;
    bool isexpressiontrue = false;
    if (si is Clsactbooleanexpression) {
      if (si.expexpression != null) {
        isexpressiontrue = evaluateexpression(si.expexpression ?? "", thegameobject);
      }
    }
    var script = gameobjectitemscore[goindex].getscript();
    if (trueindex != -1 && isexpressiontrue && script != null) {
      Clsscriptitem si2 = script.components[trueindex];

      getchildactions(scriptindex, curobjectname, si2, goindex, thegameobject);
    }
    var script2 = gameobjectitemscore[goindex].getscript();
    if (falseindex != -1 && !isexpressiontrue && script2 != null) {
      Clsscriptitem si2 = script2.components[falseindex];

      getchildactions(scriptindex, curobjectname, si2, goindex, thegameobject);
    }
  }

  void checkistimerdelayed(int scriptindex, String curobjectname,
      Clsscriptitem si, int goindex, Gameobject thegameobject) {
    int asyncindex = si.getasyncindex() ?? -1;
    var script = gameobjectitemscore[goindex].getscript();
    if (asyncindex != -1 && script != null) {
      Clsscriptitem si2 = script.components[asyncindex];

      if (si is Clsacttimerdelayed) {
        // if (bodyindex < bodies.length) {
        si.start(() {
          getchildactions(
              scriptindex, curobjectname, si2, goindex, thegameobject);
        });
        // }
      }
    }
  }

  void checkistimerperiodic(int scriptindex, String curobjectname,
      Clsscriptitem si, int goindex, Gameobject thegameobject) {
    int asyncindex = si.getasyncindex() ?? -1;
    var script = gameobjectitemscore[goindex].getscript();
    if (asyncindex != -1 && script != null) {
      Clsscriptitem si2 = script.components[asyncindex];

      if (si is Clsacttimerperiodic) {
        si.start(() {
          getchildactions(
              scriptindex, curobjectname, si2, goindex, thegameobject);
        });
      }
    }
  }

  void checkissavevalue(int scriptindex, String curobjectname, Clsscriptitem si,
      int goindex, Gameobject thegameobject) {
    int asyncindex = si.getasyncindex() ?? -1;

    if (si is Clsactsavevalue) {
      String filename = si.filename ?? "";
      String variable = si.variable ?? "";
      if (filename != null) {
        if (variable != null) {
          File variablefile = File(variablespath + "/" + filename);
          // print(variablefile);
          String thevariable = variable;
          Map<String, dynamic> content = Map();
          for (int indvar = 0; indvar < globalvariablescore.length; indvar++) {
            Clsvariable t2 = globalvariablescore[indvar];
            if (t2 is Clsvariablenumber) {
              if (t2.name == thevariable) {
                content = {"type": "number", "value": t2.value};
              }
            }
            if (t2 is Clsvariabletext) {
              if (t2.name == thevariable) {
                content = {"type": "text", "value": t2.value};
              }
            }
            if (t2 is Clsvariableboolean) {
              if (t2.name == thevariable) {
                content = {"type": "boolean", "value": t2.value};
              }
            }
          }

          variablefile.writeAsString(json.encode(content)).then((onValue) {
            var script = gameobjectitemscore[goindex].getscript();
            if (asyncindex != -1 && script != null) {
              Clsscriptitem si2 = script.components[asyncindex];
              getchildactions(
                  scriptindex, curobjectname, si2, goindex, thegameobject);
            }
          });
        }
      }
    }
  }

  void checkissavestate(int scriptindex, String curobjectname, Clsscriptitem si,
      int goindex, Gameobject thegameobject) {
    // print(currentscenecore);
    int asyncindex = si.getasyncindex() ?? -1;

    if (si is Clsactsavestate) {
      String filename = si.filename ?? "";
      // String variable = si.variable;
      // print(filename);
      if (filename != null) {
        File variablefile = File(statespath + "/" + filename);
        // print(variablefile);
        // String thevariable = variable;
        Map<String, dynamic> thejson = Map();

        // for (int a = gameobjectitemscore.length;
        //     a < bComponent!.bodies.length;
        //     a++) {
        //   // thejson.addAll({"gameobjectitem$a": gameobjectitemscore[a].toJson()});
        //   print(bComponent!.bodies[a].anglelimit);
        // }
        // print(bComponent!.bodies.length);
        for (int a = 0; a < bComponent!.bodies.length; a++) {
          // thejson.addAll({"gameobjectitem$a": gameobjectitemscore[a].toJson()});
          Gameobject thet = bComponent!.bodies.values.elementAt(a);
          // print(thet.bodyindex);
          // print(thet.goindex);
          thejson.addAll({
            thet.bodyindex.toString(): {
              "goindex": thet.goindex,
              "bodypos": {
                "x": thet.body.position.x,
                "y": thet.body.position.y,
                "angle": thet.body.angle
              },
              "bodyvelocity": {
                "x": thet.body.linearVelocity.x,
                "y": thet.body.linearVelocity.y,
                "angle": thet.body.angularVelocity,
              },
              "objectname": thet.objectname,
              "comptransform": thet.transformprop?.toJson(),
              "comptext": thet.comptext?.toJson(),
              "complifebar":
                  thet.complifebar?.toJson(),
              "firstimage": thet.firstimage,
              "compsprite":
                  thet.compsprite?.toJson(),
              "comprigidbody": thet.comprigidbody?.toJson(),
              "compboxcollider": thet.compboxcollider?.toJson(),
              "compcirclecollider": thet.compcirclecollider?.toJson(),
              "compgameobject": thet.thegameobject?.toJson(),
              "compscript": thet.thescript?.toJson() ?? {}
            }
          });
          // print(bComponent!.bodies[a].anglelimit);
        }
        print(thejson);

        variablefile.writeAsString(json.encode(thejson)).then((onValue) {
          var script = gameobjectitemscore[goindex].getscript();
          if (asyncindex != -1 && script != null) {
            Clsscriptitem si2 = script.components[asyncindex];
            getchildactions(
                scriptindex, curobjectname, si2, goindex, thegameobject);
          }
        });
      }
    }
  }

  void checkisloadstate(int scriptindex, String curobjectname, Clsscriptitem si,
      int goindex, Gameobject thegameobject) {
    int asyncindex = si.getasyncindex() ?? -1;

    if (si is Clsactloadstate) {
      String filename = si.filename ?? "";
      // String variable = si.variable;
      if (filename != null) {
        File variablefile = File(statespath + "/" + filename);

        variablefile.readAsString().then((onValue) {
          Map<String, dynamic> tojson2 = json.decode(onValue);

          actionsinitiator.isended = true;
          bComponent!.tofollow = null;
          for (int a1 = 0; a1 < soundslistscore.length; a1++) {
            Clscompsound t = soundslistscore[a1] as Clscompsound;
            t.stop();
          }
          destroytimers();

          loadprojectcore2(currentscenecore).then((onValue) {
            for (int thea = bComponent!.bodies.length - 1; thea >= 0; thea--) {
              Gameobject thet = bComponent!.bodies.values.elementAt(thea);
              thet.destroyobject(thet, "bcomponent", thet.bodyindex);
            }

            bComponent!.bodies.clear();

            bComponent!.onLoad();

            for (int a = 0; a < bComponent!.bodies.length; a++) {
              Gameobject thet = bComponent!.bodies.values.elementAt(a);

              Map<String, dynamic> tojson2temp =
                  tojson2[thet.bodyindex.toString()];

              // ----- starting
              Vector2 bodypos = Vector2(
                tojson2temp['bodypos']['x'],
                tojson2temp['bodypos']['y'],
              );

              thet.body.setTransform(bodypos, tojson2temp['bodypos']['angle']);

              if (si.ignorephysics == false) {
                thet.body.linearVelocity = Vector2(
                    tojson2temp['bodyvelocity']['x'],
                    tojson2temp['bodyvelocity']['y']);

                thet.body.angularVelocity =
                    tojson2temp['bodyvelocity']['angle'];
              }

              thet.objectname = tojson2temp['objectname'];

              thet.transformprop =
                  Clscomptransform.fromJson(tojson2temp['comptransform']);

              thet.comptext = tojson2temp['comptext'] == null
                  ? null
                  : Clscomptext.fromJson(tojson2temp['comptext']);

              thet.complifebar = tojson2temp['complifebar'] == null
                  ? null
                  : Clscomplifebar.fromJson(tojson2temp['complifebar']);

              thet.firstimage = tojson2temp['firstimage'];

              thet.compsprite = tojson2temp['compsprite'] == null
                  ? null
                  : Clscompsprite.fromJson(tojson2temp['compsprite']);
              if (thet.compsprite != null) {
                thet.updatesprite();
              }

              thet.comprigidbody = tojson2temp['comprigidbody'] == null
                  ? null
                  : Clscomprigidbody.fromJson(tojson2temp['comprigidbody']);

              thet.compboxcollider = tojson2temp['compboxcollider'] == null
                  ? null
                  : Clscompboxcollider.fromJson(tojson2temp['compboxcollider']);

              thet.compcirclecollider =
                  tojson2temp['compcirclecollider'] == null
                      ? null
                      : Clscompcirclecollider.fromJson(
                          tojson2temp['compcirclecollider']);

              thet.thegameobject = tojson2temp['compgameobject'] == null
                  ? null
                  : Clscompgameobject.fromJson(
                      a, tojson2temp['compgameobject']);

              thet.thescript = tojson2temp['compscript'] == null
                  ? null
                  : Clscompscript.fromJson(tojson2temp['compscript']);

              // thet.onloaded();
              // --- ending
            }

            for (int a = bComponent!.bodies.length; a < tojson2.length; a++) {
              // print(tojson2[a.toString()]['goindex']);
              // Gameobject thet = bComponent!.bodies.values
              //     .elementAt(tojson2[a.toString()]['goindex']);

              int newid = objectcounters;
              Map<String, dynamic> tojson2temp = tojson2[a.toString()];
              Gameobject thet = Gameobject(box2d!, context!,
                  tojson2temp['goindex'], objectcounters, "asdf",
                  isdebug: bComponent!.bodies[tojson2temp['goindex']]?.isdebug ?? false,
                  naayid: newid);

              // print(thet.goindex);

              bComponent!.bodies.addAll({newid: thet});
              box2d!.add(thet);
              objectcounters++;

              // ----- starting
              Vector2 bodypos = Vector2(
                tojson2temp['bodypos']['x'],
                tojson2temp['bodypos']['y'],
              );

              thet.body.setTransform(bodypos, tojson2temp['bodypos']['angle']);

              if (si.ignorephysics == false) {
                thet.body.linearVelocity = Vector2(
                    tojson2temp['bodyvelocity']['x'],
                    tojson2temp['bodyvelocity']['y']);

                thet.body.angularVelocity =
                    tojson2temp['bodyvelocity']['angle'];
              }
              thet.objectname = tojson2temp['objectname'];

              thet.transformprop =
                  Clscomptransform.fromJson(tojson2temp['comptransform']);

              thet.comptext = tojson2temp['comptext'] == null
                  ? null
                  : Clscomptext.fromJson(tojson2temp['comptext']);

              thet.complifebar = tojson2temp['complifebar'] == null
                  ? null
                  : Clscomplifebar.fromJson(tojson2temp['complifebar']);

              thet.firstimage = tojson2temp['firstimage'];

              thet.compsprite = tojson2temp['compsprite'] == null
                  ? null
                  : Clscompsprite.fromJson(tojson2temp['compsprite']);

              if (thet.compsprite != null) {
                thet.updatesprite();
              }

              thet.comprigidbody = tojson2temp['comprigidbody'] == null
                  ? null
                  : Clscomprigidbody.fromJson(tojson2temp['comprigidbody']);

              thet.compboxcollider = tojson2temp['compboxcollider'] == null
                  ? null
                  : Clscompboxcollider.fromJson(tojson2temp['compboxcollider']);

              thet.compcirclecollider =
                  tojson2temp['compcirclecollider'] == null
                      ? null
                      : Clscompcirclecollider.fromJson(
                          tojson2temp['compcirclecollider']);

              thet.thegameobject = tojson2temp['compgameobject'] == null
                  ? null
                  : Clscompgameobject.fromJson(
                      a, tojson2temp['compgameobject']);

              // thet.thescript = tojson2temp['compscript'] == null
              //     ? null
              //     : Clscompscript.fromJson(tojson2temp['compscript']);

              // thet.onloaded();
              // --- ending
            }

            refreshuicomponents!();
            actionsinitiator?.isended = false;

            var script = gameobjectitemscore[goindex].getscript();
            if (asyncindex != -1 && script != null) {
              Clsscriptitem si2 = script.components[asyncindex];
              getchildactions(
                  scriptindex, curobjectname, si2, goindex, thegameobject);
            }
          });
        });
      }
    }
  }

  void checkisloadvalue(int scriptindex, String curobjectname, Clsscriptitem si,
      int goindex, Gameobject thegameobject) {
    int asyncindex = si.getasyncindex() ?? -1;

    if (si is Clsactloadvalue) {
      String filename = si.filename ?? "";
      String variable = si.variable ?? "";
      if (filename != null) {
        if (variable != null) {
          File variablefile = File(variablespath + "/" + filename);
          // variablefile.deleteSync();
          if (!variablefile.existsSync()) {
            variablefile.writeAsStringSync(json.encode({"empty": "empty"}));
          }
          variablefile.readAsString().then((onValue) {
            String thevariable = variable;

            Map<String, dynamic> tojson2 = json.decode(onValue);

            String thetype = tojson2['type'];

            if (thetype == "number") {
              for (int indvar = 0;
                  indvar < globalvariablescore.length;
                  indvar++) {
                Clsvariable t2 = globalvariablescore[indvar];
                if (t2 is Clsvariablenumber) {
                  if (t2.name == thevariable) {
                    t2.value = tojson2['value'];
                  }
                }
              }
            }

            if (thetype == "boolean") {
              for (int indvar = 0;
                  indvar < globalvariablescore.length;
                  indvar++) {
                Clsvariable t2 = globalvariablescore[indvar];
                if (t2 is Clsvariableboolean) {
                  if (t2.name == thevariable) {
                    t2.value = tojson2['value'];
                  }
                }
              }
            }
            if (thetype == "text") {
              for (int indvar = 0;
                  indvar < globalvariablescore.length;
                  indvar++) {
                Clsvariable t2 = globalvariablescore[indvar];
                if (t2 is Clsvariabletext) {
                  if (t2.name == thevariable) {
                    t2.value = tojson2['value'];
                  }
                }
              }
            }

            var script = gameobjectitemscore[goindex].getscript();
            if (asyncindex != -1 && script != null) {
              Clsscriptitem si2 = script.components[asyncindex];
              getchildactions(
                  scriptindex, curobjectname, si2, goindex, thegameobject);
            }
          });
        }
      }
    }
  }

  bool checkscreentouchlocation(Clscompscreenontouch si) {
    if (si.touchevent == "Touch Down") {
      if (si.location == "Whole") {
        return true;
      } else if (si.location == "Right") {
        if (touchdownlocationphysical.dx >
            screensize.width - screensize.width / 2) {
          return true;
        }
      } else if (si.location == "Left") {
        if (touchdownlocationphysical.dx < screensize.width / 2) {
          return true;
        }
      } else if (si.location == "Top") {
        if (touchdownlocationphysical.dy < screensize.height / 2) {
          return true;
        }
      } else if (si.location == "Bottom") {
        if (touchdownlocationphysical.dy >
            screensize.height - screensize.height / 2) {
          return true;
        }
      }
    }
    if (si.touchevent == "Touch Up") {
      if (si.location == "Whole") {
        return true;
      } else if (si.location == "Right") {
        if (touchuplocationphysical.dx >
            screensize.width - screensize.width / 2) {
          return true;
        }
      } else if (si.location == "Left") {
        if (touchuplocationphysical.dx < screensize.width / 2) {
          return true;
        }
      } else if (si.location == "Top") {
        if (touchuplocationphysical.dy < screensize.height / 2) {
          return true;
        }
      } else if (si.location == "Bottom") {
        if (touchuplocationphysical.dy >
            screensize.height - screensize.height / 2) {
          return true;
        }
      }
    }
    if (si.touchevent == "Touch Move") {
      if (si.location == "Whole") {
        return true;
      } else if (si.location == "Right") {
        if (touchmovelocationphysical.dx >
            screensize.width - screensize.width / 2) {
          return true;
        }
      } else if (si.location == "Left") {
        if (touchmovelocationphysical.dx < screensize.width / 2) {
          return true;
        }
      } else if (si.location == "Top") {
        if (touchmovelocationphysical.dy < screensize.height / 2) {
          return true;
        }
      } else if (si.location == "Bottom") {
        if (touchmovelocationphysical.dy >
            screensize.height - screensize.height / 2) {
          return true;
        }
      }
    }
    return false;
  }

  void initiateactions(
      {required int goindex,
      required Gameobject thegameobject,
      Eevents? eevents,
      String? variablename}) {
    if (eevents == null) return;
    if (isended) return;
    var script = gameobjectitemscore[goindex].getscript();
    if (script == null) return;
    String curobjectname = gameobjectitemscore[goindex].getgameobject()?.name ?? "";

    if (eevents == Eevents.step) {
      for (int b = 0; b < thegameobject.stepindexs.length; b++) {
        Clsscriptitem si = script.components[thegameobject.stepindexs[b]];
        // print(si);
        getchildactions(thegameobject.stepindexs[b], curobjectname, si, goindex,
            thegameobject);
      }
      return;
    }
    for (int b = 0;
        b < script.components.length;
        b++) {
      // print(" initiate  $b");
      Clsscriptitem si = script.components[b];
      if (si is Clscompscreenontouch) {
        if (si.touchevent == "Touch Down" &&
            eevents == Eevents.screentouchdown &&
            checkscreentouchlocation(si)) {
          getchildactions(b, curobjectname, si, goindex, thegameobject);
        }
        if (si.touchevent == "Touch Down" &&
            eevents == Eevents.screentouchdowncontinuous &&
            checkscreentouchlocation(si)) {
          if (thegameobject.istouchdown == true && si.continuous == "true") {
            getchildactions(b, curobjectname, si, goindex, thegameobject);
          }
        }
        if (si.touchevent == "Touch Up" &&
            eevents == Eevents.screentouchup &&
            checkscreentouchlocation(si)) {
          getchildactions(b, curobjectname, si, goindex, thegameobject);
        }
        if (si.touchevent == "Touch Move" &&
            eevents == Eevents.screentouchmove &&
            checkscreentouchlocation(si)) {
          getchildactions(b, curobjectname, si, goindex, thegameobject);
        }
      }
      // else if (si is Clscompstep) {
      //   if (eevents == Eevents.step) {
      //     getchildactions(curobjectname, si, goindex, thegameobject);
      //   }
      // }

      else if (si is Clscomponobjectloaded) {
        if (eevents == Eevents.onobjectloaded) {
          getchildactions(b, curobjectname, si, goindex, thegameobject);
        }
      } else if (si is Clscompobjectontouch) {
        if (si.touchevent == "Touch Down" &&
            eevents == Eevents.objecttouchdown) {
          getchildactions(b, curobjectname, si, goindex, thegameobject);
        }
        if (si.touchevent == "Touch Up" && eevents == Eevents.objecttouchup) {
          getchildactions(b, curobjectname, si, goindex, thegameobject);
        }
        if (si.touchevent == "Touch Move" &&
            eevents == Eevents.objecttouchmove) {
          getchildactions(b, curobjectname, si, goindex, thegameobject);
        }
      } else if (si is Clscomponjoystick) {
        if (si.joystickevent == "Direction Changed" &&
            eevents == Eevents.onjoystickdirectionchanged) {
          if (si.variable == variablename) {
            getchildactions(b, curobjectname, si, goindex, thegameobject);
          }
        }
      }
    }
  }

  void expressionobjectproperties(Map<String, dynamic> context) {
    context!.addAll({
      "obj_position_x": (int objectid) {
        var obj = bComponent!.bodies[objectid];
        return obj != null ? obj.body.position.x : 0.0;
      }
    });
    context!.addAll({
      "obj_position_y": (int objectid) {
        var obj = bComponent!.bodies[objectid];
        return obj != null ? obj.body.position.y : 0.0;
      }
    });
    context!.addAll({
      "obj_angle": (int objectid) {
        var obj = bComponent!.bodies[objectid];
        return obj != null ? obj.body.angle : 0.0;
      }
    });
    context!.addAll({
      "obj_scale_x": (int objectid) {
        var obj = bComponent!.bodies[objectid];
        return obj != null && obj.transformprop != null ? obj.transformprop!.sx : 1.0;
      }
    });
    context!.addAll({
      "obj_scale_y": (int objectid) {
        var obj = bComponent!.bodies[objectid];
        return obj != null && obj.transformprop != null ? obj.transformprop!.sy : 1.0;
      }
    });
    context!.addAll({
      "obj_velocity_x": (int objectid) {
        var obj = bComponent!.bodies[objectid];
        return obj != null ? obj.body.linearVelocity.x : 0.0;
      }
    });
    context!.addAll({
      "obj_velocity_y": (int objectid) {
        var obj = bComponent!.bodies[objectid];
        return obj != null ? obj.body.linearVelocity.y : 0.0;
      }
    });
    context!.addAll({
      "obj_velocity_angle": (int objectid) {
        var obj = bComponent!.bodies[objectid];
        return obj != null ? obj.body.angularVelocity : 0.0;
      }
    });
    context!.addAll({
      "obj_sprite_opacity": (int objectid) {
        var obj = bComponent!.bodies[objectid];
        if (obj != null && obj.compsprite != null && obj.compsprite!.opacity != null) {
          return obj.compsprite!.opacity;
        }
        return 1.0;
      }
    });
  }

  dynamic evaluateexpression(String expressions, Gameobject thegameobject) {
    Expression expression = Expression.parse(expressions.replaceAll(" ", ""));
    // print(expressions);
    Map<String, dynamic> context = {
      "position_x": thegameobject.body.position.x,
      "position_y": thegameobject.body.position.y,
      "angle": thegameobject.body.angle,
      "scale_x": thegameobject.transformprop?.sx ?? 1.0,
      "scale_y": thegameobject.transformprop?.sy ?? 1.0,
      "velocity_x": thegameobject.body.linearVelocity.x,
      "velocity_y": thegameobject.body.linearVelocity.y,
      "velocity_angle": thegameobject.body.angularVelocity,
      "object_id": thegameobject.thegameobject?.theid ?? 0,
      "lifebar_value": thegameobject.complifebar == null
          ? 0
          : thegameobject.complifebar!.thevalue,
      "lifebar_max": thegameobject.complifebar == null
          ? 0
          : thegameobject.complifebar!.maxvalue,
      "camera_width": (getprojectsettingscore()?.appversion ?? 0) >= 11
          ? screensize.width
          : bComponent!.camera.viewport.size.x,
      "camera_height": (getprojectsettingscore()?.appversion ?? 0) >= 11
          ? screensize.height
          : bComponent!.camera.viewport.size.y,
      "camera_x": bComponent!.camera.viewfinder.position.x,
      "camera_y": bComponent!.camera.viewfinder.position.y,
      "touchmove_x": touchmovelocation.x,
      "touchmove_y": touchmovelocation.y,
      "touchdown_x": touchdownlocation.x,
      "touchdown_y": touchdownlocation.y,
      "touchup_x": touchuplocation.x,
      "touchup_y": touchuplocation.y,
      "mic_dblevel": miclevel,
      "accelerometer_x": accelerometervalue.x,
      "accelerometer_y": accelerometervalue.y,
      "accelerometer_z": accelerometervalue.z,
      "gyroscope_x": gyroscopevalue.x,
      "gyroscope_y": gyroscopevalue.y,
      "gyroscope_z": gyroscopevalue.z,
      "deltatime": deltatime
    };
    if (thegameobject.compsprite != null && thegameobject.compsprite!.opacity != null) {
      context!.addAll({"sprite_opacity": thegameobject.compsprite!.opacity});
    }

    expressionobjectproperties(context);

    for (int a2 = 0; a2 < globalvariablescore.length; a2++) {
      Clsvariable t2 = globalvariablescore[a2];
      if (t2 is Clsvariablenumber) {
        context!.addAll({t2.name ?? "": t2.value});
      }
      if (t2 is Clsvariableboolean) {
        context!.addAll({t2.name ?? "": t2.value});
      }
    }
    var tScript = thegameobject.thescript;
    if (tScript != null) {
      for (int b2 = 0; b2 < tScript.localvariables.length; b2++) {
        Clsvariable t2 = tScript.localvariables[b2];
        if (t2 is Clsvariablenumber) {
          context!.addAll({t2.name!: t2.value});
        }
        if (t2 is Clsvariableboolean) {
          context!.addAll({t2.name!: t2.value});
        }
      }
    }

    // print(uijoystickvalues.length);
    uijoystickvalues.forEach((key, value) {
      context!.addAll({key + "_angle": value["angle"]});
      context!.addAll({key + "_distance": value["distance"]});
      context!.addAll({key + "_value_x": value["valx"]});
      context!.addAll({key + "_value_y": value["valy"]});
    });
    expressionmathvariables(context);

    final evaluator = const ExpressionEvaluator();
    var r = evaluator.eval(expression, context);
    if (r is int) {
      return r.toDouble();
    } else if (r is double) {
      return r;
    } else {
      return r;
    }
  }

  void initiateactions4(int scriptindex,
      {Clsscriptitem? t, Gameobject? thegameobject, int? goindex}) {
    if (t == null || thegameobject == null || goindex == null) return;
    if (t is Clsactloadscene) {
      // gv.pauseEngine();
      // return;
      if (t.scenename == null) return;

      actionsinitiator.isended = true;
      bComponent!.tofollow = null;
      for (int a1 = 0; a1 < soundslistscore.length; a1++) {
        Clscompsound t = soundslistscore[a1] as Clscompsound;
        t.stop();
      }
      destroytimers();

      loadprojectcore2(t.scenename ?? "scene1").then((onValue) {
        for (int thea = bComponent!.bodies.length - 1; thea >= 0; thea--) {
          Gameobject thet = bComponent!.bodies.values.elementAt(thea);
          thet.destroyobject(thet, "bcomponent", thet.bodyindex);
          // bComponent!.bodies.remove(thet);
          // bComponent!.bodies.remove(thet.thegameobject.theid);

        }
        // bComponent!.bodies.forEach((key, val) {

        // });

        bComponent!.bodies.clear();
        // bodies.clear();

        bComponent!.onLoad();

        refreshuicomponents?.call();
        actionsinitiator?.isended = false;
      });
      return;
    }

    if (t is Clsactsetvelocity) {
      if (thegameobject.body.bodyType != BodyType.static) {
        if (!t.x.isNaN || t.expx != null) {
          if (t.expx == null) {
            thegameobject.body
              ..linearVelocity.x = t.x
              ..setAwake(true);
          } else {
            double r = evaluateexpression(t.expx ?? "", thegameobject);
            thegameobject.body
              ..linearVelocity.x = r
              ..setAwake(true);
          }
        }

        if (!t.y.isNaN || t.expy != null) {
          if (t.expy == null) {
            thegameobject.body
              ..linearVelocity.y = t.y
              ..setAwake(true);
          } else {
            double r = evaluateexpression(t.expy ?? "", thegameobject);
            thegameobject.body
              ..linearVelocity.y = r
              ..setAwake(true);
          }
        }
        if (!t.angular.isNaN || t.expangular != null) {
          if (t.expangular == null) {
            thegameobject
              ..body.angularVelocity = t.angular
              ..isapplyingangular = true
              ..anglelimit = t.anglelimit
              ..defangle = thegameobject.body.angle;
          } else {
            double r = evaluateexpression(t.expangular ?? "", thegameobject);
            thegameobject
              ..body.angularVelocity = r
              ..isapplyingangular = true
              ..anglelimit = t.anglelimit
              ..defangle = thegameobject.body.angle;
          }

          thegameobject.body.setAwake(true);
        }
      }
    } else if (t is Clsactsettransform) {
      if (!t.x.isNaN || t.expx != null) {
        if (t.expx == null) {
          thegameobject.body.setTransform(
              Vector2(t.x, thegameobject.body.position.y),
              thegameobject.body.angle);
          thegameobject.transformprop?.x = t.x;
          // print("asdfasdfasdf");
        } else {
          double r = evaluateexpression(t.expx ?? "", thegameobject);
          thegameobject.body.setTransform(
              Vector2(r, thegameobject.body.position.y),
              thegameobject.body.angle);
          thegameobject.transformprop?.x = r;
        }
      }

      if (!t.y.isNaN || t.expy != null) {
        if (t.expy == null) {
          thegameobject.body.setTransform(
              Vector2(thegameobject.body.position.x, t.y),
              thegameobject.body.angle);
          thegameobject.transformprop?.y = -t.y;
        } else {
          double r = evaluateexpression(t.expy ?? "", thegameobject);
          thegameobject.body.setTransform(
              Vector2(thegameobject.body.position.x, r),
              thegameobject.body.angle);
          thegameobject.transformprop?.y = -r;
        }
      }

      if (!t.angle.isNaN || t.expangle != null) {
        // print("asdfasdfasdf");
        if (t.expangle == null) {
          thegameobject.body.setTransform(
              Vector2(
                  thegameobject.body.position.x, thegameobject.body.position.y),
              -t.angle);
          thegameobject.transformprop?.angle = t.angle;
        } else {
          double r = evaluateexpression(t.expangle ?? "", thegameobject);
          thegameobject.body.setTransform(
              Vector2(
                  thegameobject.body.position.x, thegameobject.body.position.y),
              -r);
          thegameobject.transformprop?.angle = r;
        }
        // print(bodies[a].body.angle);
      }

      if (!t.sy.isNaN || t.expsy != null) {
        if (t.expsy == null) {
          // gameobjectitemscore[goindex].settransform(sy: t.sy);
          thegameobject.transformprop?.sy = t.sy;
        } else {
          double r = evaluateexpression(t.expsy ?? "", thegameobject);
          // gameobjectitemscore[goindex].settransform(sy: r);
          thegameobject.transformprop?.sy = r;
        }
      }

      if (!t.sx.isNaN || t.expsx != null) {
        if (t.expsx == null) {
          // gameobjectitemscore[goindex].settransform(sx: t.sx);
          thegameobject.transformprop?.sx = t.sx;
        } else {
          double r = evaluateexpression(t.expsx ?? "", thegameobject);
          // gameobjectitemscore[goindex].settransform(sx: r);
          thegameobject.transformprop?.sx = r;
        }
      }
    } else if (t is Clsactsetcamera) {
      double posx = 0;
      double posy = 0;
      double scale = 1;
      if (!t.posx.isNaN || t.expposx != null) {
        posx = t.posx;

        if (t.expposx == null) {
        } else {
          double r = evaluateexpression(t.expposx ?? "", thegameobject);

          posx = r;
        }
      }

      if (!t.posy.isNaN || t.expposy != null) {
        if (t.expposy == null) {
          posy = t.posy;
        } else {
          double r = evaluateexpression(t.expposy ?? "", thegameobject);

          posy = r;
        }
      }

      if (!t.scale.isNaN || t.expscale != null) {
        if (t.expscale == null) {
          scale = t.scale;
          // print(scale);
        } else {
          double r = evaluateexpression(t.expscale ?? "", thegameobject);
          scale = r;
        }
      }

      double smoothvalue = 0;

      if (!t.smoothvalue.isNaN) {
        smoothvalue = t.smoothvalue;

        if (t.posx != null) {
          if (camerasmoothx.isNaN) {
            camerasmoothx = cameragetcameracontrollercore()!.x;
          }

          camerasmoothx =
              ui.lerpDouble(camerasmoothx, posx, smoothvalue * deltatime) ?? camerasmoothx;
          cameragetcameracontrollercore()!.x = camerasmoothx;
          // bComponent!.camera.viewport.setCamera(camerasmoothx, posy, scale);
        }

        if (t.posy != null) {
          if (camerasmoothy.isNaN) {
            camerasmoothy = cameragetcameracontrollercore()!.y;
          }

          camerasmoothy =
              ui.lerpDouble(camerasmoothy, posy, smoothvalue * deltatime) ?? camerasmoothy;
          cameragetcameracontrollercore()!.y = -camerasmoothy;
        }

        if (t.scale != null) {
          if (camerasmoothscale.isNaN) {
            camerasmoothscale = cameragetcameracontrollercore()!.scale;
          }
          camerasmoothscale =
              ui.lerpDouble(camerasmoothscale, scale, smoothvalue * deltatime) ?? camerasmoothscale;
          cameragetcameracontrollercore()!.scale = camerasmoothscale;
        }
      } else {
        // bComponent!.camera.viewport.setCamera(posx, posy, scale);
        // print(posx);
        cameragetcameracontrollercore()!.x = posx;
        cameragetcameracontrollercore()!.y = -posy;
        cameragetcameracontrollercore()!.scale = scale;
      }
      //  print(bComponent!.camera.viewport.x);

    } else if (t is Clsactsetsprite) {
      String image = t.image ?? "";
      String animation = t.animation ?? "";
      double opacity = t.opacity;

      if (opacity == null) {
        opacity = 1;
      }

      // print(opacity);
      if (opacity != null || !opacity.isNaN || t.expopacity == null) {
        if (t.expopacity == null) {
          if (!opacity.isNaN) {
            if (thegameobject.compsprite != null) {
              thegameobject.compsprite!.opacity = opacity;
            }
          }
        } else {
          double r = evaluateexpression(t.expopacity ?? "", thegameobject);

          if (thegameobject.compsprite != null) {
            thegameobject.compsprite!.opacity = r;
          }
        }
      }

      // if (opacity != null) {
      //   thegameobject.compsprite.opacity = opacity;
      // }
      if (image != null) {
        if (thegameobject.compsprite != null) {
          thegameobject.compsprite!.imagepath = image;
          thegameobject.compsprite!.spriteanimation = null;
          thegameobject.updatesprite();
        }
      } else {
        if (animation != null) {
          if (thegameobject.compsprite != null) {
            thegameobject.compsprite!.imagepath = null;
            thegameobject.compsprite!.spriteanimation = t.animation;
            thegameobject.updatesprite();
          }
        }
      }
    } else if (t is Clsactdestroyobject) {
      // if (a < bodies.length) {

      thegameobject.destroyobject(
          thegameobject, "bcomponent", thegameobject.bodyindex);

      // return;
      // bodies[a].destroyobject("bodies");

      // if (a >= gameobjectitemscore.length) {
      //   //
      //   // bComponent!.bodies.removeAt(a);
      // }
      // }
    } else if (t is Clsactcreateobject) {
      //  print("asdfasdfasdf");
      // bComponent!.isloadedna = false;
      // bComponent!.toaddtouchdown.clear();
      for (int indcreate = 0;
          indcreate < gameobjectitemscore.length;
          indcreate++) {
        var targetGO = gameobjectitemscore[indcreate].getgameobject();
        if (targetGO != null && t.objectname == targetGO.name) {
          int newid = objectcounters;
          // print("newid" + newid.toString());
          Gameobject temp = Gameobject(
              box2d!, context!, indcreate, objectcounters, t.objectname ?? "",
              isdebug: bComponent!.bodies[indcreate]?.isdebug ?? false,
              naayid: newid);

          bComponent!.bodies.addAll({newid: temp});

          // print(indcreate);

          box2d!.add(temp);
          objectcounters++;

          double posx = 0;
          double posy = 0;
          double velx = 0;
          double vely = 0;
          if (!t.x.isNaN || t.expx != null) {
            if (t.expx == null) {
              posx = t.x;
            } else {
              double r = evaluateexpression(t.expx ?? "", thegameobject);
              posx = r;
            }
          }

          if (!t.y.isNaN || t.expy != null) {
            if (t.expy == null) {
              posy = t.y;
            } else {
              double r = evaluateexpression(t.expy ?? "", thegameobject);
              posy = r;
            }
          }

          if (!t.velx.isNaN || t.expvelx != null) {
            if (t.expvelx == null) {
              velx = t.velx;
            } else {
              double r = evaluateexpression(t.expvelx ?? "", thegameobject);
              velx = r;
            }
          }

          if (!t.vely.isNaN || t.expvely != null) {
            if (t.expvely == null) {
              vely = t.vely;
            } else {
              double r = evaluateexpression(t.expvely ?? "", thegameobject);
              vely = r;
            }
          }

          if (t.isrelative == true) {
            Offset temprotation = rotatepoint(
                thegameobject.body.position.x,
                thegameobject.body.position.y,
                thegameobject.body.angle,
                Offset(thegameobject.body.position.x + posx,
                    thegameobject.body.position.y + posy));

            temp.body.setTransform(Vector2(0, 0), temp.body.angle);
            // print(thegameobject.body.angle);
            Offset temprotation2 = rotatepoint(
                temp.body.position.x,
                temp.body.position.y,
                thegameobject.body.angle,
                Offset(
                    temp.body.position.x + velx, temp.body.position.y + vely));

            temp.body.setTransform(
                Vector2(temprotation.dx, temprotation.dy),
                bComponent!
                    .bodies[
                        targetGO.theid]
                    ?.body
                    .angle ?? 0);
            // print(temp.body.angle);

            temp.body.linearVelocity =
                Vector2(temprotation2.dx, temprotation2.dy);
          } else {
            temp.body.setTransform(Vector2(posx, posy), temp.body.angle);
            temp.body.linearVelocity = Vector2(velx, vely);
          }
          // print(bComponent!.bodies.length.toString() + "    length");
          temp.onloaded();
          break;
        }
      }
    } else if (t is Clsactfollowobject) {
      // print("asdfasdf");
      double x1 = thegameobject.body.position.x;
      double y1 = thegameobject.body.position.y;
      // thegameobject.body.isAwake = true;
      // thegameobject.refreshfollowobjects(false);

      thegameobject.followobjectindexs.forEach((key, value) {
        // print(value.thegameobject.name.toString() +
        //     "                 " +
        //     scriptindex.toString());
        if (value.thegameobject?.name == t.objectname) {
          double x2 = value.body.position.x;
          double y2 = value.body.position.y;

          double distance =
              math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
          double movex = (x2 - x1) / distance;
          double movey = (y2 - y1) / distance;
          double tempgetangle = thegameobject.body.angle;
          if (thegameobject.comprigidbody?.fixedrotation == false) {
            tempgetangle = math.atan2(y2 - y1, x2 - x1);
          }

          thegameobject.body.setTransform(Vector2(x1, y1), tempgetangle);

          double speed = 0;
          if (!t.speed.isNaN || t.expspeed != null) {
            if (t.expspeed == null) {
              speed = t.speed;
            } else {
              double r = evaluateexpression(t.expspeed ?? "", thegameobject);
              speed = r;
            }
          }

          if (!t.speed.isNaN) {
            thegameobject.body.linearVelocity =
                Vector2(movex * speed, movey * speed);
          }
        }
      });
    } else if (t is Clsactsettext) {
      if (t.text != null) {
        thegameobject.comptext?.text = t.text;
      } else if (t.exptext != null) {
        String thevariable = t.exptext ?? "";

        for (int indvar = 0; indvar < globalvariablescore.length; indvar++) {
          Clsvariable t2 = globalvariablescore[indvar];
          if (t2 is Clsvariablenumber) {
            if (t2.name == thevariable) {
              if (isInteger(t2.value)) {
                thegameobject.comptext?.text = t2.value.toStringAsFixed(0);
              } else {
                thegameobject.comptext?.text = t2.value.toStringAsFixed(2);
              }
            }
          }
        }
      }
      if (!t.blurradius.isNaN) {
        thegameobject.comptext?.blurradius = t.blurradius;
      }
      if (t.fontfamily != null) {
        thegameobject.comptext?.fontfamily = t.fontfamily;
      }
      // print(t.fontsize);
      if (!t.fontsize.isNaN) {
        thegameobject.comptext?.fontsize = t.fontsize;
      }
      if (t.textcolor != null) {
        thegameobject.comptext?.textcolor = t.textcolor;
      }
    } else if (t is Clsactsetadvertisement) {
      // print(t);

      if (t.action == "show") {
        // if(uicomponentscore)
        if (!isbanneradshowing) {
          print(theads2.anchor);
          isbanneradshowing = true;
          if (theads2.anchor == "top") {
            theads2.showBannerAd(true);
          } else if (theads2.anchor == "bottom") {
            theads2.showBannerAd(false);
          }
        }
      }
      if (t.action == "hide") {
        if (isbanneradshowing) {
          isbanneradshowing = false;
          theads2.hideBannerAd();
        }
      }
      // print("aasdfasdfasdfasdf");

      // if (t.text != null) {
      //   thegameobject.comptext.text = t.text;
      // } else if (t.exptext != null) {
      //   String thevariable = t.exptext;

      //   for (int indvar = 0; indvar < globalvariablescore.length; indvar++) {
      //     Clsvariable t2 = globalvariablescore[indvar];
      //     if (t2 is Clsvariablenumber) {
      //       if (t2.name == thevariable) {
      //         if (isInteger(t2.value)) {
      //           thegameobject.comptext.text = t2.value.toStringAsFixed(0);
      //         } else {
      //           thegameobject.comptext.text = t2.value.toStringAsFixed(2);
      //         }
      //       }
      //     }
      //   }
      // }
      // if (!t.blurradius.isNaN) {
      //   thegameobject.comptext.blurradius = t.blurradius;
      // }
      // if (t.fontfamily != null) {
      //   thegameobject.comptext.fontfamily = t.fontfamily;
      // }
      // // print(t.fontsize);
      // if (!t.fontsize.isNaN) {
      //   thegameobject.comptext.fontsize = t.fontsize;
      // }
      // if (t.textcolor != null) {
      //   thegameobject.comptext.textcolor = t.textcolor;
      // }
    } else if (t is Clsactsetlifebar) {
      if (!t.thevalue.isNaN || t.expthevalue != null) {
        if (t.expthevalue == null) {
          thegameobject.complifebar?.thevalue = t.thevalue;
        } else {
          double r = evaluateexpression(t.expthevalue ?? "", thegameobject);

          if (thegameobject.complifebar != null) {
            thegameobject.complifebar!.thevalue = r;
          }
        }
      }
      if (!t.maxvalue.isNaN || t.expmaxvalue != null) {
        if (t.expmaxvalue == null) {
          thegameobject.complifebar?.maxvalue = t.maxvalue;
        } else {
          double r = evaluateexpression(t.expmaxvalue ?? "", thegameobject);

          if (thegameobject.complifebar != null) {
            thegameobject.complifebar!.maxvalue = r;
          }
        }
      }
      if (t.backgroundcolor != null) {
        thegameobject.complifebar?.backgroundcolor = t.backgroundcolor;
      }
      if (t.foregroundcolor != null) {
        thegameobject.complifebar?.foregroundcolor = t.foregroundcolor;
      }
    } else if (t is Clsactsetvariable) {
      if (!t.numbervalue.isNaN || t.expnumbervalue != null) {
        if (t.expnumbervalue == null) {
          if (t.scope == "global" || t.scope == null) {
            for (int indvar = 0;
                indvar < globalvariablescore.length;
                indvar++) {
              Clsvariable t2 = globalvariablescore[indvar];
              if (t2 is Clsvariablenumber) {
                if (t2.name == t.variablename) {
                  t2.value = t.numbervalue;
                }
              }
            }
          }

          if (t.scope == "local") {
              if (thegameobject.thescript != null) {
                for (int indvar = 0;
                    indvar < thegameobject.thescript!.localvariables.length;
                    indvar++) {
                  Clsvariable t2 =
                      thegameobject.thescript!.localvariables[indvar];
                  if (t2 is Clsvariablenumber) {
                    if (t2.name == t.variablename) {
                      t2.value = t.numbervalue;
                    }
                  }
                }
              }
          }
        } else {
          dynamic tempr = evaluateexpression(t.expnumbervalue ?? "", thegameobject);
          double r = tempr is double ? tempr : 0;
//  print(r);
          if (t.scope == "global" || t.scope == null) {
            for (int indvar = 0;
                indvar < globalvariablescore.length;
                indvar++) {
              Clsvariable t2 = globalvariablescore[indvar];

              if (t2 is Clsvariablenumber) {
                if (t2.name == t.variablename) {
                  t2.value = r;
                }
              }
            }
          }
          if (t.scope == "local") {
            if (thegameobject.thescript != null) {
              for (int indvar = 0;
                  indvar < thegameobject.thescript!.localvariables.length;
                  indvar++) {
                Clsvariable t2 =
                    thegameobject.thescript!.localvariables[indvar];
                if (t2 is Clsvariablenumber) {
                  // print(thegameobject.goindex);
                  if (t2.name == t.variablename) {
                    t2.value = r;
                  }
                }
              }
            }
          }
        }
      }
      if (t.booleanvalue != null) {
        if (t.scope == "global" || t.scope == null) {
          for (int indvar = 0; indvar < globalvariablescore.length; indvar++) {
            Clsvariable t2 = globalvariablescore[indvar];
            if (t2 is Clsvariableboolean) {
              if (t2.name == t.variablename) {
                t2.value = t.booleanvalue;
              }
            }
          }
        }
        if (t.scope == "local") {
            if (thegameobject.thescript != null) {
              for (int indvar = 0;
                  indvar < thegameobject.thescript!.localvariables.length;
                  indvar++) {
                Clsvariable t2 =
                    thegameobject.thescript!.localvariables[indvar];
                if (t2 is Clsvariableboolean) {
                  if (t2.name == t.variablename) {
                    t2.value = t.booleanvalue;
                  }
                }
              }
            }
        }
      }
      if (t.textvalue != null) {
        if (t.scope == "global" || t.scope == null) {
          for (int indvar = 0; indvar < globalvariablescore.length; indvar++) {
            Clsvariable t2 = globalvariablescore[indvar];
            if (t2 is Clsvariabletext) {
              if (t2.name == t.variablename) {
                t2.value = t.textvalue;
              }
            }
          }
        }
          if (t.scope == "local") {
              if (thegameobject.thescript != null) {
                for (int indvar = 0;
                    indvar < thegameobject.thescript!.localvariables.length;
                    indvar++) {
                  Clsvariable t2 =
                      thegameobject.thescript!.localvariables[indvar];
                  if (t2 is Clsvariabletext) {
                    if (t2.name == t.variablename) {
                      t2.value = t.textvalue;
                    }
                  }
                }
              }
          }
      }
    } else if (t is Clsactsetsound) {
      for (int indsounds = 0; indsounds < soundslistscore.length; indsounds++) {
        Clssoundcomponent t2raw = soundslistscore[indsounds];
        if (t2raw is! Clscompsound) continue;
        Clscompsound t2 = t2raw;
        if (t2.variablename == t.variablename) {
          if (!t.volume.isNaN || t.expvolume != null) {
            if (t.expvolume == null) {
              t2.setvolume(t.volume);
            } else {
              double r = evaluateexpression(t.expvolume ?? "", thegameobject);

              t2.setvolume(r);
            }
          }
          if (t.playerstate == "playing") {
            t2.play();
          }
          if (t.playerstate == "paused") {
            t2.pause();
          }
        }
      }
    }
  }
}

int objectcounters = 10000;

class Gameobject extends BodyComponent {
  // bool isimageresolved = false;
  late ui.Image theimage;
  int goindex;
  BuildContext context;
  // double tempy = 0;
  bool ismanaapply = false;
  bool isapplyingangular = false;
  double anglelimit = 0;
  double defangle = 0;
  int bodyindex = 0;
  bool isdestroyed = false;
  String objectname = "";
  Spriteanimation? sp;
  Clscomptransform? transformprop;
  Clscomptext? comptext;
  Clscomplifebar? complifebar;
  String? firstimage;
  Clscompsprite? compsprite;
  Clscomprigidbody? comprigidbody;
  Clscompboxcollider? compboxcollider;
  Clscompcirclecollider? compcirclecollider;
  Clscompgameobject? thegameobject;
  Clscompscript? thescript;
  List<int> stepindexs = [];
  Map<int, Gameobject> followobjectindexs = {};

  bool isdebug;
  bool istouchdown = false;
  bool hasrigidbody = false;
  bool isloaded = false;

  Gameobject(Forge2DGame game, this.context, this.goindex, this.bodyindex,
      this.objectname,
      {this.isdebug = false, int? naayid})
      : super() {
    stepindexs.clear();
    theimage = noimage;
    var tSprite = gameobjectitemscore[goindex].getsprite();
    if (tSprite != null) {
      compsprite = tSprite;
      if (tSprite.imagepath == null) {
        String? spriteanimationvariable = tSprite.spriteanimation; // nullable string

        if (spriteanimationvariable != null) {
          firstimage = gameobjectitemscore[goindex]
              .getspriteanimationimage(spriteanimationvariable);
          if (firstimage != null) {
            if (loadedimages.length > 0) {
              if (loadedimages.containsKey(firstimage)) {
                theimage = loadedimages[firstimage]!;

                sp = Spriteanimation(
                    id: goindex.toString(),
                    images: gameobjectitemscore[goindex]
                        .getspriteanimationimagelists(spriteanimationvariable)!,
                    interval: gameobjectitemscore[goindex]
                        .getspriteanimationimageinterval(
                            spriteanimationvariable));
              }
            }
          }
        }
      } else {
        if (loadedimages.containsKey(tSprite.imagepath)) {
           theimage = loadedimages[tSprite.imagepath]!;
        }
      }
    }

    var tTransform = gameobjectitemscore[goindex].gettransform();
    if (tTransform != null) {
      transformprop = Clscomptransform.fromJson(tTransform.toJson());
    }

    var tText = gameobjectitemscore[goindex].gettext();
    if (tText != null) {
      comptext = Clscomptext.fromJson(tText.toJson());
    }

    var tLifebar = gameobjectitemscore[goindex].getlifebar();
    if (tLifebar != null) {
      complifebar = Clscomplifebar.fromJson(tLifebar.toJson());
    }

    var tRigidbody = gameobjectitemscore[goindex].getrigidbody();
    if (tRigidbody != null) {
      comprigidbody = Clscomprigidbody.fromJson(tRigidbody.toJson());
    }

    var tBoxCollider = gameobjectitemscore[goindex].getboxcollider();
    if (tBoxCollider != null) {
      compboxcollider = Clscompboxcollider.fromJson(tBoxCollider.toJson());
    }
    var tCircleCollider = gameobjectitemscore[goindex].getcirclecollider();
    if (tCircleCollider != null) {
      compcirclecollider = Clscompcirclecollider.fromJson(tCircleCollider.toJson());
    }
    var tGameObject = gameobjectitemscore[goindex].getgameobject();
    if (tGameObject != null) {
      thegameobject = Clscompgameobject.fromJson(
          naayid != null ? naayid : tGameObject.theid, tGameObject.toJson());
    }
    var tScript = gameobjectitemscore[goindex].getscript();
    if (tScript != null) {
      thescript = Clscompscript.fromJson(tScript.toJson());
    }

    createBody();
    // onloaded();
  }

  void updatesprite() {
    theimage = noimage;
    sp = null;
    if (compsprite == null) return;
    if (compsprite!.imagepath == null) {
      String spriteanimationvariable = compsprite!.spriteanimation ?? "";

      if (spriteanimationvariable.isNotEmpty) {
        firstimage = gameobjectitemscore[goindex]
            .getspriteanimationimage(spriteanimationvariable);

        if (firstimage != null) {
          if (loadedimages.length > 0) {
            theimage = loadedimages[firstimage]!;

            sp = Spriteanimation(
                id: goindex.toString(),
                images: gameobjectitemscore[goindex]
                    .getspriteanimationimagelists(spriteanimationvariable) ?? [],
                interval: gameobjectitemscore[goindex]
                    .getspriteanimationimageinterval(spriteanimationvariable));
          }
        }
      }
    } else {
      theimage = loadedimages[compsprite!.imagepath]!;
      // print(compsprite.imagepath);
    }
  }

  void ontouchup(PointerUpEvent details) {
    // print("asdfasdfasdfasdfasdf");
    // print(objectname);
    if (isdestroyed) return;
    istouchdown = false;
    actioninitiator(eevents: Eevents.screentouchup);
    if (hasrigidbody) {
      if (body.fixtures.isNotEmpty) {
        bool wasTouched = body.fixtures.any((f) => f.testPoint(game.screenToWorld(
            Vector2(details.localPosition.dx, details.localPosition.dy))));
        if (wasTouched) {
          actioninitiator(eevents: Eevents.objecttouchup);
        }
      }
    } else {
      if (compboxcollider != null && transformprop != null) {
        double x =
            (transformprop!.x ?? 0) + (compboxcollider!.x ?? 0) - ((compboxcollider!.w ?? 0) / 2) +
                screensize.width / 2;
        double y =
            (transformprop!.y ?? 0) + (compboxcollider!.y ?? 0) - ((compboxcollider!.h ?? 0) / 2) +
                screensize.height / 2;
        double w = compboxcollider!.w ?? 0;
        double h = compboxcollider!.h ?? 0;

        Vector2 touchpos =
            ((Vector2(details.localPosition.dx, details.localPosition.dy)));

        if (touchpos.x > x && touchpos.x < x + w) {
          if (touchpos.y > y && touchpos.y < y + h) {
            actioninitiator(eevents: Eevents.objecttouchup);
          }
        }
      }
    }
  }

  void ontouchdown(PointerDownEvent details) {
    if (isdestroyed) return;
    istouchdown = true;

    actioninitiator(eevents: Eevents.screentouchdown);
    if (hasrigidbody) {
      if (body.fixtures.isNotEmpty) {
        bool wasTouched = body.fixtures.any((f) => f.testPoint(game.screenToWorld(
                Vector2(details.localPosition.dx, details.localPosition.dy))));
        if (wasTouched) {
          actioninitiator(eevents: Eevents.objecttouchdown);
        }
      }
    } else {
      if (compboxcollider != null && transformprop != null) {
        double x =
            (transformprop!.x ?? 0) + (compboxcollider!.x ?? 0) - ((compboxcollider!.w ?? 0) / 2) +
                screensize.width / 2;
        double y =
            (transformprop!.y ?? 0) + (compboxcollider!.y ?? 0) - ((compboxcollider!.h ?? 0) / 2) +
                screensize.height / 2;
        double w = compboxcollider!.w ?? 0;
        double h = compboxcollider!.h ?? 0;

        Vector2 touchpos =
            ((Vector2(details.localPosition.dx, details.localPosition.dy)));

        if (touchpos.x > x && touchpos.x < x + w) {
          if (touchpos.y > y && touchpos.y < y + h) {
            actioninitiator(eevents: Eevents.objecttouchdown);
          }
        }
      }
    }
  }

  void ontouchmove(PointerMoveEvent details) {
    if (isdestroyed) return;
    actioninitiator(eevents: Eevents.screentouchmove);
    if (hasrigidbody) {
      if (body.fixtures.isNotEmpty) {
        bool wasTouched = body.fixtures.any((f) => f.testPoint(game.screenToWorld(
                Vector2(details.localPosition.dx, details.localPosition.dy))));
        if (wasTouched) {
          actioninitiator(eevents: Eevents.objecttouchmove);
        }
      }
    } else {
      if (compboxcollider != null && transformprop != null) {
        double x =
            (transformprop!.x ?? 0) + (compboxcollider!.x ?? 0) - ((compboxcollider!.w ?? 0) / 2) +
                screensize.width / 2;
        double y =
            (transformprop!.y ?? 0) + (compboxcollider!.y ?? 0) - ((compboxcollider!.h ?? 0) / 2) +
                screensize.height / 2;
        double w = compboxcollider!.w ?? 0;
        double h = compboxcollider!.h ?? 0;

        Vector2 touchpos =
            ((Vector2(details.localPosition.dx, details.localPosition.dy)));

        if (touchpos.x > x && touchpos.x < x + w) {
          if (touchpos.y > y && touchpos.y < y + h) {
            actioninitiator(eevents: Eevents.objecttouchmove);
          }
        }
      }
    }
  }

  void onbuttonevent(Buttonvalues buttonvalues) {
    // print(buttonvalues.variable + "                " + buttonvalues.event);
  }

  void onuijoystickdirectionchanged(Joystickvalues joystickvalues) {
    if (isdestroyed) return;
    //  this.body.applyLinearImpulse(Vector2(5000,50000),this.body.worldCenter + Vector2(-10,1), true);
    uijoystickvalues.update(
        joystickvalues.variable ?? "",
        (value) => {
              "angle": joystickvalues.angle,
              "distance": joystickvalues.distance,
              "valx": joystickvalues.valx,
              "valy": joystickvalues.valy
            },
        ifAbsent: () => {
              "angle": joystickvalues.angle,
              "distance": joystickvalues.distance,
              "valx": joystickvalues.valx,
              "valy": joystickvalues.valy
            });
    actioninitiator(
        eevents: Eevents.onjoystickdirectionchanged,
        variablename: joystickvalues.variable);
  }



  void destroyobject(
      Gameobject thegameobject2, String where, int thebodyindex) {
    // print(thegame)
    // if(isdestroyed) return;
    // destroy();
    // this.destroy();
    // this.body = null;
    // return;
    isdestroyed = true;

    // world!.destroyBody(this.body);
    // this.body.isActive = false;
    this.body.setAwake(false);
    // bComponent!.remove(this);

    if (where == "bodies" && bodyindex >= gameobjectitemscore.length) {
      // actionsinitiator.bodies.removeAt(bodyindex);
    }
    // bComponent!.bodies
    //     .removeWhere((key, value) => key == thegameobject2.bodyindex);
    if (where == "bcomponent" &&
        thegameobject2.bodyindex >= gameobjectitemscore.length) {
      // Future.delayed(Duration(seconds: 1),(){
      // bComponent!.bodies.removeAt(bodyindex);
      // });
      // bComponent!.bodies.remove(this);
      // print("  $objectname  b$bodyindex g$goindex       ${bComponent!.bodies.length}");
      // deletedobjects.add("$objectname$bodyindex");
      //  actionsinitiator.bodies.remove(thegameobject2);// = bComponent!.bodies;
      // for (int a = 0; a < bComponent!.bodies.length; a++) {
      //   if (thegameobject2.bodyindex == bodyindex) {
      // bComponent!.bodies[a].box.remove(this);

      //  print(thegameobject2.bodyindex);

      // bComponent!.bodies.remove(thet);
      bComponent!.bodies
          .removeWhere((key, value) => key == thegameobject2.bodyindex);

      // if (!thet.isdestroyed) {
      //   // thet.onupdate(t);
      // }

      //     print(bComponent!.bodies.length);
      //     break;
      //   }
      // }
      // bComponent!.bodies.remove(thegameobject2);

      // print(bodyindex);
    }
    // print("asdvcxvzxcvzxcvzxcv");
    // refreshfollowobjects(false);

    // destroy() is called implicitly by forge2d when body is removed;
    // no explicit destroy() call needed
    // this.body.destroyFixture(this.body.getFixtureList());
    // this.box.remove(this);
  }

  // destroy() and onDestroy() don't exist in BodyComponent in forge2d 0.9+
  // @override
  // bool destroy() {
  //   return super.destroy();
  // }

  // @override
  // void onDestroy() {
  //   super.onDestroy();
  // }

  void refreshfollowobjects(bool isonload) {
    followobjectindexs.clear();

    if (thescript == null) return;
    for (int asdf = 0; asdf < thescript!.components.length; asdf++) {
      Clsscriptitem t = thescript!.components[asdf];
      if (isonload) {
        if (t is Clscompstep) {
          stepindexs.add(asdf);
        }
      }

      if (t is Clsactfollowobject) {
        // print("asdfasdfasdf");
        // print(bComponent!.bodies.length);
        for (int a = 0; a < bComponent!.bodies.length; a++) {
          Gameobject thet = bComponent!.bodies.values.elementAt(a);

          if (thet.thegameobject?.name == t.objectname) {
            //  print(asdf);
            followobjectindexs.addAll({asdf: thet});
            break;
          }
        }
      }
    }
  }

  void onloaded() {
    if (isdestroyed) return;
    refreshfollowobjects(true);

    actioninitiator(eevents: Eevents.onobjectloaded);
    isloaded = true;
  }

  void actioninitiator({Eevents? eevents, String? variablename}) {
    actionsinitiator.initiateactions(
        goindex: goindex,
        // bodyindex: bodyindex,
        thegameobject: this,
        eevents: eevents,
        variablename: variablename);
  }

  @override
  void update(double t) {
    if (isdestroyed) return;

    if (isapplyingangular) {
      if (this.body.angularVelocity > 0) {
        if (-this.body.angle < anglelimit) {
          isapplyingangular = false;
          this.body.angularVelocity = 0;
          this.body.setTransform(this.body.position, -anglelimit);
        }
      }
      if (this.body.angularVelocity < 0) {
        if (-this.body.angle > anglelimit) {
          isapplyingangular = false;
          this.body.angularVelocity = 0;
          this.body.setTransform(this.body.position, -anglelimit);
        }
      }
    }

    if (isloaded) {
      actioninitiator(eevents: Eevents.step);

      if (istouchdown) {
        actioninitiator(eevents: Eevents.screentouchdowncontinuous);
      }

      var localSp = sp;
      if (localSp != null) {
        localSp.update(t);
        String? currentImg = localSp.getcurrentimagepath();
        if (currentImg != null && loadedimages.containsKey(currentImg)) {
           theimage = loadedimages[currentImg]!;
        }
      }
    }

    super.update(t);
  }

  @override
  void renderChain(Canvas canvas, List<Offset> points) {}

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    // if (!isimageresolved) {
    //   return;
    // }

    if (isdebug) {
      if (contactListener?.isnaa(objectname, this) ?? false) {
        final Paint paint = Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(center, radius, paint);
      } else {
        final Paint paint = Paint()
          ..color = Colors.lightBlueAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(center, radius, paint);
      }
    }

    canvas.save();
    canvas.translate(center.dx, center.dy);

    canvas.rotate(-this.body.angle);
    if (transformprop != null) {
      canvas.scale(transformprop!.sx ?? 1.0, transformprop!.sy ?? 1.0);
    }

    if (compsprite != null && thegameobject?.isactive == "true") {
      double w = (compsprite!.w ?? 0) * bComponent!.camera.viewfinder.zoom;
      double h = (compsprite!.h ?? 0) * bComponent!.camera.viewfinder.zoom;
      canvas.drawImageNine(
          theimage,
          Rect.fromCenter(center: Offset(0, 0), width: 0, height: 0),
          Rect.fromCenter(
              center: Offset(
                  -(gameobjectitemscore[goindex].getcirclecollider()?.x ?? 0) /
                      (transformprop!.sx ?? 1.0),
                  -(gameobjectitemscore[goindex].getcirclecollider()?.y ?? 0) /
                      (transformprop!.sy ?? 1.0)),
              width: w,
              height: h),
          Paint()
            ..color = Color.fromRGBO(0, 0, 0, compsprite!.opacity ?? 1.0)
            ..filterQuality = getimagequality());
    }

    if (comptext != null) {
      drawtext(canvas);
    }
    canvas.restore();
  }

  FilterQuality getimagequality() {
    if (getprojectsettingscore() == null) {
      return FilterQuality.low;
    }
    if (getprojectsettingscore()!.imagequality == "very low") {
      return FilterQuality.none;
    }
    if (getprojectsettingscore()!.imagequality == "low") {
      return FilterQuality.low;
    }
    if (getprojectsettingscore()!.imagequality == "medium") {
      return FilterQuality.medium;
    }
    if (getprojectsettingscore()!.imagequality == "high") {
      return FilterQuality.high;
    }
    return FilterQuality.none;
  }

  @override
  void renderPolygon(ui.Canvas canvas, List<ui.Offset> points) {
    canvas.save();

    canvas.translate(
        ((points[0].dx + points[2].dx + points[3].dx + points[1].dx) / 4),
        (points[0].dy + points[3].dy + points[2].dy + points[1].dy) / 4);

    canvas.rotate(-this.body.angle);
    if (transformprop != null) {
      canvas.scale(transformprop!.sx ?? 1.0, transformprop!.sy ?? 1.0);
    }
    // print(theimage);
    if (compsprite != null && thegameobject?.isactive == "true") {
      double w = (compsprite!.w ?? 0) * bComponent!.camera.viewfinder.zoom;
      double h = (compsprite!.h ?? 0) * bComponent!.camera.viewfinder.zoom;
      canvas.drawImageNine(
          theimage,
          Rect.fromCenter(center: Offset(0, 0), width: 0, height: 0),
          Rect.fromCenter(
              center: Offset(
                  -(gameobjectitemscore[goindex].getboxcollider()?.x ?? 0) /
                      (transformprop?.sx ?? 1.0) *
                      bComponent!.camera.viewfinder.zoom,
                  -(gameobjectitemscore[goindex].getboxcollider()?.y ?? 0) /
                      (transformprop?.sy ?? 1.0) *
                      bComponent!.camera.viewfinder.zoom),
              width: w,
              height: h),
          Paint()
            ..color = Color.fromRGBO(0, 0, 0, compsprite!.opacity ?? 1.0)
            ..filterQuality = getimagequality());
    }

    if (comptext != null) {
      drawtext(canvas);
    }
    canvas.restore();
    //  print(isdebug);
    if (isdebug) {
      final path = Path()..addPolygon(points, true);
      if (contactListener!.isnaa(objectname, this)) {
        final Paint paint = Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawPath(path, paint);
      } else {
        final Paint paint = Paint()
          ..color = Colors.lightBlueAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawPath(path, paint);
      }
    }

    if (complifebar != null) {
      canvas.save();
      canvas.translate(
          ((points[0].dx + points[2].dx + points[3].dx + points[1].dx) / 4),
          (points[0].dy + points[3].dy + points[2].dy + points[1].dy) / 4);
      drawlifebar(canvas);
      canvas.restore();
    }
  }

  @override
  void render(ui.Canvas canvas) {
    // print(isdestroyed);
    if (isdestroyed) return;

    try {
      if (gameobjectitemscore[goindex].getrigidbody() != null) {
        super.render(canvas);
        return;
      }
    } catch (error) {
      return;
    }

    canvas.save();
// print(getprojectsettingscore().appversion);
    if (getprojectsettingscore() != null &&
        (getprojectsettingscore()!.appversion ?? 0) >= 11) {
      canvas.translate(
          (this.body.position.x +
              (gameobjectitemscore[goindex].gettransform()?.x ?? 0) * bComponent!.camera.viewfinder.zoom +
              MediaQuery.of(context).size.width / 2),
          -this.body.position.y +
              (gameobjectitemscore[goindex].gettransform()?.y ?? 0) * bComponent!.camera.viewfinder.zoom +
              MediaQuery.of(context!).size.height / 2);
      if (transformprop != null) {
        canvas.rotate(transformprop!.angle ?? 0);
      }
    } else {
      canvas.translate(
          (this.body.position.x +
              (gameobjectitemscore[goindex].gettransform()?.x ?? 0) * bComponent!.camera.viewfinder.zoom +
              MediaQuery.of(context).size.width / 2),
          -this.body.position.y +
              (gameobjectitemscore[goindex].gettransform()?.y ?? 0) * bComponent!.camera.viewfinder.zoom +
              MediaQuery.of(context).size.height / 2);
      canvas.rotate(gameobjectitemscore[goindex].gettransform()?.angle ?? 0);
    }

    double w = 50;
    double h = 50;
    if (transformprop != null) {
      canvas.scale(transformprop!.sx ?? 1.0, transformprop!.sy ?? 1.0);
    }
    if (compsprite != null && thegameobject?.isactive == "true") {
      w = (compsprite!.w ?? 0) * bComponent!.camera.viewfinder.zoom;
      h = (compsprite!.h ?? 0) * bComponent!.camera.viewfinder.zoom;

      canvas.drawImageNine(
          theimage,
          Rect.fromCenter(center: Offset(0, 0), width: 0, height: 0),
          Rect.fromCenter(center: Offset(0, 0), width: w, height: h),
          Paint()
            ..color = Color.fromRGBO(0, 0, 0, compsprite!.opacity ?? 1.0)
            ..filterQuality = getimagequality());
    }

    if (comptext != null) {
      drawtext(canvas);
    }
    if (complifebar != null) {
      //  canvas.translate(
      //     (this.body.position.x +
      //         (gameobjectitemscore[goindex].gettransform().x) * bComponent!.camera.viewfinder.zoom +
      //         MediaQuery.of(context).size.width / 2),
      //     -this.body.position.y +
      //         (gameobjectitemscore[goindex].gettransform().y) * bComponent!.camera.viewfinder.zoom +
      //         MediaQuery.of(context).size.height / 2);
      //  canvas.save();
      drawlifebar(canvas);
      // canvas.restore();
    }
    canvas.restore();

    if (isdebug) {
      canvas.save();

      canvas.translate(
          (this.body.position.x +
              (gameobjectitemscore[goindex].gettransform()?.x ?? 0) * bComponent!.camera.viewfinder.zoom +
              MediaQuery.of(context).size.width / 2),
          -this.body.position.y +
              (gameobjectitemscore[goindex].gettransform()?.y ?? 0) * bComponent!.camera.viewfinder.zoom +
              MediaQuery.of(context).size.height / 2);
      if (getprojectsettingscore() != null) {
        if ((getprojectsettingscore()!.appversion ?? 0) >= 11) {
          if (transformprop != null) {
            canvas.rotate(transformprop!.angle ?? 0);
          }
        } else {
          canvas.rotate(gameobjectitemscore[goindex].gettransform()?.angle ?? 0);
        }
      } else {
        canvas.rotate(gameobjectitemscore[goindex].gettransform()?.angle ?? 0);
      }

      if (compboxcollider != null) {
        final path = Path()
          ..addRect(Rect.fromLTWH(
              -((compboxcollider!.w ?? 0) / 2) + (compboxcollider!.x ?? 0),
              -((compboxcollider!.h ?? 0) / 2) + (compboxcollider!.y ?? 0),
              compboxcollider!.w ?? 0,
              compboxcollider!.h ?? 0));

        final Paint paint = Paint()
          ..color = Colors.lightBlueAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawPath(path, paint);
      }
    }
    canvas.restore();
  }

  void drawlifebar(Canvas canvas) {
    if (complifebar == null) return;
    Paint bc = Paint()..color = Color(complifebar!.backgroundcolor ?? 0xFF000000);
    Paint fc = Paint()..color = Color(complifebar!.foregroundcolor ?? 0xFF00FF00);
    final zoom = bComponent!.camera.viewfinder.zoom;

    Rect therect = Rect.fromLTWH(
        (complifebar!.left ?? 0) * zoom,
        (complifebar!.top ?? 0) * zoom,
        (complifebar!.width ?? 0) * zoom,
        (complifebar!.height ?? 0) * zoom);
    Rect therect2;
    if (complifebar!.alignment == "left") {
      therect2 = Rect.fromLTWH(
          (complifebar!.left ?? 0) * zoom,
          (complifebar!.top ?? 0) * zoom,
          (complifebar!.width ?? 0) *
              zoom /
              (complifebar!.maxvalue ?? 1) *
              (complifebar!.thevalue ?? 0),
          (complifebar!.height ?? 0) * zoom);
    } else {
      therect2 = Rect.fromLTWH(
          (complifebar!.left ?? 0) +
              (complifebar!.width ?? 0) * zoom -
              ((complifebar!.width ?? 0) *
                  zoom /
                  (complifebar!.maxvalue ?? 1) *
                  (complifebar!.thevalue ?? 0)),
          complifebar!.top ?? 0,
          ((complifebar!.width ?? 0) *
              zoom /
              (complifebar!.maxvalue ?? 1) *
              (complifebar!.thevalue ?? 0)),
          (complifebar!.height ?? 0) * zoom);
    }

    canvas.drawRect(therect, bc);
    canvas.drawRect(therect2, fc);
  }

  void drawtext(Canvas canvas) {
    if (comptext == null) return;
    final zoom = bComponent!.camera.viewfinder.zoom;
    final textStyle = TextStyle(
      color: Color(comptext!.textcolor ?? 0xFF000000),
      fontFamily: comptext!.fontfamily,
      fontSize: (comptext!.fontsize ?? 12) * zoom,
      fontWeight: FontWeight.bold,
      // wordSpacing: 100*scale,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(0, 0),
          blurRadius: comptext!.blurradius ?? 0,
          color: Colors.black87,
        ),
      ],
    );

    final textSpan = TextSpan(
      text: comptext!.text ?? "",
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: (comptext!.width ?? 100) * zoom,
    );

    textPainter.paint(
        canvas,
        Offset(-(comptext!.width ?? 100) * zoom / 2,
            -(comptext!.height ?? 20) * zoom / 2));
  }

  void createRevolutejoint(Body a, Body b, Clscomprevolutejoint revolutejoint) {
    final revolutejointdef = RevoluteJointDef();
    revolutejointdef.bodyA = a;
    revolutejointdef.bodyB = b;
    revolutejointdef.localAnchorA
        .setFrom(Vector2(revolutejoint.mainx ?? 0, revolutejoint.mainy ?? 0));
    revolutejointdef.localAnchorB
        .setFrom(Vector2(revolutejoint.objectx ?? 0, revolutejoint.objecty ?? 0));

    // world!.createJoint(revolutejointdef); // Joint API differs in forge2d 0.9+
  }

  void createWheeljoint(Body a, Body b, Clscompwheeljoint wheeljoint) {
    final wheeljointdef = WheelJointDef();
    wheeljointdef.bodyA = a;
    wheeljointdef.bodyB = b;
    wheeljointdef.localAxisA.setFrom(Vector2(1, 1));
    // print(compboxcollider);
    wheeljointdef.localAnchorA.setFrom(Vector2(
        (wheeljoint.mainx ?? 0) - (compboxcollider?.x ?? 0),
        (wheeljoint.mainy ?? 0) + (compboxcollider?.y ?? 0)));
    wheeljointdef.localAnchorB
        .setFrom(Vector2(wheeljoint.objectx ?? 0, wheeljoint.objecty ?? 0));

    wheeljointdef.dampingRatio = wheeljoint.dampingRatio ?? 0.0;
    wheeljointdef.frequencyHz = wheeljoint.frequency ?? 0.0;

    // world!.createJoint(wheeljointdef); // Joint API differs in forge2d 0.9+
  }

  void createPrismaticJoint(Body a, Body b) {
    final pjdef = PrismaticJointDef();
    // pjdef.bodyA = a;
    // pjdef.bodyB = b;

    pjdef.initialize(a, b, Vector2(0, 0), Vector2(0, 0));
    // pjdef.bodyA = a;pjdef.bodyB=b;
    pjdef.lowerTranslation = 0;
    pjdef.upperTranslation = 0;
    pjdef.enableMotor = true;
    pjdef.motorSpeed = 20.5;
    pjdef.maxMotorForce = 10;
    // wheeljoint.type = JointType.WHEEL;
    // wheeljoint.dampingRatio =  0.1;
    // wheeljoint.frequencyHz = 3;

    // world!.createJoint(pjdef);
  }

  @override
  Body createBody() {
    var rb = gameobjectitemscore[goindex].getrigidbody();
    if (rb != null) {
      hasrigidbody = true;
      final bodyDef = BodyDef();
      Shape? shape;

      var trans = gameobjectitemscore[goindex].gettransform();
      double safeX = trans?.x ?? 0.0;
      double safeY = trans?.y ?? 0.0;
      double safeAngle = trans?.angle ?? 0.0;
      Offset thep = Offset(0, 0);

      var boxColl = gameobjectitemscore[goindex].getboxcollider();
      var circleColl = gameobjectitemscore[goindex].getcirclecollider();
      String? lastColl = gameobjectitemscore[goindex].getlastcollider();

      if (lastColl == "box" && boxColl != null) {
        final poly = PolygonShape();
        double x = (boxColl.x ?? 0) + safeX;
        double y = (boxColl.y ?? 0) + safeY;
        double bcw = (boxColl.w ?? 0) + 0.001;
        double bch = (boxColl.h ?? 0) + 0.001;

        thep = rotatepoint(safeX, safeY, safeAngle, Offset(x, y));
        poly.setAsBox(bcw / 2, bch / 2, Vector2(0, 0), 0);
        shape = poly;
      } else if (lastColl == "circle" && circleColl != null) {
        final circle = CircleShape();
        double x = (circleColl.x ?? 0) + safeX;
        double y = (circleColl.y ?? 0) + safeY;
        
        circle.radius = circleColl.radius ?? 0;
        thep = rotatepoint(safeX, safeY, safeAngle, Offset(x, y));
        shape = circle;
      }

      if (shape != null) {
        final fixtureDef = FixtureDef(shape); // Shape required in constructor

        if (comprigidbody?.issensor == true) {
          fixtureDef.isSensor = true;
        }

        bodyDef.position = Vector2(thep.dx, -thep.dy);
        bodyDef.angle = -safeAngle;

        var go = gameobjectitemscore[goindex].getgameobject();
        fixtureDef.userData = {
          "objectname": go?.name ?? "",
          "bodyindex": bodyindex
        };

        fixtureDef.restitution = rb.bounciness ?? 0.0;
        fixtureDef.friction = rb.friction ?? 0.0;

        if (rb.bodytype == "static") {
          bodyDef.type = BodyType.static;
        } else if (rb.bodytype == "dynamic") {
          bodyDef.type = BodyType.dynamic;
        } else if (rb.bodytype == "kinematic") {
          bodyDef.type = BodyType.kinematic;
        }

        bodyDef.fixedRotation = rb.fixedrotation ?? false;
        
        if (rb.density != null) {
           fixtureDef.density = rb.density!;
        }

        if (rb.gravityscale != null) {
           bodyDef.gravityScale = Vector2(rb.gravityscale!, rb.gravityscale!);
        }
        
        Body groundBody = world.createBody(bodyDef);
        groundBody.createFixture(fixtureDef);
        return groundBody;
      }
    }
    
    // Fallback
    final bodyDef = BodyDef();
    Body groundBody = world.createBody(bodyDef);
    return groundBody;
  }
}

class BComponent extends Forge2DGame {
  BuildContext context;
  BComponent(this.context, {this.isdebug = false}) : super(zoom: 1.0);
  Map<int, Gameobject> bodies = Map();
  bool isdebug = false;
  // String wheretoadd="";
  // Map<int, Gameobject> toaddtouchdown = Map();

  int indexforcamerafollow = -1;
  Clscompcameracontroller? cameracontroller = cameragetcameracontrollercore();
  Gameobject? tofollow;
  @override
  Future<void> onLoad() async {
    isbanneradshowing = false;
    cameracontroller = cameragetcameracontrollercore();
    // print("asdfasdfasdfasdfasdfasdfasdf");
    objectcounters = 10000;
    currentcamerasettings = Cameraproperties(0, 0, 1);
    actionsinitiator = Actionsinitiator(
        box2d: this, context: this.context, world: world);

    // print("inited");
    for (int a = 0; a < gameobjectitemscore.length; a++) {
      // if (gameobjectitemscore[a].getgameobject().isactive != "false") {
      Gameobject temp = Gameobject(this, context, a, objectcounters,
          gameobjectitemscore[a].getgameobject()?.name ?? "",
          isdebug: isdebug);

      temp.priority = (gameobjectitemscore[a].getgameobject()?.priority ?? 0);

      bodies.addAll({gameobjectitemscore[a].getgameobject()?.theid ?? objectcounters: temp});

      add(temp);

      objectcounters++;

      // actionsinitiator.bodies = bodies;
      // }
    }

    // for (int a = 0; a < gameobjectitemscore.length; a++) {
    //   for (int b = 0; b < gameobjectitemscore[a].components.length; b++) {
    //     Clscomponent t = gameobjectitemscore[a].components[b];
    //     if (t is Clscomprevolutejoint) {
    //       for (int c = 0; c < bodies.length; c++) {
    //         if (bodies[c].objectname == t.object) {
    //           bodies[a].createRevolutejoint(bodies[a].body, bodies[c].body, t);
    //           break;
    //         }
    //       }
    //     }
    //     if (t is Clscompwheeljoint) {
    //       for (int c = 0; c < bodies.length; c++) {
    //         if (bodies[c].objectname == t.object) {
    //           bodies[a].createWheeljoint(bodies[a].body, bodies[c].body, t);
    //           break;
    //         }
    //       }
    //     }
    //   }
    // }

    for (int a = 0; a < bodies.length; a++) {
      Gameobject theta = bodies.values.elementAt(a);
      for (int b = 0;
          b < gameobjectitemscore[theta.goindex].components.length;
          b++) {
        Clscomponent t = gameobjectitemscore[theta.goindex].components[b];
        if (t is Clscomprevolutejoint) {
          for (int c = 0; c < bodies.length; c++) {
            Gameobject thetc = bodies.values.elementAt(c);
            if (thetc.objectname == t.object) {
              theta.createRevolutejoint(theta.body, thetc.body, t);
              break;
            }
          }
        }
        if (t is Clscompwheeljoint) {
          // print(t);
          for (int c = 0; c < bodies.length; c++) {
            Gameobject thetc = bodies.values.elementAt(c);
            if (thetc.objectname == t.object) {
              theta.createWheeljoint(theta.body, thetc.body, t);
              break;
            }
          }
        }
      }
    }

    for (int a = 0; a < bodies.length; a++) {
      Gameobject thet = bodies.values.elementAt(a);

      thet.onloaded();
    }

    // bodies.forEach((key, value) {
    //   value.onloaded();
    // });

    for (int a = 0; a < bodies.length; a++) {
      Gameobject thet = bodies.values.elementAt(a);

      if (cameracontroller != null &&
          cameracontroller!.objecttofollow ==
              gameobjectitemscore[thet.goindex].getgameobject()?.name) {
        tofollow = thet;

        // cameraFollow(thet,
        //     horizontal: cameracontroller.h, vertical: cameracontroller.v);
        // isnaaycamerafollow = true;
        break;
      }
    }

    // for (int a = 0; a < bodies.length; a++) {
    //   // for(int b=0;b<bodies[a].)
    //   // if (bodies[a].objectname == "body") {
    //   //   //  print("asdfasdf");
    //   //   // bodies[a].createRevolutejoints(bodies[a].body, bodies[0].body);
    //   //   // bodies[a].createRevolutejoints2(bodies[a].body, bodies[1].body);
    //   // }
    //   bodies[a].onloaded();
    // }

    // print(bodies.length);
    contactListener = MyContactListener();
    // world!.setContactListener(contactListener!);
  }

  @override
  void onGameResize(v32.Vector2 size) {
    screensize = Size(size.x, size.y);
    // print(screensize);

    super.onGameResize(size);
  }

  @override
  void update(double t) {
    // if(isloadedna==false) return;
    super.update(t);
    deltatime = t;

    // Camera update is handled by Flame's camera system, but if we need manual control:
    // ...

//  bodies.forEach((key, value) {
//       if (!value.isdestroyed) {
//         if (cameracontroller.objecttofollow ==
//             gameobjectitemscore[value.goindex].getgameobject().name) {
//           // indexforcamerafollow = key;
//           // tofollow = value;

//           cameraFollow(value,
//           horizontal: cameracontroller.h, vertical: cameracontroller.v);
//         }
//       }
//     });
    // print(tofollow.thegameobject.theid);
    if (tofollow != null && cameracontroller != null) {
      cameraFollow(tofollow!,
          horizontal: cameracontroller!.h, vertical: cameracontroller!.v);
    }
    // try {
    // bool nakitanna = false;

    // for (int a = 0; a < bodies.length; a++) {
    //   if (!bodies[a].isdestroyed) {
    //     bodies[a].onupdate(t);
    //   }
    // }

    // Iterable x = bodies.values;

    // for (int a = x.length - 1; a >= 0; a--) {
    //   Gameobject y = x.elementAt(a);

    //   if (!y.isdestroyed) {
    //     y.onupdate(t);
    //   }
    // }

    // bodies.forEach((key, value) {
    //   if (!value.isdestroyed) {
    //     value.onupdate(t);
    //   }
    // });

    // for (int a = 0; a < bodies.length; a++) {
    //   Gameobject thet = bodies.values.elementAt(a);
    //   if (!thet.isdestroyed) {
    //     thet.onupdate(t);
    //   }
    // }

    //   } catch (error) {}
    //   // if (isnaaycamerafollow == false) {
    //   //   // viewport.setCamera(currentcamerasettings.x, currentcamerasettings.y, 1);
    //   //   // print(currentcamerasettings.x);
    //   // }
  }

  @override
  void render(ui.Canvas canvas) {
    super.render(canvas);
  }

  void ontouchdown(PointerDownEvent details) {
    // if(isloadedna==false) return;

    touchmovelocation = screenToWorld(
        Vector2(details.localPosition.dx, details.localPosition.dy));
    // touchmovelocationphysical = details.localPosition; // Already set above
    touchdownlocationphysical = details.localPosition; // Fixed order here logic update
    
    touchdownlocation = screenToWorld(
        Vector2(details.localPosition.dx, details.localPosition.dy));
    touchmovelocationphysical = details.localPosition;

// Iterator<Gameobject> it = bodies.values.iterator;

// while(it.moveNext()){
//   it.current.ontouchdown(details);
// }

    for (int a = 0; a < bodies.length; a++) {
      Gameobject thet = bodies.values.elementAt(a);
      if (!thet.isdestroyed) {
        thet.ontouchdown(details);
      }
    }

    // bodies.forEach((key, value) {
    //   value.ontouchdown(details);
    // });

    // if (toaddtouchdown.length > 0) {
    //   bodies.addEntries(toaddtouchdown.entries);
    //   toaddtouchdown.clear();
    // }
    // print(bodies.length);
    // for(var k in bodies.values){
    //   k.ontouchdown(details);
    // }
    // for (int a = 0; a < bodies.keys.length; a++) {
    //   bodies[bodies.keys].ontouchdown(details);
    // }

    // Iterable t = bodies.values;

    // for (int a = t.length - 1; a >= 0; a--) {
    //   Gameobject y = t.elementAt(a);
    //   y.ontouchdown(details);
    // }
  }

  void ontouchup(PointerUpEvent details) {
    touchuplocationphysical = details.localPosition;
    touchuplocation = screenToWorld(
        Vector2(details.localPosition.dx, details.localPosition.dy));

    // bodies.forEach((key, value) {
    //   value.ontouchup(details);
    // });
    // for (int a = 0; a < bodies.length; a++) {
    //   // print("asdfasdf");
    //   bodies[a].ontouchup(details);
    // }
    for (int a = 0; a < bodies.length; a++) {
      Gameobject thet = bodies.values.elementAt(a);
      if (!thet.isdestroyed) {
        thet.ontouchup(details);
      }
    }
  }

  void ontouchmove(PointerMoveEvent details) {
    touchmovelocation = screenToWorld(
        Vector2(details.localPosition.dx, details.localPosition.dy));

    touchmovelocationphysical = details.localPosition;

    for (int a = 0; a < bodies.length; a++) {
      Gameobject thet = bodies.values.elementAt(a);
      if (!thet.isdestroyed) {
        thet.ontouchmove(details);
      }
    }
    // bodies.forEach((key, value) {
    //   value.ontouchmove(details);
    // });
    // for (int a = 0; a < bodies.length; a++) {
    //   bodies[a].ontouchmove(details);
    // }
  }

  void onjoystickdirectionchanged(Joystickvalues joystickvalues) {
    // bodies.forEach((key, value) {
    //   value.onuijoystickdirectionchanged(joystickvalues);
    // });
    for (int a = 0; a < bodies.length; a++) {
      Gameobject thet = bodies.values.elementAt(a);
      if (!thet.isdestroyed) {
        thet.onuijoystickdirectionchanged(joystickvalues);
      }
    }
    // for (int a = 0; a < bodies.length; a++) {
    //   bodies[a].onuijoystickdirectionchanged(joystickvalues);
    // }
  }

  void cameraFollow(Gameobject objecttofollow,
      {double horizontal = 0.5, double vertical = 0.5}) {
    // camera.followComponent(objecttofollow,
    //     worldShowArea: Rect.fromLTWH(horizontal, vertical, 0, 0)); // Approx mapping?
    // // standard follow:
    // // camera.followComponent(objecttofollow);
  }

  void onbuttonevent(Buttonvalues buttonvalues) {
    // bodies.forEach((key, value) {
    //   value.onbuttonevent(buttonvalues);
    // });
    for (int a = 0; a < bodies.length; a++) {
      Gameobject thet = bodies.values.elementAt(a);
      if (!thet.isdestroyed) {
        thet.onbuttonevent(buttonvalues);
      }
    }
    // for (int a = 0; a < bodies.length; a++) {
    //   bodies[a].onbuttonevent(buttonvalues);
    // }
  }
}

Offset rotatepoint(double cx, double cy, double angle, Offset p) {
  return Offset(
      math.cos(angle) * (p.dx - cx) - math.sin(angle) * (p.dy - cy) + cx,
      math.sin(angle) * (p.dx - cx) + math.cos(angle) * (p.dy - cy) + cy);
}
