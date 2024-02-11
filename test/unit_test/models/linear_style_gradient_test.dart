import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/linear_style_gradient.dart';
import 'package:test/test.dart';

import '../matchers.dart';

void main() {
  group('LinearStyleGradient', () {
    late final List<ColorAndStop> colorAndStopList;
    late final LinearStyleGradient linearStyleGradient;

    setUpAll(() {
      colorAndStopList = [
        (color: const Color(0xFF921E1E), stop: 0),
        (color: const Color(0xFF0A951F), stop: 100),
      ];

      linearStyleGradient = LinearStyleGradient(
          colorAndStopList: colorAndStopList,
          gradientDirection: GradientDirection.topLeft);
    });

    test('.toWidgetString() returns the correct widget string', () {
      final actualWidgetString = linearStyleGradient.toWidgetString();
      final expectedWidgetString = '''LinearGradient(
          colors: ${colorAndStopList.map((colorAndStop) => colorAndStop.color).toList()},
          stops: ${colorAndStopList.map((colorAndStop) => colorAndStop.stop / 100).toList()},
          begin: ${Alignment.topLeft},
          end: ${Alignment.bottomRight},
        )
      ''';

      expect(actualWidgetString.replaceAll(' ', ''),
          expectedWidgetString.replaceAll(' ', ''));
    });

    test('.beginAlignment returns the right Alignment enum', () {
      final Map<GradientDirection, Alignment>
          gradientDirectionToBeginAlignmentMap = {
        GradientDirection.topLeft: Alignment.topLeft,
        GradientDirection.topCenter: Alignment.topCenter,
        GradientDirection.topRight: Alignment.topRight,
        GradientDirection.centerLeft: Alignment.centerLeft,
        GradientDirection.center: Alignment.center,
        GradientDirection.centerRight: Alignment.centerRight,
        GradientDirection.bottomLeft: Alignment.bottomLeft,
        GradientDirection.bottomCenter: Alignment.bottomCenter,
        GradientDirection.bottomRight: Alignment.bottomRight,
      };

      gradientDirectionToBeginAlignmentMap
          .forEach((GradientDirection gradientDirection, Alignment alignment) {
        final LinearStyleGradient testLinearStyleGradient = LinearStyleGradient(
            colorAndStopList: colorAndStopList,
            gradientDirection: gradientDirection);

        final Alignment actualAlignment =
            testLinearStyleGradient.beginAlignment;
        final Alignment expectedAlignment = alignment;

        expect(actualAlignment, expectedAlignment);
      });
    });

    test('.endAlignment returns the right Alignment enum', () {
      final Map<GradientDirection, Alignment>
          gradientDirectionToEndAlignmentMap = {
        GradientDirection.topLeft: Alignment.bottomRight,
        GradientDirection.topCenter: Alignment.bottomCenter,
        GradientDirection.topRight: Alignment.bottomLeft,
        GradientDirection.centerLeft: Alignment.centerRight,
        GradientDirection.center: Alignment.center,
        GradientDirection.centerRight: Alignment.centerLeft,
        GradientDirection.bottomLeft: Alignment.topRight,
        GradientDirection.bottomCenter: Alignment.topCenter,
        GradientDirection.bottomRight: Alignment.topLeft,
      };

      gradientDirectionToEndAlignmentMap
          .forEach((GradientDirection gradientDirection, Alignment alignment) {
        final LinearStyleGradient testLinearStyleGradient = LinearStyleGradient(
            colorAndStopList: colorAndStopList,
            gradientDirection: gradientDirection);

        final Alignment actualAlignment = testLinearStyleGradient.endAlignment;
        final Alignment expectedAlignment = alignment;

        expect(actualAlignment, expectedAlignment);
      });
    });

    test('.getGradientStyle() returns GradientStyle.linear', () {
      final GradientStyle actualGradientStyle =
          linearStyleGradient.getGradientStyle();
      const GradientStyle expectedGradientStyle = GradientStyle.linear;

      expect(actualGradientStyle, expectedGradientStyle);
    });

    test(
        '.getFlutterGradientConverter() returns the right FlutterGradientConverter object',
        () {
      final actualFlutterGradientConverter =
          linearStyleGradient.getFlutterGradientConverter();
      // ignore: prefer_function_declarations_over_variables
      final expectedFlutterGradientConverter = (
              {required List<Color> colors, List<double>? stops}) =>
          LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: stops,
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
        ),
      );
    });
  });
}
