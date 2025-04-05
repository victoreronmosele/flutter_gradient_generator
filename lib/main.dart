import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_fonts.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/firebase_options.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/ui/screens/home_screen.dart';
import 'package:flutter_gradient_generator/utils/analytics.dart';
import 'package:flutter_gradient_generator/utils/favicon_changer.dart';
import 'package:flutter_gradient_generator/utils/gradient_downloader.dart';
import 'package:flutter_gradient_generator/utils/platform_checker.dart';
import 'package:flutter_gradient_generator/utils/remote_config.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:flutter_gradient_generator/view_models/history_view_model.dart';
import 'package:flutter_gradient_generator/view_models/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

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
  late final HomeViewModel homeViewModel;
  late final Analytics analytics;
  late final GradientDownloader gradientDownloader;
  late final PlatformChecker platformChecker;
  late final RemoteConfig remoteConfig;
  late final FaviconChanger faviconChanger;

  DateTime? lastFaviconChangeTime;
  Timer? faviconChangeDebounceTimer;

  void generateAndChangeFavicon(AbstractGradient gradient) async {
    SchedulerBinding.instance.scheduleTask(() async {
      final gradientDataUrl =
          await gradientDownloader.getGradientDataUrl(gradient);
      faviconChanger.changeFavicon(dataUrl: gradientDataUrl);

      lastFaviconChangeTime = DateTime.now();
    }, Priority.idle);
  }

  void setFavicon(AbstractGradient gradient) async {
    final cooldownDuration = Duration(seconds: 2);

    final lastFaviconChangeTimeLocal = lastFaviconChangeTime;

    if (lastFaviconChangeTimeLocal == null) {
      generateAndChangeFavicon(gradient);
    } else {
      final timeSinceLastChange =
          DateTime.now().difference(lastFaviconChangeTimeLocal);

      if (timeSinceLastChange > cooldownDuration) {
        generateAndChangeFavicon(gradient);
      } else {
        faviconChangeDebounceTimer?.cancel();
        faviconChangeDebounceTimer = Timer(
          cooldownDuration,
          () {
            generateAndChangeFavicon(gradient);
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    gradientViewModel = GradientViewModel(
      onNewGradientSet: (gradient) {
        historyViewModel.addNewGradientToHistory(gradient);
      },
      onSetGradientDetails: (gradient) async {
        setFavicon(gradient);
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
    homeViewModel = HomeViewModel();
    analytics = Analytics();
    gradientDownloader = GradientDownloader();
    platformChecker = PlatformChecker();
    remoteConfig = RemoteConfig();
    faviconChanger = FaviconChanger();
    setFavicon(gradientViewModel.gradient);
  }

  @override
  void dispose() {
    faviconChangeDebounceTimer?.cancel();
    super.dispose();
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
                ChangeNotifierProvider.value(
                  value: homeViewModel,
                ),
                Provider.value(
                  value: analytics,
                ),
                Provider.value(
                  value: gradientDownloader,
                ),
                Provider.value(
                  value: platformChecker,
                ),
                Provider.value(
                  value: remoteConfig,
                ),
              ],
              child: CallbackShortcuts(
                bindings: () {
                  final isMac = platformChecker.isMac();

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
