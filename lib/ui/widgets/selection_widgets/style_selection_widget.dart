import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/compact_button.dart';
import 'package:flutter_gradient_generator/ui/widgets/selection_widgets/selection_container_widget.dart';
import 'package:provider/provider.dart';

class StyleSelectionWidget extends StatelessWidget {
  const StyleSelectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);
    final gradientViewModel = context.watch<GradientViewModel>();

    final gradient = gradientViewModel.gradient;

    final gradientStyle = gradient.getGradientStyle();

    final compactButtonMargin = appDimensions.compactButtonMargin;

    final selectedStyleButtonColor = AppColors.grey;
    const unselectedStyleButtonColor = Colors.transparent;

    return SelectionWidgetContainer(
      title: AppStrings.style,
      selectionWidget: Row(
        children: GradientStyle.values.map(
          (GradientStyle style) {
            final Color buttonColor = style == gradientStyle
                ? selectedStyleButtonColor
                : unselectedStyleButtonColor;

            final bool styleIsLast = style == GradientStyle.values.last;

            return Row(
              children: [
                CompactButton.text(
                  onPressed: () {
                    gradientViewModel.changeGradientStyle(style);
                  },
                  foregroundColor: Colors.black,
                  backgroundColor: buttonColor,
                  borderSide: BorderSide(color: selectedStyleButtonColor),
                  text: style.title,
                ),
                if (!styleIsLast)
                  SizedBox(
                    width: compactButtonMargin,
                  ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
