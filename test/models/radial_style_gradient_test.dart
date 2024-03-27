import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/radial_style_gradient.dart';
import 'package:test/test.dart';

import 'matchers.dart';

void main() {
  group('RadialStyleGradient', () {
    late final List<ColorAndStop> colorAndStopList;
    late final RadialStyleGradient radialStyleGradient;

    setUpAll(() {
      colorAndStopList = [
        (color: const Color(0xFF921E1E), stop: 0),
        (color: const Color(0xFF0A951F), stop: 100),
      ];

      radialStyleGradient = RadialStyleGradient(
          colorAndStopList: colorAndStopList,
          gradientDirection: GradientDirection.topLeft);
    });

    test('.toWidgetString() returns the correct widget string', () {
      final actualWidgetString = radialStyleGradient.toWidgetString();
      final expectedWidgetString = '''RadialGradient(
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
        final RadialStyleGradient testRadialStyleGradient = RadialStyleGradient(
            colorAndStopList: colorAndStopList,
            gradientDirection: gradientDirection);

        final Alignment actualAlignment =
            testRadialStyleGradient.centerAlignment;
        final Alignment expectedAlignment = alignment;

        expect(actualAlignment, expectedAlignment);
      });
    });

    test('.getGradientStyle() returns GradientStyle.radial', () {
      final GradientStyle actualGradientStyle =
          radialStyleGradient.getGradientStyle();
      const GradientStyle expectedGradientStyle = GradientStyle.radial;

      expect(actualGradientStyle, expectedGradientStyle);
    });

    test(
        'getFlutterGradientConverter() returns the right FlutterGradientConverter',
        () {
      final actualFlutterGradientConverter =
          radialStyleGradient.getFlutterGradientConverter();

      // ignore: prefer_function_declarations_over_variables
      final expectedFlutterGradientConverter = (
              {required List<Color> colors, List<double>? stops}) =>
          RadialGradient(
            colors: colors,
            stops: stops,
            center: Alignment.topLeft,
          );

      final colorsForValidation =
          colorAndStopList.map((colorAndStop) => colorAndStop.color).toList();

      final stopsForValidation = colorAndStopList
          .map((colorAndStop) => colorAndStop.stop / 100)
          .toList();

      expect(
          actualFlutterGradientConverter,
          flutterGradientConverterEquals(
            expectedFlutterGradientConverter,
            colors: colorsForValidation,
            stops: stopsForValidation,
          ));
    });
  });
}
