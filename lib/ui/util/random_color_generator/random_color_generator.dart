import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/abstract_random_color_generator.dart';
import 'dart:math';

class RandomColorGenerator implements AbstractRandomColorGenerator {
  const RandomColorGenerator();

  @override
  List<ColorAndStop> getTwoRandomColorsAndStops() {
    final List<Color> colorList =
        Colors.primaries.map((color) => color.shade500).toList();
    final int colorListLength = colorList.length;

    final Random random = Random();

    final int firstIndex = random.nextInt(colorListLength);
    final int secondIndex = random.nextInt(colorListLength);

    final Color firstRandomColor = colorList.elementAt(firstIndex);
    final Color secondRandomColor = colorList.elementAt(secondIndex);

    const int firstStop = 0;
    const int secondStop = 50;

    final List<ColorAndStop> randomColorsAndStops = [
      (color: firstRandomColor, stop: firstStop),
      (color: secondRandomColor, stop: secondStop),
    ];

    return randomColorsAndStops;
  }
}
