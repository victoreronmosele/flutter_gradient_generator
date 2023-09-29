import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/models/gradient_factory.dart';
import 'package:flutter_gradient_generator/models/linear_style_gradient.dart';
import 'package:flutter_gradient_generator/models/radial_style_gradient.dart';
import 'package:test/test.dart';

void main() {
  test(
      'GradientFactory returns the right AbstractGradient object given a GradientStyle',
      () {
    final List<ColorAndStop> colorAndStopList = [
      (color: const Color(0xFF921E1E), stop: 0),
      (color: const Color(0xFF0A951F), stop: 100),
    ];

    const GradientDirection gradientDirection = GradientDirection.topLeft;

    final Map<GradientStyle, AbstractGradient>
        gradientStyleToAbstractGradientMap = {
      GradientStyle.linear: LinearStyleGradient(
          colorAndStopList: colorAndStopList,
          gradientDirection: gradientDirection),
      GradientStyle.radial: RadialStyleGradient(
          colorAndStopList: colorAndStopList,
          gradientDirection: gradientDirection)
    };

    gradientStyleToAbstractGradientMap.forEach(
        (GradientStyle gradientStyle, AbstractGradient abstractGradient) {
      final AbstractGradient actualAbstractGradient = GradientFactory()
          .getGradient(
              gradientStyle: gradientStyle,
              colorAndStopList: colorAndStopList,
              gradientDirection: gradientDirection);
      final AbstractGradient expectedAbstractGradient = abstractGradient;

      expect(actualAbstractGradient, expectedAbstractGradient);
    });
  });
}
