import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/level.dart';
import '../components/bubble_body.dart';
import '../components/game_bounds.dart';
import '../components/background_component.dart';

class BubbleGame extends Forge2DGame {
  final Level currentLevel;
  late final Vector2 gameSize;
  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<double> timeLeft = ValueNotifier(0.0);
  var gameFinished = false;
  final random = Random();

  BubbleGame(this.currentLevel)
      : super(
          gravity:
              Vector2(0, -1.0), // Slight upward gravity for floating effect
          camera: CameraComponent.withFixedResolution(
            width: 800,
            height: 600,
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final rect = camera.visibleWorldRect;
    gameSize = Vector2(rect.width, rect.height);

    // Add boundaries
    world.add(GameBounds());

    // Add background
    world.add(BackgroundComponent());

    // Add initial bubbles
    spawnBubbles();

    // Set initial time for timed levels
    if (currentLevel.timeLimit != null) {
      timeLeft.value = currentLevel.timeLimit!.inSeconds.toDouble();
    }
  }

  void incrementScore(int amount) {
    score.value += amount;
    if (score.value >= currentLevel.targetScore) {
      endGame(true);
    }
  }

  void spawnBubbles() {
    final gridSize = currentLevel.gridSize;
    final spacing = gameSize.x / (gridSize + 1);

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        final position = Vector2(
          (col + 1) * spacing - gameSize.x / 2,
          (row + 1) * spacing - gameSize.y / 2,
        );

        final colorIndex = random.nextInt(currentLevel.minColors);
        final isSpecial =
            currentLevel.hasSpecialBubbles && random.nextDouble() < 0.1;

        world.add(BubbleBody(
          position: position,
          colorIndex: colorIndex,
          isSpecial: isSpecial,
          radius: spacing * 0.4,
        ));
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (currentLevel.timeLimit != null && !gameFinished) {
      timeLeft.value -= dt;
      if (timeLeft.value <= 0) {
        endGame(false);
      }
    }
  }

  void endGame(bool success) {
    if (!gameFinished) {
      gameFinished = true;
      Get.toNamed(
        '/result',
        arguments: {
          'success': success,
          'score': score.value,
          'levelId': currentLevel.id,
        },
      );
    }
  }
}
