import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/sweep_style_gradient.dart';
import 'package:test/test.dart';

import 'matchers.dart';

void main() {
  group('SweepStyleGradient', () {
    late final List<ColorAndStop> colorAndStopList;
    late final SweepStyleGradient sweepStyleGradient;

    setUpAll(() {
      colorAndStopList = [
        (color: const Color(0xFF921E1E), stop: 0),
        (color: const Color(0xFF0A951F), stop: 100),
      ];

      sweepStyleGradient = SweepStyleGradient(
          colorAndStopList: colorAndStopList,
          gradientDirection: GradientDirection.topLeft);
    });

    test('.toWidgetString() returns the correct widget string', () {
      final actualWidgetString = sweepStyleGradient.toWidgetString();
      final expectedWidgetString = '''SweepGradient(
          colors: ${colorAndStopList.map((colorAndStop) => colorAndStop.color).toList()},
          stops: ${colorAndStopList.map((colorAndStop) => colorAndStop.stop / 100).toList()},
          center: ${Alignment.topLeft},
        )
      ''';

      expect(actualWidgetString.replaceAll(' ', ''),
          expectedWidgetString.replaceAll(' ', ''));
    });

    test('.centerAlignment returns the right Alignment enum', () {
      final Map<GradientDirection, Alignment>
          gradientDirectionToCenterAlignmentMap = {
        GradientDirection.topLeft: Alignment.topLeft,
        GradientDirection.topCenter: Alignment.topCenter,
        GradientDirection.topRight: Alignment.topRight,
        GradientDirection.centerLeft: Alignment.centerLeft,
        GradientDirection.center: Alignment.center,
        GradientDirection.centerRight: Alignment.centerRight,
        GradientDirection.bottomLeft: Alignment.bottomLeft,
        GradientDirection.bottomCenter: Alignment.bottomCenter,
        GradientDirection.bottomRight: Alignment.bottomRight,
        const GradientDirectionCustom(alignment: Alignment(-0.5, 0)):
            const Alignment(-0.5, 0),
      };

      gradientDirectionToCenterAlignmentMap
          .forEach((GradientDirection gradientDirection, Alignment alignment) {
        final SweepStyleGradient testSweepStyleGradient = SweepStyleGradient(
            colorAndStopList: colorAndStopList,
            gradientDirection: gradientDirection);

        final Alignment actualCenterAlignment =
            testSweepStyleGradient.centerAlignment;
        final Alignment expectedCenterAlignment = alignment;

        expect(actualCenterAlignment, expectedCenterAlignment);
      });
    });

    test('.getGradientStyle() returns GradientStyle.sweep', () {
      final GradientStyle actualGradientStyle =
          sweepStyleGradient.getGradientStyle();
      const GradientStyle expectedGradientStyle = GradientStyle.sweep;

      expect(actualGradientStyle, expectedGradientStyle);
    });

    test(
        '.getFlutterGradientConverter() returns the right FlutterGradientConverter object',
        () {
      final FlutterGradientConverter actualFlutterGradientConverter =
          sweepStyleGradient.getFlutterGradientConverter();
      // ignore: prefer_function_declarations_over_variables
      final FlutterGradientConverter expectedFlutterGradientConverter =
          ({required List<Color> colors, List<double>? stops}) => SweepGradient(
                colors: colors,
                center: Alignment.topLeft,
                stops: stops,
              );

      final colorsForValidation =
          colorAndStopList.map((colorAndStop) => colorAndStop.color).toList();

      final stopsForValidation = colorAndStopList
          .map((colorAndStop) => colorAndStop.stop / 100)
          .toList();

      expect(
        actualFlutterGradientConverter,
        flutterGradientConverterEquals(expectedFlutterGradientConverter,
            colors: colorsForValidation, stops: stopsForValidation),
      );
    });
  });
}
