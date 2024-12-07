import 'dart:math';
import 'package:bubble_pop_adventure/src/services/level_progress_service.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/level.dart';
import '../components/bubble_body.dart';
import '../components/game_bounds.dart';
import '../components/background_component.dart';

class BubbleGame extends Forge2DGame {
  final Level currentLevel;
  late final Vector2 gameSize;
  final LevelProgressService _progressService = LevelProgressService();

  // Observable values
  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<double> timeLeft = ValueNotifier(0.0);
  final ValueNotifier<int> selectedColorIndex = ValueNotifier(-1);

  // Game state
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

    // Initialize game area
    final rect = camera.visibleWorldRect;
    gameSize = Vector2(rect.width, rect.height);

    // Add game components
    world.add(GameBounds());
    world.add(BackgroundComponent());

    // Initialize time if level has time limit
    if (currentLevel.timeLimit != null) {
      timeLeft.value = currentLevel.timeLimit!.inSeconds.toDouble();
    }

    // Spawn initial bubbles and select first color
    spawnBubbles();
    selectRandomColor();
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

  void selectRandomColor() {
    List<int> availableColors = [];

    // Check which colors are still available
    for (int i = 0; i < currentLevel.minColors; i++) {
      if (hasColoredBubblesLeft(i)) {
        availableColors.add(i);
      }
    }

    if (availableColors.isEmpty) {
      // No more moves possible
      endGame(score.value >= currentLevel.targetScore);
      return;
    }

    // Select random available color
    selectedColorIndex.value =
        availableColors[random.nextInt(availableColors.length)];
  }

  bool hasColoredBubblesLeft(int colorIndex) {
    return world.children.whereType<BubbleBody>().any(
          (bubble) => !bubble.isPopped && bubble.colorIndex == colorIndex,
        );
  }

  void incrementScore(int amount) {
    score.value += amount;
    if (score.value >= currentLevel.targetScore) {
      endGame(true);
    }
  }

  bool canPopBubble(int bubbleColorIndex) {
    return !gameFinished && selectedColorIndex.value == bubbleColorIndex;
  }

  void bubblePopped(bool isSpecial) {
    incrementScore(isSpecial ? 200 : 100);
    selectRandomColor();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Handle time limit
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

      if (success) {
        _progressService.markLevelCompleted(currentLevel.id, score.value);
      }

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

  void pauseGame() {
    pauseEngine();
  }

  void resumeGame() {
    resumeEngine();
  }
}
