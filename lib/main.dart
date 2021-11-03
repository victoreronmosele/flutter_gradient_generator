import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/models/gradient_factory.dart';
import 'package:flutter_gradient_generator/models/linear_style_gradient.dart';
import 'package:flutter_gradient_generator/ui/screens/generator_screen.dart';
import 'package:flutter_gradient_generator/ui/screens/preview_screen.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
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
      colorList: [Color(0xffFD2B0B), Color(0xff7199EB)],
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

  void onColorListChanged(List<Color> newColorList) {
    if (!ListEquality().equals(gradient!.getColorList(), newColorList)) {

      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: gradient!.getGradientStyle(),
        colorList: newColorList,
        gradientDirection: gradient!.getGradientDirection(),
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
        children: [
          GeneratorScreen(
            gradient: gradient!,
            onGradientStyleChanged: onGradientStyleChanged,
            onGradientDirectionChanged: onGradientDirectionChanged,
            onColorListChanged: onColorListChanged,
          ),
          Flexible(child: PreviewScreen(gradient: gradient!)),
        ],
      ),
    );
  }
}
