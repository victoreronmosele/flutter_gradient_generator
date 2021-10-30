import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';

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
    return TextButton(
      child: Icon(
        icon,
        size: 12.0,
      ),
      onPressed: () {
        onGradientDirectionChanged(gradientDirection);
      },
      style: TextButton.styleFrom(
          backgroundColor: isSelected ? greyColor : Colors.white,
          primary: Colors.black,
          textStyle: TextStyle(fontWeight: FontWeight.bold),
          side: BorderSide(
            color: greyColor,
          )),
    );
  }
}

