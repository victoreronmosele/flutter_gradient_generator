import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_fonts.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/firebase_options.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/models/gradient_factory.dart';
import 'package:flutter_gradient_generator/models/linear_style_gradient.dart';
import 'package:flutter_gradient_generator/ui/screens/generator_screen.dart';
import 'package:flutter_gradient_generator/ui/screens/preview_screen.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/abstract_random_color_generator.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/random_color_generator.dart';
import 'package:flutter_gradient_generator/ui/widgets/footer/footer_widget.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: AppFonts.getTextTheme(context)),
      home: const HomeScreen(),
    );
  }
}

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
        gradientDirection: gradient.getGradientDirection(),
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
              GeneratorScreen(
                gradient: gradient,
                onGradientStyleChanged: onGradientStyleChanged,
                onGradientDirectionChanged: onGradientDirectionChanged,
                onColorListChanged: onColorListChanged,
              ),
              const FooterWidget()
            ],
          ),
          Flexible(child: PreviewScreen(gradient: gradient)),
        ],
      ),
    );
  }
}
