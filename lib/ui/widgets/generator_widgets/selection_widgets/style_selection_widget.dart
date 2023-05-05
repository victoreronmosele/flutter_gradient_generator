import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/compact_button.dart';

class StyleSelectionWidget extends StatelessWidget {
  const StyleSelectionWidget({
    Key? key,
    required this.gradientStyle,
    required this.onGradientStyleChanged,
  }) : super(key: key);

  final GradientStyle gradientStyle;
  final void Function(GradientStyle p1) onGradientStyleChanged;

  @override
  Widget build(BuildContext context) {
    final Color selectedStyleButtonColor = AppColors.grey;
    const Color unselectedStyleButtonColor = Colors.transparent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.style,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: GradientStyle.values.map(
            (GradientStyle style) {
              final Color buttonColor = style == gradientStyle
                  ? selectedStyleButtonColor
                  : unselectedStyleButtonColor;

              final bool styleIsLast = style == GradientStyle.values.last;

              return Row(
                children: [
                  CompactButton(
                    onPressed: () {
                      onGradientStyleChanged(style);
                    },
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColor,
                    borderSide: BorderSide(color: selectedStyleButtonColor),
                    child: Text(
                      style.title,
                    ),
                  ),
                  if (!styleIsLast)
                    const SizedBox(
                      width: AppDimensions.compactButtonMargin,
                    ),
                ],
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
