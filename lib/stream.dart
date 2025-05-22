import 'package:flutter/material.dart';
import 'dart:async';

class ColorStream {
  final List<Color> colors = [
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepPurpleAccent,
    Colors.orangeAccent,
    Colors.pinkAccent,
  ];

  Stream<Color> get getColors async* {
    yield* Stream.periodic(const Duration(seconds: 1), (int t) {
      int index = t % colors.length;
      return colors[index];
    });
  }
}