import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/services/gradient_service.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/preview_section.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/get_gradient_button.dart';
import 'package:flutter_gradient_generator/ui/widgets/generator_widgets/app_title_widget.dart';
import 'package:flutter_gradient_generator/ui/widgets/generator_widgets/selection_widgets/selection_widgets.dart';

class GeneratorSection extends StatelessWidget {
  const GeneratorSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);
    final gradient =
        GradientServiceProvider.of(context).gradientService.gradient;

    final isPortrait = appDimensions.shouldDisplayPortraitUI;

    final generatedCode = gradient.toWidgetString();

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
                  const AspectRatio(
                    aspectRatio: 16 / 9,
                    child: PreviewSection.portrait(),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 40),
            const StyleSelectionWidget(),

            /// Ideally the spacing should be 24 but the [ColorAndStopSelectionWidget]
            /// has an action button that gives it an extra height.
            ///
            /// So the height is adjusted to 32 to match the spacing between
            /// [DirectionSelectionWidget] and [ColorAndStopSelectionWidget]
            const SizedBox(height: 32),
            DirectionSelectionWidget(),
            const SizedBox(height: 24),
            const ColorAndStopSelectionWidget(),
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
