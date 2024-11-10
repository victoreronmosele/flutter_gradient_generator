import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_fonts.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/firebase_options.dart';
import 'package:flutter_gradient_generator/ui/screens/home_screen.dart';
import 'package:flutter_gradient_generator/utils/analytics.dart';
import 'package:flutter_gradient_generator/utils/gradient_downloader.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:flutter_gradient_generator/view_models/history_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:web/web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GradientViewModel gradientViewModel;
  late final HistoryViewModel historyViewModel;
  late final Analytics analytics;
  late final GradientDownloader gradientDownloader;

  @override
  void initState() {
    super.initState();

    gradientViewModel = GradientViewModel(
      onNewGradientSet: (gradient) {
        historyViewModel.addNewGradientToHistory(gradient);
      },
    );
    historyViewModel = HistoryViewModel(
      onUndoOrRedo: () {
        final lastGradient = historyViewModel.liveHistory.lastOrNull;

        if (lastGradient == null) {
          gradientViewModel.setGradientToDefault(isNewGradient: false);
        } else {
          gradientViewModel.setGradientDetails(
              gradientToSet: lastGradient, isNewGradient: false);
        }
      },
    );
    analytics = Analytics();
    gradientDownloader = GradientDownloader();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
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
                ChangeNotifierProvider.value(
                  value: historyViewModel,
                ),
                Provider.value(
                  value: analytics,
                ),
                Provider.value(
                  value: gradientDownloader,
                ),
              ],
              child: CallbackShortcuts(
                bindings: () {
                  final isMac =
                      window.navigator.platform.toLowerCase().contains('mac');

                  // Command + Z if Mac, Control + Z otherwise
                  final undoShortcutActivator = SingleActivator(
                    LogicalKeyboardKey.keyZ,
                    meta: isMac,
                    control: !isMac,
                  );

                  // Command + Shift + Z if Mac, Control + Y otherwise
                  final redoShortcutActivator = SingleActivator(
                    isMac ? LogicalKeyboardKey.keyZ : LogicalKeyboardKey.keyY,
                    meta: isMac,
                    control: !isMac,
                    shift: isMac,
                  );

                  return {
                    undoShortcutActivator: () {
                      analytics.logUndoShortcutPressedEvent();

                      historyViewModel.undo();
                    },
                    redoShortcutActivator: () {
                      analytics.logRedoShortcutPressedEvent();

                      historyViewModel.redo();
                    },
                  };
                }(),
                child: Focus(
                  autofocus: true,
                  child: const HomeScreen(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
