import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';

/// An [IconButton] that is displayed in the [ToolBar].
class ToolBarIconButton extends StatelessWidget {
  const ToolBarIconButton({
    super.key,
    required this.toolTipMessage,
    required this.icon,
    required this.onPressed,
    this.color = AppColors.toolBarIcon,
  });

  /// The message to show in the [ToolTip] when the icon is hovered over.
  final String toolTipMessage;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);

    return Tooltip(
      message: toolTipMessage,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: appDimensions.toolBarIconButtonSize,
        hoverColor: AppColors.toolBarIconHover,
        focusColor: AppColors.toolBarIconFocus,
        disabledColor: AppColors.toolBarIconDisabled,
        color: color,
      ),
    );
  }
}
