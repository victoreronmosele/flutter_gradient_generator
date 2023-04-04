import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';

/// A 2D gradient.
///
/// This is an abstract class that allows holds information about a gradient.
/// This information include:
///   - Colors
///   - Stops
///   - Direction
///   - Style
///   - String representation
///   - Flutter Gradient representation
///
abstract class AbstractGradient {
  AbstractGradient({
    required List<Color> colorList,
    required List<int> stopList,
    required GradientDirection gradientDirection,
  })  : _colorList = colorList,
        _stopList = stopList,
        _gradientDirection = gradientDirection;

  ///Holds the list of colors in the gradient
  final List<Color> _colorList;

  /// Holds the stops of the gradient
  final List<int> _stopList;

  ///Holds the direction of the gradient
  final GradientDirection _gradientDirection;

  /// Returns the list of Colors in the gradient
  List<Color> getColorList() => _colorList;

  /// Returns the stops of the gradient
  List<int> getStopList() => _stopList;

  /// Returns the stops of the gradient
  ///
  /// The stops are divided by 100 to convert them to a double between 0 and 1
  /// This is done because the stop inputs are integers between 0 and 100
  List<double> getStopListForFlutterCode() =>
      _stopList.map((stop) => stop / 100).toList();

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
      'colorList': _colorList.map((e) => e.toString()).toList().toString(),
      'gradientStyle': getGradientStyle().toString(),
      'gradientDirection': getGradientDirection().toString(),
      'generatedCode': toWidgetString(),
      'stops': _stopList.toString(),
    };
  }
}
