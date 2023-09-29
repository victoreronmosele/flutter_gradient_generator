import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';

/// A 2D gradient.
///
/// This is an abstract class that allows holds information about a gradient.
/// This information include:
///   - [ColorAndStop]s
///   - Direction
///   - Style
///   - String representation
///   - Flutter Gradient representation
///
abstract class AbstractGradient {
  AbstractGradient({
    required List<ColorAndStop> colorAndStopList,
    required GradientDirection gradientDirection,
  })  : _colorAndStopList = colorAndStopList,
        _gradientDirection = gradientDirection;

  ///Holds the list of [ColorAndStop]s in the gradient
  final List<ColorAndStop> _colorAndStopList;

  ///Holds the direction of the gradient
  final GradientDirection _gradientDirection;

  /// Returns the list of Colors in the gradient
  List<Color> getColorList() =>
      _colorAndStopList.map((colorAndStop) => colorAndStop.color).toList();

  /// Returns the stops of the gradient
  List<int> getStopList() =>
      _colorAndStopList.map((colorAndStop) => colorAndStop.stop).toList();

  /// Returns the list of [ColorAndStop]s in the gradient
  List<ColorAndStop> getColorAndStopList() => _colorAndStopList;

  /// Returns the stops of the gradient
  ///
  /// The stops are divided by 100 to convert them to a double between 0 and 1
  /// This is done because the stop inputs are integers between 0 and 100
  List<double> getStopListForFlutterCode() =>
      getStopList().map((stop) => stop / 100).toList();

  ///Returns the direction of the gradient
  GradientDirection getGradientDirection() => _gradientDirection;

  /// Returns the style of the gradient
  GradientStyle getGradientStyle();

  /// Returns a [String] representation of the Gradient
  String toWidgetString();

  /// Returns a [Gradient] from Flutter's painting library
  ///
  /// This should use the [getColorList] and [getStopListForFlutterCode] methods
  /// for the colors and stops respectively
  Gradient toFlutterGradient();

  Map<String, String> toJson() {
    return {
      'colorList': getColorList().map((e) => e.toString()).toList().toString(),
      'gradientStyle': getGradientStyle().toString(),
      'gradientDirection': getGradientDirection().toString(),
      'generatedCode': toWidgetString(),
      'stops': getStopList().toString(),
    };
  }
}
