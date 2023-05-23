import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_fonts.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/firebase_options.dart';
import 'package:flutter_gradient_generator/ui/screens/home_screen.dart';
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
    return OrientationBuilder(builder: (context, orientation) {
      bool shouldDisplayPortrait({required double width}) {
        final orientationIsPotrait = orientation == Orientation.portrait;

        final displayPortrait = orientationIsPotrait &&
            (width < AppDimensions.portraitModeWidthLimit);

        return displayPortrait;
      }

      final width = MediaQuery.of(context).size.width;

      final displayPortrait = shouldDisplayPortrait(width: width);

      if (displayPortrait) {
        AppDimensions.generatorScreenWidth = width;
      }

      return MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: AppFonts.getTextTheme(context)),
        home: const HomeScreen(),
      );
    });
  }
}
