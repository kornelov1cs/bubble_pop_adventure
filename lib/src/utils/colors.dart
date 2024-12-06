import 'package:flutter/material.dart';

Color getBubbleColor(int index) {
  final colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];
  return colors[index % colors.length];
}
