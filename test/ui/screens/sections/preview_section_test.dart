import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/preview_section.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('PreviewSection', () {
    group('GradientDirectionCustom', () {
      late GradientViewModel gradientViewModel;

      setUp(() {
        gradientViewModel = GradientViewModel();
      });

      testWidgets(
        'should show two pickers for linear gradient',
        (WidgetTester tester) async {
          // This is actually the default value.
          gradientViewModel.changeGradientStyle(GradientStyle.linear);
          await tester.pumpWidget(
            MaterialApp(
              home: ChangeNotifierProvider.value(
                value: gradientViewModel,
                child: const PreviewSection.portrait(),
              ),
            ),
          );

          expect(find.byIcon(Icons.add_circle_outline_sharp), findsNothing);

          gradientViewModel.changeGradientDirectionToCustom();

          await tester.pumpAndSettle();

          expect(
            find.byIcon(Icons.add_circle_outline_sharp),
            findsNWidgets(2),
          );
        },
      );

      testWidgets(
        'should show only one picker for radial gradient',
        (tester) async {
          gradientViewModel.changeGradientStyle(GradientStyle.radial);
          await tester.pumpWidget(
            MaterialApp(
              home: ChangeNotifierProvider.value(
                value: gradientViewModel,
                child: const PreviewSection.portrait(),
              ),
            ),
          );

          expect(find.byIcon(Icons.add_circle_outline_sharp), findsNothing);

          gradientViewModel.changeGradientDirectionToCustom();

          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.add_circle_outline_sharp), findsOneWidget);
        },
      );

      testWidgets(
        'should show only one picker for sweep gradient',
        (tester) async {
          gradientViewModel.changeGradientStyle(GradientStyle.sweep);
          await tester.pumpWidget(
            MaterialApp(
              home: ChangeNotifierProvider.value(
                value: gradientViewModel,
                child: const PreviewSection.portrait(),
              ),
            ),
          );

          expect(find.byIcon(Icons.add_circle_outline_sharp), findsNothing);

          gradientViewModel.changeGradientDirectionToCustom();

          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.add_circle_outline_sharp), findsOneWidget);
        },
      );

      testWidgets(
        'dragging the first picker should change alignment',
        (WidgetTester tester) async {
          // This is actually the default value.
          gradientViewModel.changeGradientStyle(GradientStyle.linear);
          const initialDirection = GradientDirectionCustom(
            // Starts the pointer at 1/4 of the width and centered vertically.
            // When working with Alignment, (0.0, 0.0) means center.
            alignment: Alignment(-0.5, 0),
          );
          gradientViewModel.changeGradientDirection(initialDirection);
          await tester.pumpWidget(
            MaterialApp(
              home: ChangeNotifierProvider.value(
                value: gradientViewModel,
                child: const PreviewSection.portrait(),
              ),
            ),
          );
          final firstPicker = find.byIcon(Icons.add_circle_outline_sharp).first;

          // Drag down. 200 is just a big number to drag down as much as possible.
          await tester.drag(firstPicker, const Offset(0, 200));
          await tester.pumpAndSettle();

          final customDirection = gradientViewModel.gradient
              .getGradientDirection() as GradientDirectionCustom;

          expect(
            customDirection.alignment,
            // Since we dragged down until the bottom of the container and
            // there was no X movement, the endAlignment should be (-0.5, 1.0).
            equals(const Alignment(-0.5, 1.0)),
          );
          // Should not change the end alignment.
          expect(
            customDirection.endAlignment,
            equals(initialDirection.endAlignment),
          );
        },
      );
      testWidgets(
        'dragging the second picker should change end alignment',
        (WidgetTester tester) async {
          // This is actually the default value.
          gradientViewModel.changeGradientStyle(GradientStyle.linear);
          const initialDirection = GradientDirectionCustom(
            // Starts the pointer at 1/4 of the width and centered vertically.
            // When working with Alignment, (0.0, 0.0) means center.
            endAlignment: Alignment(0.5, 0),
          );
          gradientViewModel.changeGradientDirection(initialDirection);
          await tester.pumpWidget(
            MaterialApp(
              home: ChangeNotifierProvider.value(
                value: gradientViewModel,
                child: const PreviewSection.portrait(),
              ),
            ),
          );
          final secondPicker = find.byIcon(Icons.add_circle_outline_sharp).last;

          // Drag down. 200 is just a big number to drag down as much as possible.
          await tester.drag(secondPicker, const Offset(0, 200));
          await tester.pumpAndSettle();

          final customDirection = gradientViewModel.gradient
              .getGradientDirection() as GradientDirectionCustom;

          expect(
            customDirection.endAlignment,
            // Since we dragged down until the bottom of the container and
            // there was no X movement, the endAlignment should be (0.5, 1.0).
            equals(const Alignment(0.5, 1.0)),
          );
          // Should not change the alignment.
          expect(
            customDirection.alignment,
            equals(initialDirection.alignment),
          );
        },
      );

      testWidgets(
        'should change the pointer to grab when hovering over the picker',
        (WidgetTester tester) async {
          gradientViewModel.changeGradientStyle(GradientStyle.radial);
          gradientViewModel.changeGradientDirectionToCustom();
          await tester.pumpWidget(
            MaterialApp(
              home: ChangeNotifierProvider.value(
                value: gradientViewModel,
                child: const PreviewSection.portrait(),
              ),
            ),
          );

          final picker = find.byIcon(Icons.add_circle_outline_sharp);

          expect(
            tester
                .widget<MouseRegion>(
                  find.ancestor(
                    of: picker,
                    matching: find.byType(MouseRegion),
                  ),
                )
                .cursor,
            SystemMouseCursors.grab,
          );
        },
      );

      testWidgets(
        'should change the pointer to grabbing when dragging the picker',
        (WidgetTester tester) async {
          gradientViewModel.changeGradientStyle(GradientStyle.radial);
          gradientViewModel.changeGradientDirectionToCustom();
          await tester.pumpWidget(
            MaterialApp(
              home: ChangeNotifierProvider.value(
                value: gradientViewModel,
                child: const PreviewSection.portrait(),
              ),
            ),
          );

          final picker = find.byIcon(Icons.add_circle_outline_sharp);

          await tester.startGesture(tester.getCenter(picker));
          await tester.pumpAndSettle();

          expect(
            tester
                .widget<MouseRegion>(
                  find.ancestor(
                    of: picker,
                    matching: find.byType(MouseRegion),
                  ),
                )
                .cursor,
            SystemMouseCursors.grabbing,
          );
        },
      );
    });
  });
}
