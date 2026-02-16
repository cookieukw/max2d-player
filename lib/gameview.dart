import 'dart:math';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';

// import 'flame2/lib/effects/effects.dart';
// import 'package:flame/effects/move_effect.dart';
import 'package:flame/components/component.dart';
import 'actions.dart';
import 'compandactvariables.dart';
import 'globalvars.dart';

class Gameview extends BaseGame {
  BuildContext context;
  bool isdebug;
  bool recordFps() => true;

  Gameview(this.context, {this.isdebug = false}) {
    initialize();
    bComponent = BComponent(context, isdebug: isdebug);

    if (bComponent == null) return;
    bComponent!.initializeWorld();

    uicomponents.forEach((f) {
      if (f is Clsuijoystickdirectional) {
        bComponent!.onjoystickdirectionchanged(
            Joystickvalues(0, 0, 0, 0, f.variablename));
      }
    });

    // Future.delayed(Duration(seconds: 5), () {
    //   bComponent = null;
    // });

    if (isdebug) {
      //
    }

    // MoveEffect(destination: null, speed: null)

    gameisdebug = isdebug;
  }

  @override
  bool debugMode() {
    // TODO: implement debugMode
    return super.debugMode();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
  }

  @override
  void render(Canvas canvas) {
    // print(cameragetcameracontroller().backgroundcolor);
    // return;
    double themargin = 20;
    if (bComponent == null) return;
    if (cameragetcameracontrollercore() == null ||
        getprojectsettingscore() == null) return;

    canvas.drawRect(
        Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
        Paint()
          ..color = cameragetcameracontrollercore()!.backgroundcolor != null
              ? Color(cameragetcameracontrollercore()!.backgroundcolor)
              : Colors.blueGrey);

    super.render(canvas);

    // print(camera_getcameracontroller().backgroundcolor);

    bComponent!.render(canvas);

    if (isdebug) {
      drawtext(canvas, "fps: " + fps(1).toStringAsFixed(0), themargin);

      if (getprojectsettingscore()!.usingmicrophone == true) {
        themargin = themargin + 20;
        drawtext(canvas, "microphone dblevel: $miclevel", themargin);
      }
      if (getprojectsettingscore()!.usinggyroscope == true) {
        themargin = themargin + 20;
        drawtext(
            canvas,
            "gyroscope x=${(gyroscopevalue.x ?? 0).toStringAsFixed(1)}, y=${(gyroscopevalue.y ?? 0).toStringAsFixed(1)}, z=${(gyroscopevalue.z ?? 0).toStringAsFixed(1)}",
            themargin);
      }
      if (getprojectsettingscore()!.usingaccelerometer == true) {
        themargin = themargin + 20;
        drawtext(
            canvas,
            "accelerometer x=${(accelerometervalue.x ?? 0).toStringAsFixed(1)}, y=${(accelerometervalue.y ?? 0).toStringAsFixed(1)}, z=${(accelerometervalue.z ?? 0).toStringAsFixed(1)}",
            themargin);
      }
      int b = 0;
      for (int a = 0; a < globalvariablescore.length; a++) {
        Clsvariable t = globalvariablescore[a];
        if (t is Clsvariablenumber) {
          if (t.showdebug == null || t.showdebug == true) {
            drawtext(canvas, "${t.name}: ${t.value}",
                (themargin * 1) + (20 * (b + 1)).toDouble());
            b++;
          }
        }
        if (t is Clsvariableboolean) {
          if (t.showdebug == null || t.showdebug == true) {
            drawtext(canvas, "${t.name}: ${t.value}",
                (themargin * 1) + (20 * (b + 1)).toDouble());
            b++;
          }
        }
        if (t is Clsvariabletext) {
          if (t.showdebug == null || t.showdebug == true) {
            drawtext(canvas, "${t.name}: ${t.value}",
                (themargin * 1) + (20 * (b + 1)).toDouble());
            b++;
          }
        }
      }

      bComponent!.bodies.forEach((key, value) {
        // print(key);
        for (int a = 0; a < value.thescript.localvariables.length; a++) {
          if (value.isdestroyed == false) {
            Clsvariable t = value.thescript.localvariables[a];
            if (t is Clsvariablenumber) {
              if (t.showdebug == null || t.showdebug == true) {
                drawtext(canvas, "${t.name}: ${t.value}",
                    (themargin * 1) + (20 * (b + 1)).toDouble());
                b++;
              }
            }
            if (t is Clsvariableboolean) {
              if (t.showdebug == null || t.showdebug == true) {
                drawtext(canvas, "${t.name}: ${t.value}",
                    (themargin * 1) + (20 * (b + 1)).toDouble());
                b++;
              }
            }
            if (t is Clsvariabletext) {
              if (t.showdebug == null || t.showdebug == true) {
                drawtext(canvas, "${t.name}: ${t.value}",
                    (themargin * 1) + (20 * (b + 1)).toDouble());
                b++;
              }
            }
          }
        }
      });
    }
  }

  void drawtext(Canvas canvas, String text, double top) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(0, 0),
          blurRadius: 10,
          color: Colors.black,
        ),
      ],
    );

    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 1000,
    );

    textPainter.paint(canvas, Offset(10, top));
  }

  @override
  void onAttach() {
    // TODO: implement onAttach

    super.onAttach();
  }

  @override
  void onDetach() {
    // TODO: implement onDetach
    if (actionsinitiator != null) {
      actionsinitiator.destroytimers();
    }

    super.onDetach();
  }

  @override
  void update(double t) {
    super.update(t);
    if (bComponent == null) return;

    bComponent!.update(t);
  }

  @override
  void resize(Size size) {
    if (bComponent == null) return;

    bComponent!.resize(size);
  }

  void onTouchDown(PointerDownEvent details) {
    if (bComponent == null) return;
    bComponent!.ontouchdown(details);
  }

  void onTouchUp(PointerUpEvent details) {
    if (bComponent == null) return;
    bComponent!.ontouchup(details);
  }

  void onTouchMove(PointerMoveEvent details) {
    if (bComponent == null) return;
    bComponent!.ontouchmove(details);
  }

  void onJoystickDirectionChanged(Joystickvalues joystickvalues) {
    if (bComponent == null) return;
    bComponent!.onjoystickdirectionchanged(joystickvalues);
  }

  void onButtonEvent(Buttonvalues buttonvalues) {
    if (bComponent == null) return;
    print(buttonvalues);
    bComponent!.onbuttonevent(buttonvalues);
  }
}
