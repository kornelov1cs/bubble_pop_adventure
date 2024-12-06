import 'package:bubble_pop_adventure/src/models/level.dart';
import 'package:bubble_pop_adventure/src/screens/game_screen.dart';
import 'package:bubble_pop_adventure/src/screens/level_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultScreen extends StatelessWidget {
  final bool success;
  final int score;
  final int levelId;

  const ResultScreen({
    super.key,
    required this.success,
    required this.score,
    required this.levelId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: success
                ? [Colors.green[700]!, Colors.green[300]!]
                : [Colors.red[700]!, Colors.red[300]!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                success ? 'Level Complete!' : 'Level Failed',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black26,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Score: $score',
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black26,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Retry level
                      Get.off(() => GameScreen(
                            level: Level.levels.firstWhere(
                              (l) => l.id == levelId,
                            ),
                          ));
                    },
                    child: const Text('Retry Level'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () =>
                        Get.offAll(() => const LevelSelectScreen()),
                    child: const Text('Level Select'),
                  ),
                  if (success && levelId < Level.levels.length)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          // Go to next level
                          final nextLevel = Level.levels.firstWhere(
                            (l) => l.id == levelId + 1,
                          );
                          Get.off(() => GameScreen(level: nextLevel));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Next Level'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
