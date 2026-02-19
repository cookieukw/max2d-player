import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

import './effects.dart';

class RotateEffect extends PositionComponentEffect {
  double radians;
  double speed;
  Curve? curve;

  late double _originalAngle;
  late double _peakAngle;
  late double _direction;

  RotateEffect({
    required this.radians, // As many radians as you want to rotate
    required this.speed, // In radians per second
    this.curve,
    bool isInfinite = false,
    bool isAlternating = false,
    VoidCallback? onComplete,
  }) : super(isInfinite, isAlternating, onComplete: onComplete);

  @override
  void initialize(_comp) {
    super.initialize(_comp);
    if (!isAlternating) {
      endAngle = _comp.angle + radians;
    }
    _originalAngle = component.angle;
    _peakAngle = _originalAngle + radians;
    _direction = _peakAngle.sign;
    travelTime = (radians / speed).abs();
  }

  @override
  void update(double dt) {
    super.update(dt);
    final double c = curve?.transform(percentage!) ?? 1.0;
    component.angle = _originalAngle + _peakAngle * c * _direction;
  }
}
