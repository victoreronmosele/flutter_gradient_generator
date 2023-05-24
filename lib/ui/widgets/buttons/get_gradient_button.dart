import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_fonts.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';

class GetGradientButton extends StatefulWidget {
  const GetGradientButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Future<void> Function() onTap;

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
    final AppDimensions appDimensions = AppDimensions.of(context);

    final double wideButtonPadding = appDimensions.widebuttonPadding;
    final double wideButtonWidth = appDimensions.wideButtonWidth;
    final double wideButtonHeight = appDimensions.wideButtonHeight;

    return TextButton(
      onPressed: () async {
        await widget.onTap();

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
