import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/models/gradient_factory.dart';
import 'package:flutter_gradient_generator/models/linear_style_gradient.dart';
import 'package:flutter_gradient_generator/ui/screens/generator_screen.dart';
import 'package:flutter_gradient_generator/ui/screens/preview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AbstractGradient defaultGradient = LinearStyleGradient(
      colorList: [
        Color(0xff67510D),
        Color(0xff4E9DE1)
      ], //[Colors.red, Colors.blue],
      gradientDirection: GradientDirection.topLeft);

  AbstractGradient? gradient;

  @override
  void initState() {
    super.initState();
    gradient = defaultGradient;
  }

  void onGradientStyleChanged(GradientStyle newGradientStyle) {
    if (gradient!.getGradientStyle() != newGradientStyle) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: newGradientStyle,
        colorList: gradient!.getColorList(),
        gradientDirection: gradient!.getGradientDirection(),
      );

      setState(() {
        gradient = newGradient;
      });
    }
  }

  void onGradientDirectionChanged(GradientDirection newGradientDirection) {
    if (gradient!.getGradientDirection() != newGradientDirection) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: gradient!.getGradientStyle(),
        colorList: gradient!.getColorList(),
        gradientDirection: newGradientDirection,
      );

      setState(() {
        gradient = newGradient;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int generatorScreenFlex = 25;
    final int previewScreenFlex = 75;

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: generatorScreenFlex,
              child: GeneratorScreen(
                  gradient: gradient!,
                  onGradientStyleChanged: onGradientStyleChanged,
                  onGradientDirectionChanged: onGradientDirectionChanged)),
          Expanded(
              flex: previewScreenFlex,
              child: PreviewScreen(gradient: gradient!)),
        ],
      ),
    );
  }
}
