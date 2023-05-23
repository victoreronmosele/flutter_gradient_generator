import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
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
  final void Function(List<Color>) onColorListChanged;
  final void Function(List<int>) onStopListChanged;
  final ({
    Widget previewWidgetForPortrait,
    bool isPortrait
  }) portraitInformation;
  final AppDimensions appDimensions;

  const GeneratorSection({
    Key? key,
    required this.gradient,
    required this.onGradientStyleChanged,
    required this.onGradientDirectionChanged,
    required this.onColorListChanged,
    required this.onStopListChanged,
    required this.portraitInformation,
    required this.appDimensions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String generatedCode = gradient.toWidgetString();

    final List<Color> colorList = gradient.getColorList();
    final List<int> stopList = gradient.getStopList();

    final gradientStyle = gradient.getGradientStyle();

    final isPortrait = portraitInformation.isPortrait;
    final previewWidgetForPortrait =
        portraitInformation.previewWidgetForPortrait;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: appDimensions.generatorScreenHorizontalPadding,
          vertical: appDimensions.generatorScreenVerticalPadding,
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
              appDimensions: appDimensions,
            ),
            const SizedBox(height: 24),
            DirectionSelectionWidget(
              gradientStyle: gradient.getGradientStyle(),
              selectedGradientDirection: gradient.getGradientDirection(),
              onGradientDirectionChanged: onGradientDirectionChanged,
              appDimensions: appDimensions,
            ),
            const SizedBox(height: 24),
            ColorAndStopSelectionWidget(
              colorList: colorList,
              stopList: stopList,
              onColorListChanged: onColorListChanged,
              onStopListChanged: onStopListChanged,
              appDimensions: appDimensions,
            ),
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
              appDimensions: appDimensions,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
