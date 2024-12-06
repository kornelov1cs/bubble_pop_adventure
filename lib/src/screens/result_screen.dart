import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/level.dart';

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
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Result Icon
                Icon(
                  success ? Icons.stars_rounded : Icons.replay_rounded,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                // Title
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
                // Score Container
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Score',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$score',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(
                        icon: Icons.replay,
                        label: 'Retry',
                        onPressed: () => Get.offAllNamed(
                          '/game',
                          arguments: Level.levels.firstWhere(
                            (l) => l.id == levelId,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildButton(
                        icon: Icons.grid_view,
                        label: 'Levels',
                        onPressed: () => Get.offAllNamed('/levels'),
                      ),
                      if (success && levelId < Level.levels.length)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: _buildButton(
                            icon: Icons.arrow_forward,
                            label: 'Next',
                            onPressed: () {
                              final nextLevel = Level.levels.firstWhere(
                                (l) => l.id == levelId + 1,
                              );
                              Get.offAllNamed('/game', arguments: nextLevel);
                            },
                            color: Colors.green,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.white24,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
