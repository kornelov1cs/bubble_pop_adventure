import 'package:bubble_pop_adventure/src/models/level.dart';
import 'package:bubble_pop_adventure/src/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: Level.levels.length,
              itemBuilder: (context, index) {
                final level = Level.levels[index];
                return LevelCard(level: level);
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

  const LevelCard({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Get.to(() => GameScreen(level: level)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
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
                'Target: ${level.targetScore} points',
                style: const TextStyle(fontSize: 16),
              ),
              if (level.timeLimit != null)
                Text(
                  'Time: ${level.timeLimit!.inMinutes}:${(level.timeLimit!.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
