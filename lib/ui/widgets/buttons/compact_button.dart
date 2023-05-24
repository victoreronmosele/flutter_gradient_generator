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
    Key? key,
    required IconData icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderSide,
  })  : child = Icon(
          icon,
          size: 12.0,
        ),
        super(key: key);

  /// Creates a [CompactButton] with a text.
  CompactButton.text({
    Key? key,
    required String text,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderSide,
  })  : child = Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        super(key: key);

  /// Creates a [CompactButton] without any child.
  const CompactButton.empty({
    Key? key,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderSide,
  })  : child = const SizedBox(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppDimensions appDimensions = AppDimensions.of(context);
    final compactButtonWidth = appDimensions.compactButtonWidth;
    final compactButtonHeight = appDimensions.compactButtonHeight;

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        foregroundColor: MaterialStateProperty.all(foregroundColor),
        textStyle: MaterialStateProperty.all(TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.getFontFamily(context))),
        side: MaterialStateProperty.all(borderSide),
        fixedSize: MaterialStateProperty.all(
            (Size(compactButtonWidth, compactButtonHeight))),
      ),
      child: child,
    );
  }
}
