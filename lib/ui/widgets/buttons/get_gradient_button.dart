import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_fonts.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:provider/provider.dart';

class GetGradientButton extends StatefulWidget {
  const GetGradientButton({
    Key? key,
  }) : super(key: key);

  @override
  State<GetGradientButton> createState() => _GetGradientButtonState();
}

class _GetGradientButtonState extends State<GetGradientButton> {
  bool _showCopiedText = false;

  String get _buttonText => _showCopiedText
      ? AppStrings.gradientCodeCopied
      : AppStrings.getGradientCode;

  Color _getBackgroundColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return AppColors.darkGrey;
    }
    return AppColors.grey;
  }

  Color _getForegroundColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return AppColors.white;
    }
    return AppColors.black;
  }

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);

    final wideButtonPadding = appDimensions.widebuttonPadding;
    final wideButtonWidth = appDimensions.wideButtonWidth;
    final wideButtonHeight = appDimensions.wideButtonHeight;

    final gradient = context.watch<GradientViewModel>().gradient;
    final generatedCode = gradient.toWidgetString();

    return TextButton(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: generatedCode));

        /// Log event to Firebase Analytics if not in debug mode
        if (!kDebugMode) {
          await FirebaseAnalytics.instance.logEvent(
              name: AppStrings.gradientGeneratedFirebaseAnalyticsKey,
              parameters: gradient.toJson());
        }

        setState(() {
          _showCopiedText = true;
        });

        await Future.delayed(const Duration(seconds: 2));

        setState(() {
          _showCopiedText = false;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(_getBackgroundColor),
        foregroundColor: MaterialStateProperty.resolveWith(_getForegroundColor),
        textStyle: MaterialStateProperty.all(TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.getFontFamily(context))),
        padding: MaterialStateProperty.all(EdgeInsets.all(wideButtonPadding)),
        fixedSize: MaterialStateProperty.all(
            (Size(wideButtonWidth, wideButtonHeight))),
      ),
      child: Text(_buttonText),
    );
  }
}
