import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/compact_button.dart';

class DirectionButton extends StatelessWidget {
  final IconData icon;
  final GradientDirection gradientDirection;
  final bool isSelected;
  final void Function(GradientDirection) onGradientDirectionChanged;

  const DirectionButton(
      {Key? key,
      required this.icon,
      required this.gradientDirection,
      required this.isSelected,
      required this.onGradientDirectionChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color greyColor = AppColors.grey;
    return CompactButton(
        child: Icon(
          icon,
          size: 12.0,
        ),
        onPressed: () {
          onGradientDirectionChanged(gradientDirection);
        },
        foregroundColor: Colors.black,
        backgroundColor: isSelected ? greyColor : Colors.white,
        borderSide: BorderSide(
          color: greyColor,
        ));
  }
}
