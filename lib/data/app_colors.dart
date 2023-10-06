import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';

class AppColors {
  static final Color grey = Colors.grey.shade200;
  static const Color darkGrey = Color(0xff3d4853);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  /// Returns the initial list of [ColorAndStop]s that can be showned on the [GeneratorSection]
  static List<ColorAndStop> get initialColorAndStopList {
    return [
      (color: const Color(0xffFC466B), stop: 0),
      (color: const Color(0xff3F5EFB), stop: 100)
    ];
  }
}
