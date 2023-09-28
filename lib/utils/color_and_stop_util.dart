import 'package:flutter_gradient_generator/data/app_typedefs.dart';

/// [ColorAndStopUtil] is a utility class that provides methods and properties
/// for working with [ColorAndStop]s.
///
class ColorAndStopUtil {
  /// The minimum number of [ColorAndStop]s that can be showned on the [GeneratorSection]
  final _minimumNumberOfColorAndStops = 2;

  /// Returns the initial list of [Stop]s that can be showned on the [GeneratorSection]
  List<Stop> get initialStopList {
    return _generateStopList(
      lengthOfColorAndStopList: _minimumNumberOfColorAndStops,
    );
  }

  /// Returns whether the [colorAndStopList] is more than the minimum number of
  /// colors that can be showned on the [GeneratorSection]
  bool isColorAndStopListMoreThanMinimum(List<ColorAndStop> colorAndStopList) {
    return colorAndStopList.length > _minimumNumberOfColorAndStops;
  }

  /// Returns a list of [Stop]s based on the length of the [colorAndStopList].
  List<Stop> _generateStopList({
    required int lengthOfColorAndStopList,
  }) {
    /// This represents the interval at which each color's stop position
    /// is calculated in the gradient.
    ///
    /// The '~/'' operator is used to discard the fractional part of the
    /// result of the division.
    final stopInterval = 100 ~/ lengthOfColorAndStopList;

    final List<Stop> stopList = List.generate(
        lengthOfColorAndStopList, (index) => index * stopInterval);

    return stopList;
  }
}
