import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../game/bubble_game.dart';

class ColorSelector extends StatelessWidget {
  final BubbleGame game;

  const ColorSelector({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          game.currentLevel.minColors,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ValueListenableBuilder<int>(
              valueListenable: game.selectedColorIndex,
              builder: (context, selectedIndex, child) {
                final isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () => game.selectColor(index),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: getBubbleColor(index),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
