import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/linear_style_gradient.dart';
import 'package:test/test.dart';

void main() {
  group('LinearStyleGradient', () {
    late final List<Color> colorList;
    late final List<int> stopList;
    late final LinearStyleGradient linearStyleGradient;

    setUpAll(() {
      colorList = [
        const Color(0xFF921E1E),
        const Color(0xFF0A951F),
      ];

      stopList = [0, 100];

      linearStyleGradient = LinearStyleGradient(
          colorList: colorList,
          stopList: stopList,
          gradientDirection: GradientDirection.topLeft);
    });

    test('.toWidgetString() returns the correct widget string', () {
      final actualWidgetString = linearStyleGradient.toWidgetString();
      final expectedWidgetString = '''LinearGradient(
          colors: $colorList,
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
            colorList: colorList,
            stopList: stopList,
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
            colorList: colorList,
            stopList: stopList,
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

    test('.toFlutterGradient() returns the right LinearGradient object', () {
      final Gradient actualGradient = linearStyleGradient.toFlutterGradient();
      final Gradient expectedGradient = LinearGradient(
          colors: colorList,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);

      expect(actualGradient, expectedGradient);
    });
  });
}
