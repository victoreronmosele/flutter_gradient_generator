import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/models/gradient_factory.dart';
import 'package:flutter_gradient_generator/models/linear_style_gradient.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/generator_section.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/preview_section.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/abstract_random_color_generator.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/random_color_generator.dart';
import 'package:flutter_gradient_generator/ui/widgets/footer/footer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final AbstractRandomColorGenerator randomColorGenerator =
      const RandomColorGenerator();

  late final AbstractGradient defaultGradient = LinearStyleGradient(
      colorAndStopList: randomColorGenerator.getTwoRandomColorsAndStops(),
      gradientDirection: GradientDirection.topLeft);

  late AbstractGradient gradient = defaultGradient;

  /// The index of the currently selected color in the color list being
  /// showned on the [GeneratorSection]
  int currentSelectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
    gradient = defaultGradient;
  }

  void onGradientStyleChanged(GradientStyle newGradientStyle) {
    if (gradient.getGradientStyle() != newGradientStyle) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: newGradientStyle,
        colorAndStopList: gradient.getColorAndStopList(),
        gradientDirection: gradient.getGradientDirection(),
      );

      setState(() {
        gradient = newGradient;
      });
    }
  }

  void onGradientDirectionChanged(GradientDirection newGradientDirection) {
    if (gradient.getGradientDirection() != newGradientDirection) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: gradient.getGradientStyle(),
        colorAndStopList: gradient.getColorAndStopList(),
        gradientDirection: newGradientDirection,
      );

      setState(() {
        gradient = newGradient;
      });
    }
  }

  void onColorAndStopListChanged(List<ColorAndStop> newColorAndStopList,
      {required int index}) {
    if (!const ListEquality<ColorAndStop>()
        .equals(gradient.getColorAndStopList(), newColorAndStopList)) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: gradient.getGradientStyle(),
        colorAndStopList: newColorAndStopList,
        gradientDirection: gradient.getGradientDirection(),
      );

      setState(() {
        gradient = newGradient;
        currentSelectedColorIndex = index;
      });
    }
  }

  void onNewColorAndStopAdded(ColorAndStop newColorAndStop) {
    final List<ColorAndStop> colorAndStopListCopy =
        List<ColorAndStop>.from(gradient.getColorAndStopList());

    colorAndStopListCopy.add(newColorAndStop);

    colorAndStopListCopy.sort((a, b) => a.stop.compareTo(b.stop));

    final updatedColorAndStopList = colorAndStopListCopy;

    final newColorAndStopIndex =
        updatedColorAndStopList.lastIndexOf(newColorAndStop);

    onColorAndStopListChanged(updatedColorAndStopList,
        index: newColorAndStopIndex);
  }

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);

    final displayPortrait = appDimensions.shouldDisplayPortraitUI;

    final previewSection = PreviewSection(
        gradient: gradient, borderRadius: displayPortrait ? 16.0 : 0.0);

    return Scaffold(
      body: Row(
        crossAxisAlignment: displayPortrait
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: displayPortrait ? 1 : 0,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: GeneratorSection(
                    gradient: gradient,
                    onGradientStyleChanged: onGradientStyleChanged,
                    onGradientDirectionChanged: onGradientDirectionChanged,
                    onColorAndStopListChanged: onColorAndStopListChanged,
                    onNewColorAndStopAdded: onNewColorAndStopAdded,
                    portraitInformation: (
                      previewWidgetForPortrait: previewSection,
                      isPortrait: displayPortrait,
                    ),
                    currentSelectedColorIndex: currentSelectedColorIndex,
                  ),
                ),
                const FooterWidget()
              ],
            ),
          ),
          if (!displayPortrait) Flexible(child: previewSection),
        ],
      ),
    );
  }
}
