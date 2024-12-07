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
    final game = BubbleGame(level);

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen game area
          GameWidget<BubbleGame>(
            game: game,
            loadingBuilder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          // Floating top bar that ignores touch events
          IgnorePointer(
            child: TopGameBar(game: game),
          ),
          // Touch-sensitive pause button in top-right corner
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: IconButton(
              onPressed: () => _showPauseMenu(context, game),
              icon: const Icon(
                Icons.pause_circle,
                color: Colors.white,
                size: 32,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopGameBar extends StatelessWidget {
  final BubbleGame game;

  const TopGameBar({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 12,
        right: 12,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Score display
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 8 : 12,
                  vertical: isSmallScreen ? 4 : 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ValueListenableBuilder<int>(
                  valueListenable: game.score,
                  builder: (context, score, child) {
                    return Text(
                      'Score: $score',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    );
                  },
                ),
              ),
              if (game.currentLevel.timeLimit != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 12,
                    vertical: isSmallScreen ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ValueListenableBuilder<double>(
                    valueListenable: game.timeLeft,
                    builder: (context, timeLeft, child) {
                      final minutes = (timeLeft ~/ 60);
                      final seconds = (timeLeft % 60).toInt();
                      return Text(
                        '$minutes:${seconds.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(width: 48), // Space for pause button
            ],
          ),
          const SizedBox(height: 4),
          ValueListenableBuilder<int>(
            valueListenable: game.score,
            builder: (context, score, child) {
              final progress = score / game.currentLevel.targetScore;
              return Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress >= 1.0 ? Colors.green : Colors.blue,
                        ),
                        minHeight: isSmallScreen ? 4 : 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 10 : 12,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 50,
            child: ColorIndicator(game: game),
          ),
        ],
      ),
    );
  }
}

void _showPauseMenu(BuildContext context, BubbleGame game) {
  game.pauseEngine();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: Card(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Game Paused',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
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
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
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
