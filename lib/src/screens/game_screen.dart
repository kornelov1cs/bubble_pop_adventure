import 'package:bubble_pop_adventure/src/components/color_indicator.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../game/bubble_game.dart';
import '../models/level.dart';
import 'level_select_screen.dart';

class GameScreen extends StatelessWidget {
  final Level level;

  const GameScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<BubbleGame>(
        game: BubbleGame(level),
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        overlayBuilderMap: {
          'gameUI': (context, game) => GameOverlay(game: game),
        },
        initialActiveOverlays: const ['gameUI'],
      ),
    );
  }
}

class GameOverlay extends StatelessWidget {
  final BubbleGame game;

  const GameOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Spacer(flex: 3), // Game area space
          // Side panel with indicators
          Container(
            width: 200, // Fixed width for side panel
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Score display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ValueListenableBuilder<int>(
                    valueListenable: game.score,
                    builder: (context, score, child) {
                      return Text(
                        'Score: $score',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Time display (if level has time limit)
                if (game.currentLevel.timeLimit != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ValueListenableBuilder<double>(
                      valueListenable: game.timeLeft,
                      builder: (context, timeLeft, child) {
                        final minutes = (timeLeft ~/ 60);
                        final seconds = (timeLeft % 60).toInt();
                        return Text(
                          '$minutes:${seconds.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // Pause button
                IconButton(
                  onPressed: () => _showPauseMenu(context),
                  icon: const Icon(
                    Icons.pause_circle,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const Spacer(flex: 1),
                // Color Indicator
                ColorIndicator(game: game),
                const Spacer(flex: 2),
                // Level progress
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ValueListenableBuilder<int>(
                    valueListenable: game.score,
                    builder: (context, score, child) {
                      final progress = score / game.currentLevel.targetScore;
                      return Column(
                        children: [
                          Text(
                            'Target: ${game.currentLevel.targetScore}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: LinearProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              backgroundColor: Colors.white24,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress >= 1.0 ? Colors.green : Colors.blue,
                              ),
                              minHeight: 10,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPauseMenu(BuildContext context) {
    game.pauseEngine();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Game Paused',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        game.resumeEngine();
                      },
                      child: const Text('Resume'),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.offAll(() => const LevelSelectScreen());
                      },
                      child: const Text('Exit Level'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
