import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';

/// A 2D gradient.
///
/// This is an abstract class that allows holds information about a gradient.
/// This information include:
///   - Color
///   - Style
///   - String representation
///   - Flutter Gradient representation
///
abstract class AbstractGradient {
  AbstractGradient(
      {required List<Color> colorList,
      required GradientDirection gradientDirection})
      : _colorList = colorList,
        _gradientDirection = gradientDirection;

  ///Holds the list of colors in the gradient
  List<Color> _colorList;

  ///Holds the direction of the gradient
  GradientDirection _gradientDirection;

  /// Returns the list of Colors in the gradient
  List<Color> getColorList() => _colorList;

  ///Returns teh direction of the gradient
  GradientDirection getGradientDirection() => _gradientDirection;

  GradientStyle getGradientStyle();

  /// Returns a [String] representation of the Gradient
  String toWidgetString();

  /// Returns a [Gradient] from Flutter's painting library
  Gradient toFlutterGradient();
}
