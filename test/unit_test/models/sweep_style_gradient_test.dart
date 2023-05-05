import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/sweep_style_gradient.dart';
import 'package:test/test.dart';

void main() {
  group('SweepStyleGradient', () {
    late final List<Color> colorList;
    late final List<int> stopList;
    late final SweepStyleGradient sweepStyleGradient;

    setUpAll(() {
      colorList = [
        const Color(0xFF921E1E),
        const Color(0xFF0A951F),
      ];

      stopList = [0, 100];

      sweepStyleGradient = SweepStyleGradient(
          colorList: colorList,
          stopList: stopList,
          gradientDirection: GradientDirection.topLeft);
    });

    test('.toWidgetString() returns the correct widget string', () {
      final actualWidgetString = sweepStyleGradient.toWidgetString();
      final expectedWidgetString = '''SweepGradient(
          colors: $colorList,
          stops: ${stopList.map((stop) => stop / 100).toList()},
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
      };

      gradientDirectionToCenterAlignmentMap
          .forEach((GradientDirection gradientDirection, Alignment alignment) {
        final SweepStyleGradient testSweepStyleGradient = SweepStyleGradient(
            colorList: colorList,
            stopList: stopList,
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

    test('.toFlutterGradient() returns the right SweepGradient object', () {
      final Gradient actualSweepGradient =
          sweepStyleGradient.toFlutterGradient();
      final Gradient expectedSweepGradient = SweepGradient(
        colors: colorList,
        center: Alignment.topLeft,
        stops: stopList.map((stop) => stop / 100).toList(),
      );

      expect(actualSweepGradient, expectedSweepGradient);
    });
  });
}
