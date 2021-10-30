import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/ui/widgets/direction_button.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class DirectionWidget extends StatelessWidget {
  final GradientStyle gradientStyle;
  final GradientDirection selectedGradientDirection;
  final void Function(GradientDirection) onGradientDirectionChanged;

  DirectionWidget(
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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: iconSetList.map(
            (Map<GradientDirection, IconData> gradientDirectionToIconSetMap) {
          final int iconSetIndex =
              iconSetList.indexOf(gradientDirectionToIconSetMap);
          final int firstIconSetIndex = 0;

          return Column(
            children: [
              if (iconSetIndex != firstIconSetIndex) SizedBox(height: 8.0),
              Row(
                  children: gradientDirectionToIconSetMap.values.map((icon) {
                final int iconIndex =
                    gradientDirectionToIconSetMap.values.toList().indexOf(icon);
                final GradientDirection gradientDirection =
                    gradientDirectionToIconSetMap.keys.elementAt(iconIndex);

                final int firstIconIndex = 0;

                final bool isCircleRadialButton =
                    iconSetIndex == circleDirectionIconSetNumber &&
                        iconIndex == circleDirectionIconNumberInSet;

                return Expanded(
                  child: Row(
                    children: [
                      if (iconIndex != firstIconIndex) SizedBox(width: 8.0),
                      Expanded(
                        child: Visibility(
                          child: DirectionButton(
                              icon: icon,
                              gradientDirection: gradientDirection,
                              isSelected: gradientDirection ==
                                  selectedGradientDirection,
                              onGradientDirectionChanged:
                                  onGradientDirectionChanged),
                          visible: isCircleRadialButton
                              ? gradientStyle == GradientStyle.radial
                              : true,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()),
            ],
          );
        }).toList());
  }
}
