import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/models/linear_style_gradient.dart';
import 'package:flutter_gradient_generator/models/radial_style_gradient.dart';

class GradientFactory {
  AbstractGradient getGradient(
      {required GradientStyle gradientStyle,
      required List<Color> colorList,
      required List<int> stopList,
      required GradientDirection gradientDirection}) {
    AbstractGradient gradient;

    switch (gradientStyle) {
      case GradientStyle.linear:
        gradient = LinearStyleGradient(
            colorList: colorList,
            stopList: stopList,
            gradientDirection: gradientDirection);
        break;
      case GradientStyle.radial:
        gradient = RadialStyleGradient(
            colorList: colorList,
            stopList: stopList,
            gradientDirection: gradientDirection);
        break;
    }

    return gradient;
  }
}
