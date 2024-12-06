class Level {
  final int id;
  final int gridSize;
  final int minColors;
  final int targetScore;
  final Duration? timeLimit;
  final bool hasSpecialBubbles;

  Level({
    required this.id,
    required this.gridSize,
    required this.minColors,
    required this.targetScore,
    this.timeLimit,
    this.hasSpecialBubbles = false,
  });

  static List<Level> get levels => [
        Level(
          id: 1,
          gridSize: 6,
          minColors: 3,
          targetScore: 1000,
          timeLimit: null,
          hasSpecialBubbles: false,
        ),
        Level(
          id: 2,
          gridSize: 7,
          minColors: 4,
          targetScore: 2000,
          timeLimit: const Duration(minutes: 2),
          hasSpecialBubbles: false,
        ),
        Level(
          id: 3,
          gridSize: 8,
          minColors: 5,
          targetScore: 3000,
          timeLimit: const Duration(minutes: 1, seconds: 30),
          hasSpecialBubbles: true,
        ),
      ];
}
