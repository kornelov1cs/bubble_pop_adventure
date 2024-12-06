import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'src/routes/app_routes.dart';
import 'src/screens/start_screen.dart';

void main() {
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
