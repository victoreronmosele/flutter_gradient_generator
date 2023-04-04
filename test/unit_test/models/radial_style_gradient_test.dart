import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/radial_style_gradient.dart';
import 'package:test/test.dart';

void main() {
  group('RadialStyleGradient', () {
    late final List<Color> colorList;
    late final List<int> stopList;
    late final RadialStyleGradient radialStyleGradient;

    const radialGradientRadius = 0.8;

    setUpAll(() {
      colorList = [
        const Color(0xFF921E1E),
        const Color(0xFF0A951F),
      ];

      stopList = [0, 100];

      radialStyleGradient = RadialStyleGradient(
          colorList: colorList,
          stopList: stopList,
          gradientDirection: GradientDirection.topLeft);
    });

    test('.toWidgetString() returns the correct widget string', () {
      final actualWidgetString = radialStyleGradient.toWidgetString();
      final expectedWidgetString = '''RadialGradient(
          colors: $colorList,
          center: ${Alignment.topLeft},
          radius: $radialGradientRadius,
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
      };

      gradientDirectionToCenterAlignmentMap
          .forEach((GradientDirection gradientDirection, Alignment alignment) {
        final RadialStyleGradient testRadialStyleGradient = RadialStyleGradient(
            colorList: colorList,
            stopList: stopList,
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

    test('.toFlutterGradient() returns the right RadialGradient object', () {
      final Gradient actualGradient = radialStyleGradient.toFlutterGradient();
      final Gradient expectedGradient = RadialGradient(
          colors: colorList,
          center: Alignment.topLeft,
          radius: radialGradientRadius);

      expect(actualGradient, expectedGradient);
    });
  });
}
