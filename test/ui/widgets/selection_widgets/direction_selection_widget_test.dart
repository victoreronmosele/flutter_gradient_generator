import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/ui/widgets/selection_widgets/direction_selection_widget.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('DirectionSelectionWidget', () {
    group('GradientDirectionCustom', () {
      late GradientViewModel gradientViewModel;

      setUp(() {
        gradientViewModel = GradientViewModel();
      });

      testWidgets(
        'should change direction to custom os custom tap and show text fields',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Material(
                child: AppDimensions(
                  orientation: Orientation.portrait,
                  screenWidth: 400,
                  screenHeight: 800,
                  child: ChangeNotifierProvider.value(
                    value: gradientViewModel,
                    child: DirectionSelectionWidget(),
                  ),
                ),
              ),
            ),
          );

          expect(
            gradientViewModel.gradient.getGradientDirection(),
            equals(
              GradientDirection.topLeft,
            ),
          );

          await tester.tap(find.text('Custom'));
          await tester.pumpAndSettle();

          expect(
            gradientViewModel.gradient.getGradientDirection(),
            equals(
              GradientDirection.custom(),
            ),
          );

          expect(find.text('X:'), findsNWidgets(2));
          expect(find.text('Y:'), findsNWidgets(2));
          expect(find.text('Alignment:'), findsOne);
          expect(find.text('End Alignment:'), findsOne);
        },
      );

      testWidgets(
        'should change alignment and end alignment when typing in text fields',
        (tester) async {
          gradientViewModel.changeGradientDirection(
            GradientDirection.custom(),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Material(
                child: AppDimensions(
                  orientation: Orientation.portrait,
                  screenWidth: 400,
                  screenHeight: 800,
                  child: ChangeNotifierProvider.value(
                    value: gradientViewModel,
                    child: DirectionSelectionWidget(),
                  ),
                ),
              ),
            ),
          );

          final textFields = find.byType(TextField);

          await tester.enterText(textFields.at(0), '0.11');
          await tester.pumpAndSettle();
          await tester.enterText(textFields.at(1), '-0.52');
          await tester.pumpAndSettle();
          await tester.enterText(textFields.at(2), '0.33');
          await tester.pumpAndSettle();
          await tester.enterText(textFields.at(3), '-0.44');
          await tester.pumpAndSettle();

          final customDirection = gradientViewModel.gradient
              .getGradientDirection() as GradientDirectionCustom;

          expect(
            customDirection.alignment,
            equals(const Alignment(0.11, -0.52)),
          );
          expect(
            customDirection.endAlignment,
            equals(const Alignment(0.33, -0.44)),
          );
        },
      );
    });
  });
}
