import 'package:flutter_gradient_generator/data/app_typedefs.dart';

class ColorAndStopUtil {
  /// The minimum number of colors that can be showned on the [GeneratorSection]
  final minimumNumberOfColors = 2;

  /// Returns whether the [colorAndStopList] is more than the minimum number of
  /// colors that can be showned on the [GeneratorSection]
  bool isColorAndStopListMoreThanMinimum(List<ColorAndStop> colorAndStopList) {
    return colorAndStopList.length > minimumNumberOfColors;
  }
}
