import 'package:get/get.dart';
import '../screens/start_screen.dart';
import '../screens/level_select_screen.dart';
import '../screens/game_screen.dart';
import '../screens/result_screen.dart';
import '../models/level.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => const StartScreen(),
    ),
    GetPage(
      name: '/levels',
      page: () => const LevelSelectScreen(),
    ),
    GetPage(
      name: '/game',
      page: () {
        final level = Get.arguments as Level;
        return GameScreen(level: level);
      },
    ),
    GetPage(
      name: '/result',
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return ResultScreen(
          success: args['success'] as bool,
          score: args['score'] as int,
          levelId: args['levelId'] as int,
        );
      },
    ),
  ];
}
