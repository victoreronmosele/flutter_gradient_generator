import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter_gradient_generator/ui/util/abstract_color_picker.dart';

class CyclopColorPicker implements AbstractColorPicker {
  const CyclopColorPicker();

  @override
  Color selectColor() {
    return Colors.primaries
        .elementAt(Random().nextInt(Colors.primaries.length - 1));
  }
}
