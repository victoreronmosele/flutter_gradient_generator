import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';

/// A [TextField] with an [OutlineInputBorder].
class OutlinedTextField extends StatelessWidget {
  const OutlinedTextField({
    super.key,
    required this.inputFormatters,
    required this.onSubmitted,
    required this.onTap,
    required this.controller,
    required this.focusNode,
    required this.onTapOutside,
    this.keyboardType,
  });

  final List<TextInputFormatter> inputFormatters;
  final ValueChanged<String?> onSubmitted;
  final void Function() onTap;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(PointerDownEvent) onTapOutside;

  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final AppDimensions appDimensions = AppDimensions.of(context);

    final compactButtonWidth = appDimensions.compactButtonWidth;
    final compactButtonHeight = appDimensions.compactButtonHeight;

    return SizedBox(
      width: compactButtonWidth,
      height: compactButtonHeight,
      child: TextField(
          inputFormatters: inputFormatters,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.zero,
          ),
          keyboardType: keyboardType,
          textAlign: TextAlign.center,
          onSubmitted: onSubmitted,
          controller: controller,
          focusNode: focusNode,
          onTap: onTap,
          onTapOutside: onTapOutside),
    );
  }
}
