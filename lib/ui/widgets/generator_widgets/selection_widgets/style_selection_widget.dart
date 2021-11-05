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
    final bool isLinearGradientStyleSelected =
        gradientStyle == GradientStyle.linear;
    final bool isRadialGradientStyleSelected =
        gradientStyle == GradientStyle.radial;

    final Color selectedStyleButtonColor = AppColors.grey;
    final Color unselectedStyleButtonColor = AppColors.white;

    final Color linearStyleButtonColor = isLinearGradientStyleSelected
        ? selectedStyleButtonColor
        : unselectedStyleButtonColor;
    final Color radialStyleButtonColor = isRadialGradientStyleSelected
        ? selectedStyleButtonColor
        : unselectedStyleButtonColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.style,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            CompactButton(
              child: Text(
                AppStrings.linear,
              ),
              onPressed: () {
                onGradientStyleChanged(GradientStyle.linear);
              },
              foregroundColor: Colors.black,
              backgroundColor: linearStyleButtonColor,
              borderSide: BorderSide(color: selectedStyleButtonColor),
            ),
            SizedBox(
              width: AppDimensions.compactButtonMargin,
            ),
            CompactButton(
              child: Text(AppStrings.radial),
              onPressed: () {
                onGradientStyleChanged(GradientStyle.radial);
              },
              foregroundColor: Colors.black,
              backgroundColor: radialStyleButtonColor,
              borderSide: BorderSide(color: selectedStyleButtonColor),
            ),
          ],
        ),
      ],
    );
  }
}
