import 'package:cyclop/cyclop.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gradient_generator/ui/util/color_picker/color_picker_interface.dart';

class CyclopColorPicker implements ColorPickerInterface {
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
