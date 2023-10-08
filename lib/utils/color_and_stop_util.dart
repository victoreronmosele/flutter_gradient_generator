import 'dart:ui';

import 'package:flutter_gradient_generator/data/app_typedefs.dart';

/// [ColorAndStopUtil] is a utility class that provides methods and properties
/// for working with [ColorAndStop]s.
///
class ColorAndStopUtil {
  /// The minimum number of [ColorAndStop]s that can be showned on the [GeneratorSection]
  final _minimumNumberOfColorAndStops = 2;

  /// Returns whether the [colorAndStopList] is more than the minimum number of
  /// colors that can be showned on the [GeneratorSection]
  bool isColorAndStopListMoreThanMinimum(List<ColorAndStop> colorAndStopList) {
    return colorAndStopList.length > _minimumNumberOfColorAndStops;
  }

  /// Converts the [color] to a hex string.
  ///
  /// Example:
  /// ```dart
  /// Color color = Color(0xFFFF5733); // Color in ARGB format
  /// String hexColor = colorToHex(color); // hexColor will be '#FF5733'
  /// ```
  String colorToHex(Color color) {
    /// The [color] is converted to a hex string and the first two characters
    /// representing the alpha value of the color (which is not needed) are
    /// discarded.
    final hex = color.value.toRadixString(16).substring(2);

    /// Returns the hex string, preceded by a '#' to denote a color in hex format.
    return '#$hex';
  }

  /// Converts the [hex] string to a [Color].
  ///
  /// Example:
  /// ```dart
  /// String hexColor = '#FF5733';
  /// Color color = hexToColor(hexColor); // color will be Color(0xFFFF5733)
  /// ```
  Color hexToColor(String hex) {
    /// The hex string is converted to an integer.
    final int hexColor = int.parse('0xff${hex.substring(1)}');

    /// The integer is converted to a color.
    return Color(hexColor);
  }
}
