import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/compact_buttons/direction_button.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class DirectionSelectionWidget extends StatelessWidget {
  final GradientStyle gradientStyle;
  final GradientDirection selectedGradientDirection;
  final void Function(GradientDirection) onGradientDirectionChanged;

  DirectionSelectionWidget(
      {Key? key,
      required this.gradientStyle,
      required this.selectedGradientDirection,
      required this.onGradientDirectionChanged})
      : super(key: key);

  final int circleDirectionIconSetNumber = 1;
  final int circleDirectionIconNumberInSet = 1;

  final List<Map<GradientDirection, IconData>> iconSetList = [
    {
      GradientDirection.topLeft: MaterialCommunityIcons.arrow_top_left,
      GradientDirection.topCenter: MaterialCommunityIcons.arrow_up,
      GradientDirection.topRight: MaterialCommunityIcons.arrow_top_right,
    },
    {
      GradientDirection.centerLeft: MaterialCommunityIcons.arrow_left,
      GradientDirection.center: MaterialCommunityIcons.circle_outline,
      GradientDirection.centerRight: MaterialCommunityIcons.arrow_right,
    },
    {
      GradientDirection.bottomLeft: MaterialCommunityIcons.arrow_bottom_left,
      GradientDirection.bottomCenter: MaterialCommunityIcons.arrow_down,
      GradientDirection.bottomRight: MaterialCommunityIcons.arrow_bottom_right,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        AppStrings.direction,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      ...iconSetList.map(
          (Map<GradientDirection, IconData> gradientDirectionToIconSetMap) {
        final int iconSetIndex =
            iconSetList.indexOf(gradientDirectionToIconSetMap);
        const int firstIconSetIndex = 0;

        return Column(
          children: [
            if (iconSetIndex != firstIconSetIndex) const SizedBox(height: 8.0),
            Row(
                children: gradientDirectionToIconSetMap.values.map((icon) {
              final int iconIndex =
                  gradientDirectionToIconSetMap.values.toList().indexOf(icon);
              final GradientDirection gradientDirection =
                  gradientDirectionToIconSetMap.keys.elementAt(iconIndex);

              const int firstIconIndex = 0;

              final bool isCircleRadialButton =
                  iconSetIndex == circleDirectionIconSetNumber &&
                      iconIndex == circleDirectionIconNumberInSet;

              return Row(
                children: [
                  if (iconIndex != firstIconIndex)
                    const SizedBox(width: AppDimensions.compactButtonMargin),
                  Visibility(
                    child: DirectionButton(
                        icon: icon,
                        gradientDirection: gradientDirection,
                        isSelected:
                            gradientDirection == selectedGradientDirection,
                        onGradientDirectionChanged: onGradientDirectionChanged),
                    visible: isCircleRadialButton
                        ? gradientStyle == GradientStyle.radial
                        : true,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                  ),
                ],
              );
            }).toList()),
          ],
        );
      }).toList()
    ]);
  }
}
