import 'package:firebase_analytics/firebase_analytics.dart';
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

class GeneratorScreen extends StatelessWidget {
  final AbstractGradient gradient;
  final void Function(GradientStyle) onGradientStyleChanged;
  final void Function(GradientDirection) onGradientDirectionChanged;
  final void Function(List<Color>) onColorListChanged;

  const GeneratorScreen(
      {Key? key,
      required this.gradient,
      required this.onGradientStyleChanged,
      required this.onGradientDirectionChanged,
      required this.onColorListChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _generatedCode = gradient.toWidgetString();

    final List<Color> colorList = gradient.getColorList();

    final gradientStyle = gradient.getGradientStyle();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.generatorScreenHorizontalPadding,
          vertical: AppDimensions.generatorScreenVerticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTitleWidget(),
            SizedBox(height: 40),
            StyleSelectionWidget(
              gradientStyle: gradientStyle,
              onGradientStyleChanged: onGradientStyleChanged,
            ),
            SizedBox(height: 24),
            DirectionSelectionWidget(
                gradientStyle: gradient.getGradientStyle(),
                selectedGradientDirection: gradient.getGradientDirection(),
                onGradientDirectionChanged: onGradientDirectionChanged),
            SizedBox(height: 24),
            ColorSelectionWidget(
                colorList: colorList, onColorListChanged: onColorListChanged),
            SizedBox(height: 48),
            GetGradientButton(onTap: () async {
              await Clipboard.setData(new ClipboardData(text: _generatedCode));
              await FirebaseAnalytics().logEvent(
                  name: AppStrings.gradientGeneratedFirebaseAnalyticsKey,
                  parameters: gradient.toJson());
            }),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
