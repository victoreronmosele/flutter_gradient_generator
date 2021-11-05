import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_fonts.dart';

class CompactButton extends StatelessWidget {
  const CompactButton(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.backgroundColor,
      required this.foregroundColor,
      this.borderSide})
      : super(key: key);

  final Widget child;
  final void Function() onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderSide? borderSide;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: child,
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        foregroundColor: MaterialStateProperty.all(foregroundColor),
        textStyle: MaterialStateProperty.all(TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.getFontFamily(context))),
        side: MaterialStateProperty.all(borderSide),
        fixedSize: MaterialStateProperty.all((Size(
            AppDimensions.compactButtonWidth,
            AppDimensions.compactButtonHeight))),
      ),
    );
  }
}
