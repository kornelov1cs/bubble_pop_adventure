import 'package:bubble_pop_adventure/src/services/level_progress_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'src/routes/app_routes.dart';
import 'src/screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Initialize level progress service
  final levelProgressService = LevelProgressService();
  await levelProgressService.init();

  runApp(const GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bubble Pop Adventure',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      getPages: AppRoutes.routes,
      home: const StartScreen(),
    );
  }
}
