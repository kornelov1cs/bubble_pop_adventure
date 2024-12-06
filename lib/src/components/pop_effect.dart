import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PopEffect extends Component {
  final Vector2 position;
  double size = 0;
  final double maxSize;
  static const duration = 0.3;
  double timePassed = 0;

  PopEffect({
    required this.position,
    this.maxSize = 2.0,
  });

  @override
  void update(double dt) {
    timePassed += dt;
    size = maxSize * (timePassed / duration);

    if (timePassed >= duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(1 - (timePassed / duration))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.2;

    canvas.drawCircle(
      Offset.zero,
      size,
      paint,
    );
  }
}
