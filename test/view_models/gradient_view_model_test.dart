import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GradientViewModel', () {
    late GradientViewModel gradientViewModel;

    group('GradientDirectionCustom', () {
      late GradientDirection initialDirection;

      setUp(() {
        initialDirection = const GradientDirectionCustom();
        gradientViewModel = GradientViewModel();
        gradientViewModel.changeGradientDirection(initialDirection);
      });

      test('should change alignment', () {
        const newAlignment = Alignment(0.5, 0);
        gradientViewModel.changeGradientDirection(
          const GradientDirectionCustom(alignment: newAlignment),
        );

        expect(
          gradientViewModel.gradient.getGradientDirection(),
          equals(const GradientDirectionCustom(alignment: newAlignment)),
        );
      });

      test('should change end alignment', () {
        const newEndAlignment = Alignment(0.5, 0);
        gradientViewModel.changeGradientDirection(
          const GradientDirectionCustom(endAlignment: newEndAlignment),
        );

        expect(
          gradientViewModel.gradient.getGradientDirection(),
          equals(const GradientDirectionCustom(endAlignment: newEndAlignment)),
        );
      });
    });
  });
}
