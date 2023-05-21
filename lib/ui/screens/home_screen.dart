import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
      colorList: randomColorGenerator.getTwoRandomColors(),
      stopList: const [0, 100],
      gradientDirection: GradientDirection.topLeft);

  late AbstractGradient gradient = defaultGradient;

  @override
  void initState() {
    super.initState();
    gradient = defaultGradient;
  }

  void onGradientStyleChanged(GradientStyle newGradientStyle) {
    if (gradient.getGradientStyle() != newGradientStyle) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: newGradientStyle,
        colorList: gradient.getColorList(),
        stopList: gradient.getStopList(),
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
        colorList: gradient.getColorList(),
        stopList: gradient.getStopList(),
        gradientDirection: newGradientDirection,
      );

      setState(() {
        gradient = newGradient;
      });
    }
  }

  void onColorListChanged(List<Color> newColorList) {
    if (!const ListEquality().equals(gradient.getColorList(), newColorList)) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: gradient.getGradientStyle(),
        colorList: newColorList,
        stopList: gradient.getStopList(),
        gradientDirection: gradient.getGradientDirection(),
      );

      setState(() {
        gradient = newGradient;
      });
    }
  }

  void onStopListChanged(List<int> newStopList) {
    if (!const ListEquality().equals(gradient.getStopList(), newStopList)) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: gradient.getGradientStyle(),
        colorList: gradient.getColorList(),
        gradientDirection: gradient.getGradientDirection(),
        stopList: newStopList,
      );

      setState(() {
        gradient = newGradient;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              GeneratorSection(
                gradient: gradient,
                onGradientStyleChanged: onGradientStyleChanged,
                onGradientDirectionChanged: onGradientDirectionChanged,
                onColorListChanged: onColorListChanged,
                onStopListChanged: onStopListChanged,
              ),
              const FooterWidget()
            ],
          ),
          Flexible(child: PreviewSection(gradient: gradient)),
        ],
      ),
    );
  }
}
