import 'package:bubble_pop_adventure/src/game/bubble_game.dart';
import 'package:bubble_pop_adventure/src/utils/colors.dart';
import 'package:flutter/material.dart';

class ColorIndicator extends StatelessWidget {
  final BubbleGame game;

  const ColorIndicator({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: game.selectedColorIndex,
      builder: (context, selectedIndex, child) {
        if (selectedIndex < 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pop This Color',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: getBubbleColor(selectedIndex),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: getBubbleColor(selectedIndex).withOpacity(0.6),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
