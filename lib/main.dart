import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_fonts.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/firebase_options.dart';
import 'package:flutter_gradient_generator/services/gradient_service.dart';
import 'package:flutter_gradient_generator/ui/screens/home_screen.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  /// The [GradientService] instance to be used by the app.
  final gradientService = GradientService();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      final width = MediaQuery.of(context).size.width;

      return MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: AppFonts.getTextTheme(context)),
        home: AppDimensions(
          orientation: orientation,
          screenWidth: width,
          child: GradientServiceProvider(
            gradientService: gradientService,
            child: const HomeScreen(),
          ),
        ),
      );
    });
  }
}
