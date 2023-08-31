import 'package:flutter/material.dart';

abstract interface class ColorPickerInterface {
  void selectColor(
      {required BuildContext context,
      required Color currentColor,
      required void Function(Color) onColorSelected});
}
