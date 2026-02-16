
import 'package:flutter/material.dart';

import 'gestures.dart';

/// Model of one padd button.
class PadButtonItem {
  /// [index] required parameter, the key to recognize button instance.
  final int index;

  /// [buttonText] optional parameter, the text to be displayed inside the
  /// button. Omitted if [buttonImage] is set. Default value is empty string.
  final String? buttonText;
  final Image? buttonImage;
  final Icon? buttonIcon;
  final Color backgroundColor;
  final Color pressedColor;
  final List<Gestures> supportedGestures;

  const PadButtonItem({
    required this.index,
    this.buttonText,
    this.buttonImage,
    this.buttonIcon,
    this.backgroundColor = Colors.white54,
    this.pressedColor = Colors.lightBlueAccent,
    this.supportedGestures = const [Gestures.TAP],
  });
}
