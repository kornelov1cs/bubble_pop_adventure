import 'package:hive_flutter/hive_flutter.dart';
import '../models/level_progress.dart';

class LevelProgressService {
  static const _boxName = 'levelProgressBox';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(LevelProgressAdapter());
    await Hive.openBox<LevelProgress>(_boxName);
  }

  Future<void> markLevelCompleted(int levelId, int score) async {
    final box = Hive.box<LevelProgress>(_boxName);

    // Get or create progress for this level
    var progress = box.values.firstWhere((p) => p.levelId == levelId,
        orElse: () => LevelProgress(levelId: levelId));

    // Update completion status
    progress.isCompleted = true;

    // Update high score if needed
    if (progress.highScore == null || score > progress.highScore!) {
      progress.highScore = score;
    }

    // Save the progress
    await box.put(levelId.toString(), progress);
  }

  bool isLevelCompleted(int levelId) {
    final box = Hive.box<LevelProgress>(_boxName);
    final progress = box.get(levelId.toString());
    return progress?.isCompleted ?? false;
  }

  int? getLevelHighScore(int levelId) {
    final box = Hive.box<LevelProgress>(_boxName);
    final progress = box.get(levelId.toString());
    return progress?.highScore;
  }
}
