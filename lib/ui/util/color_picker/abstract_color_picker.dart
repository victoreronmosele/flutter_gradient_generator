import 'package:flutter/material.dart';

abstract class AbstractColorPicker {
  void selectColor(
      {required BuildContext context,
      required Color currentColor,
      required void Function(Color) onColorSelected});
}
