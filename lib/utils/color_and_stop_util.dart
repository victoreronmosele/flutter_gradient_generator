import 'package:flutter_gradient_generator/data/app_typedefs.dart';

class ColorAndStopUtil {
  /// The minimum number of [ColorAndStop]s that can be showned on the [GeneratorSection]
  final _minimumNumberOfColorAndStops = 2;

  /// Returns the initial number of [ColorAndStop]s that can be showned on the [GeneratorSection]
  int get initialNumberOfColorAndStops => _minimumNumberOfColorAndStops;

  /// Returns whether the [colorAndStopList] is more than the minimum number of
  /// colors that can be showned on the [GeneratorSection]
  bool isColorAndStopListMoreThanMinimum(List<ColorAndStop> colorAndStopList) {
    return colorAndStopList.length > _minimumNumberOfColorAndStops;
  }
}
