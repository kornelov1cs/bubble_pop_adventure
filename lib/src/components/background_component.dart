import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BackgroundBubble {
  Vector2 position;
  double size;
  double speed;
  double amplitude;
  double time = 0;

  BackgroundBubble({
    required this.position,
    required this.size,
    required this.speed,
    required this.amplitude,
  });

  void update(double dt, Rect bounds) {
    time += dt;

    // Create floating motion using sine wave
    position.x = position.x + sin(time * speed) * amplitude * dt;
    position.y -= speed * dt;

    // Wrap around when bubble goes off screen
    if (position.y < bounds.top - size) {
      position.y = bounds.bottom + size;
      position.x = bounds.left + Random().nextDouble() * bounds.width;
    }
    if (position.x < bounds.left - size) {
      position.x = bounds.right + size;
    }
    if (position.x > bounds.right + size) {
      position.x = bounds.left - size;
    }
  }
}

class BackgroundComponent extends Component with HasGameRef {
  final random = Random();
  final List<BackgroundBubble> bubbles = [];
  static const int bubbleCount = 20;

  @override
  Future<void> onLoad() async {
    final rect = gameRef.camera.visibleWorldRect;

    // Initialize background bubbles
    for (int i = 0; i < bubbleCount; i++) {
      bubbles.add(
        BackgroundBubble(
          position: Vector2(
            rect.left + random.nextDouble() * rect.width,
            rect.top + random.nextDouble() * rect.height,
          ),
          size: 2 + random.nextDouble() * 4, // Random size between 2 and 6
          speed: 2 + random.nextDouble() * 3, // Random speed between 2 and 5
          amplitude:
              0.5 + random.nextDouble(), // Random amplitude between 0.5 and 1.5
        ),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    final rect = gameRef.camera.visibleWorldRect;

    // Draw gradient background
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blue[900]!,
        Colors.blue[300]!,
      ],
    );

    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );

    // Draw animated background bubbles
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (final bubble in bubbles) {
      canvas.drawCircle(
        bubble.position.toOffset(),
        bubble.size,
        paint,
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final rect = gameRef.camera.visibleWorldRect;

    // Update bubble positions
    for (final bubble in bubbles) {
      bubble.update(dt, rect);
    }
  }
}
