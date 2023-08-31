import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/models/linear_style_gradient.dart';
import 'package:flutter_gradient_generator/models/radial_style_gradient.dart';
import 'package:flutter_gradient_generator/models/sweep_style_gradient.dart';

class GradientFactory {
  AbstractGradient getGradient(
      {required GradientStyle gradientStyle,
      required List<ColorAndStop> colorAndStopList,
      required GradientDirection gradientDirection}) {
    /// Sort the list by stop value
    colorAndStopList.sort((a, b) => a.stop.compareTo(b.stop));

    AbstractGradient gradient;

    switch (gradientStyle) {
      case GradientStyle.linear:
        gradient = LinearStyleGradient(
            colorAndStopList: colorAndStopList,
            gradientDirection: gradientDirection);
        break;
      case GradientStyle.radial:
        gradient = RadialStyleGradient(
            colorAndStopList: colorAndStopList,
            gradientDirection: gradientDirection);
        break;

      case GradientStyle.sweep:
        gradient = SweepStyleGradient(
            colorAndStopList: colorAndStopList,
            gradientDirection: gradientDirection);
        break;
    }

    return gradient;
  }
}
