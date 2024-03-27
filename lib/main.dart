import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_fonts.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
// import 'package:flutter_gradient_generator/firebase_options.dart';
import 'package:flutter_gradient_generator/ui/screens/home_screen.dart';
import 'package:flutter_gradient_generator/utils/analytics.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GradientViewModel gradientViewModel;

  @override
  void initState() {
    super.initState();

    gradientViewModel = GradientViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      final screenSize = MediaQuery.of(context).size;

      final width = screenSize.width;
      final height = screenSize.height;

      return MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: AppFonts.getTextTheme(context)),
        home: AppDimensions(
          orientation: orientation,
          screenWidth: width,
          screenHeight: height,
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: gradientViewModel,
              ),
              Provider.value(
                value: Analytics(),
              ),
            ],
            child: const HomeScreen(),
          ),
        ),
      );
    });
  }
}
