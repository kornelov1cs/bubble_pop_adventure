import 'package:hive/hive.dart';

part 'level_progress.g.dart';

@HiveType(typeId: 0)
class LevelProgress extends HiveObject {
  @HiveField(0)
  final int levelId;

  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  int? highScore;

  LevelProgress(
      {required this.levelId, this.isCompleted = false, this.highScore});
}
