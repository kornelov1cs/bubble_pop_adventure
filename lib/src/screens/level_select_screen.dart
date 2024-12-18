import 'package:bubble_pop_adventure/src/models/level.dart';
import 'package:bubble_pop_adventure/src/screens/game_screen.dart';
import 'package:bubble_pop_adventure/src/services/level_progress_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  _LevelSelectScreenState createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  final LevelProgressService _progressService = LevelProgressService();

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[700]!,
              Colors.blue[200]!,
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isSmallScreen ? 1 : 2,
                childAspectRatio: isSmallScreen ? 2 : 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: Level.levels.length,
              itemBuilder: (context, index) {
                final level = Level.levels[index];
                return LevelCard(
                  level: level,
                  isCompleted: _progressService.isLevelCompleted(level.id),
                  highScore: _progressService.getLevelHighScore(level.id),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LevelCard extends StatelessWidget {
  final Level level;
  final bool isCompleted;
  final int? highScore;

  const LevelCard({
    super.key,
    required this.level,
    this.isCompleted = false,
    this.highScore,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Get.to(() => GameScreen(level: level)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isSmallScreen
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Level ${level.id}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Target: ${level.targetScore}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (highScore != null)
                          Text(
                            'High Score: $highScore',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.green),
                          ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (level.timeLimit != null)
                          Text(
                            '${level.timeLimit!.inMinutes}:${(level.timeLimit!.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        if (isCompleted)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 30,
                          ),
                      ],
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Level ${level.id}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Target: ${level.targetScore}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (level.timeLimit != null)
                      Text(
                        '${level.timeLimit!.inMinutes}:${(level.timeLimit!.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    if (highScore != null)
                      Text(
                        'High Score: $highScore',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.green),
                      ),
                    if (isCompleted)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 30,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
