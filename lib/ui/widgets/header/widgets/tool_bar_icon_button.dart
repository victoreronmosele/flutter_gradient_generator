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
  final ToolTipMessage toolTipMessage;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);

    return Tooltip(
      richMessage: TextSpan(
        children: toolTipMessage.toolTipTextList.map((text) {
          return TextSpan(
            text: text.value,
            style: text.isKeyboardKey
                ? TextStyle(
                    color: Colors.white70,
                  )
                : null,
          );
        }).toList(),
      ),
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

class ToolTipMessage {
  const ToolTipMessage({required this.toolTipTextList});

  final List<ToolTipText> toolTipTextList;
}

class ToolTipText {
  const ToolTipText({required this.value, required this.isKeyboardKey});

  final String value;
  final bool isKeyboardKey;
}

class EmptySpaceToolTipText extends ToolTipText {
  const EmptySpaceToolTipText() : super(value: '  ', isKeyboardKey: false);
}
