import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_fonts.dart';

class CompactButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderSide? borderSide;

  /// Creates a [CompactButton] with an icon.
  CompactButton.icon({
    super.key,
    required IconData icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderSide,
  }) : child = Icon(
          icon,
          size: 12.0,
        );

  /// Creates a [CompactButton] with a text.
  CompactButton.text({
    super.key,
    required String text,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderSide,
  }) : child = Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );

  /// Creates a [CompactButton] without any child.
  const CompactButton.empty({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderSide,
  }) : child = const SizedBox();

  @override
  Widget build(BuildContext context) {
    final AppDimensions appDimensions = AppDimensions.of(context);
    final compactButtonWidth = appDimensions.compactButtonWidth;
    final compactButtonHeight = appDimensions.compactButtonHeight;

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        foregroundColor: WidgetStateProperty.all(foregroundColor),
        textStyle: WidgetStateProperty.all(TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.getFontFamily(context))),
        side: WidgetStateProperty.all(borderSide),
        fixedSize: WidgetStateProperty.all(
            (Size(compactButtonWidth, compactButtonHeight))),
      ),
      child: child,
    );
  }
}
