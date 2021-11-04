import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/abstract_random_color_generator.dart';
import 'dart:math';

class RandomColorGenerator implements AbstractRandomColorGenerator {
  const RandomColorGenerator();

  @override
  List<Color> getTwoRandomColors() {
    final List<Color> colorList = Colors.primaries;
    final int colorListLength = colorList.length;

    final Random random = Random();

    final int firstIndex = random.nextInt(colorListLength);
    final int secondIndex = random.nextInt(colorListLength);

    final Color firstRandomColor = colorList.elementAt(firstIndex);
    final Color secondRandomColor = colorList.elementAt(secondIndex);

    final List<Color> randomColors = [firstRandomColor, secondRandomColor];

    return randomColors;
  }
}
