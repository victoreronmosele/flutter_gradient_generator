import 'dart:ui';
import 'package:cyclop/cyclop.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gradient_generator/ui/util/abstract_color_picker.dart';

class CyclopColorPicker implements AbstractColorPicker {
  const CyclopColorPicker();

  @override
  void selectColor(
      {required BuildContext context,
      required Color currentColor,
      required void Function(Color) onColorSelected}) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ColorPicker(
            selectedColor: currentColor,
            onColorSelected: onColorSelected,
            config: const ColorPickerConfig(
                enableLibrary: false, enableEyePicker: false),
            onClose: Navigator.of(context).pop,
            onEyeDropper: () {},
            onKeyboard: () {},
          ),
        );
      },
    );
  }
}
