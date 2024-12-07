import 'package:bubble_pop_adventure/src/components/pop_effect.dart';
import 'package:bubble_pop_adventure/src/game/bubble_game.dart';
import 'package:bubble_pop_adventure/src/utils/colors.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class BubbleBody extends BodyComponent with TapCallbacks {
  @override
  final Vector2 position;
  final int colorIndex;
  final bool isSpecial;
  final double radius;
  bool isPopped = false;

  BubbleBody({
    required this.position,
    required this.colorIndex,
    required this.isSpecial,
    required this.radius,
  });

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: position,
      type: BodyType.dynamic,
      userData: this,
      angularDamping: 0.8,
      linearDamping: 0.8,
    );

    final shape = CircleShape()..radius = radius;

    final fixtureDef = FixtureDef(
      shape,
      density: 0.5,
      friction: 0.2,
      restitution: 0.8,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!isPopped && (game as BubbleGame).canPopBubble(colorIndex)) {
      pop();
      checkNeighbors();
    }
  }

  void pop() {
    isPopped = true;
    game.world.add(PopEffect(position: body.position));
    game.world.remove(this);
    (game as BubbleGame).incrementScore(isSpecial ? 200 : 100);
    (game as BubbleGame).bubblePopped(isSpecial);
  }

  void checkNeighbors() {
    final neighbors = <BubbleBody>[];

    for (var contact in body.contacts) {
      final other = contact.bodyA.userData == this
          ? contact.bodyB.userData
          : contact.bodyA.userData;

      if (other is BubbleBody &&
          other.colorIndex == colorIndex &&
          !other.isPopped) {
        neighbors.add(other);
      }
    }

    for (var neighbor in neighbors) {
      neighbor.pop();
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = getBubbleColor(colorIndex)
      ..style = PaintingStyle.fill;

    if (isSpecial) {
      paint.shader = RadialGradient(
        colors: [getBubbleColor(colorIndex), Colors.white],
      ).createShader(Rect.fromCircle(
        center: Offset.zero,
        radius: radius,
      ));
    }

    canvas.drawCircle(Offset.zero, radius, paint);
  }
}
