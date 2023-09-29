import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/get_gradient_button.dart';
import 'package:flutter_gradient_generator/ui/widgets/generator_widgets/app_title_widget.dart';
import 'package:flutter_gradient_generator/ui/widgets/generator_widgets/selection_widgets/selection_widgets.dart';

class GeneratorSection extends StatelessWidget {
  final AbstractGradient gradient;
  final void Function(GradientStyle) onGradientStyleChanged;
  final void Function(GradientDirection) onGradientDirectionChanged;
  final void Function(List<ColorAndStop>, {required int index})
      onColorAndStopListChanged;
  final void Function(ColorAndStop) onNewColorAndStopAdded;
  final void Function({required int indexToDelete})
      onColorAndStopDeleteButtonPressed;

  final ({
    Widget previewWidgetForPortrait,
    bool isPortrait
  }) portraitInformation;

  final int currentSelectedColorIndex;

  const GeneratorSection({
    Key? key,
    required this.gradient,
    required this.onGradientStyleChanged,
    required this.onGradientDirectionChanged,
    required this.onColorAndStopListChanged,
    required this.portraitInformation,
    required this.currentSelectedColorIndex,
    required this.onNewColorAndStopAdded,
    required this.onColorAndStopDeleteButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String generatedCode = gradient.toWidgetString();

    final List<ColorAndStop> colorAndStopList = gradient.getColorAndStopList();

    final gradientStyle = gradient.getGradientStyle();

    final isPortrait = portraitInformation.isPortrait;
    final previewWidgetForPortrait =
        portraitInformation.previewWidgetForPortrait;

    final AppDimensions appDimensions = AppDimensions.of(context);
    final generatorScreenHorizontalPadding =
        appDimensions.generatorScreenHorizontalPadding;
    final generatorScreenVerticalPadding =
        appDimensions.generatorScreenVerticalPadding;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: generatorScreenHorizontalPadding,
          vertical: generatorScreenVerticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flex(
              /// This results in:
              /// - a [Column] (veritical [Flex]]) for portrait mode
              /// - a [Row] (horizontal [Flex]]) for landscape mode
              direction: isPortrait ? Axis.vertical : Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTitleWidget(
                  forPortrait: isPortrait,
                ),
                if (isPortrait) ...[
                  const SizedBox(height: 40),
                  AspectRatio(
                      aspectRatio: 16 / 9, child: previewWidgetForPortrait),
                ],
              ],
            ),
            const SizedBox(height: 40),
            StyleSelectionWidget(
              gradientStyle: gradientStyle,
              onGradientStyleChanged: onGradientStyleChanged,
            ),

            /// Ideally the spacing should be 24 but the [ColorAndStopSelectionWidget]
            /// has an action button that gives it an extra height.
            ///
            /// So the height is adjusted to 32 to match the spacing between
            /// [DirectionSelectionWidget] and [ColorAndStopSelectionWidget]
            const SizedBox(height: 32),
            DirectionSelectionWidget(
              gradientStyle: gradient.getGradientStyle(),
              selectedGradientDirection: gradient.getGradientDirection(),
              onGradientDirectionChanged: onGradientDirectionChanged,
            ),
            const SizedBox(height: 24),
            ColorAndStopSelectionWidget(
                colorAndStopList: colorAndStopList,
                onColorAndStopListChanged: onColorAndStopListChanged,
                currentSelectedColorIndex: currentSelectedColorIndex,
                onNewColorAndStopAdded: onNewColorAndStopAdded,
                onColorAndStopDeleteButtonPressed:
                    onColorAndStopDeleteButtonPressed),
            const SizedBox(height: 48),
            GetGradientButton(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: generatedCode));

                /// Log event to Firebase Analytics if not in debug mode
                if (!kDebugMode) {
                  await FirebaseAnalytics.instance.logEvent(
                      name: AppStrings.gradientGeneratedFirebaseAnalyticsKey,
                      parameters: gradient.toJson());
                }
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
