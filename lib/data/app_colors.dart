import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';

class AppColors {
  static final grey = Colors.grey.shade200;
  static const darkGrey = Color(0xff3d4853);
  static const white = Colors.white;
  static const black = Colors.black;

  /// Initial gradient colors
  static const _initialGradientStartColor = Color(0xffFC466B);
  static const _initialGradientEndColor = Color(0xff3F5EFB);

  /// Initial gradient stops
  static const _initialGradientStartStop = 25;
  static const _initialGradientEndStop = 75;

  /// Returns the initial list of [ColorAndStop]s that can be showned on the [GeneratorSection]
  static get initialColorAndStopList {
    return [
      (color: _initialGradientStartColor, stop: _initialGradientStartStop),
      (color: _initialGradientEndColor, stop: _initialGradientEndStop)
    ];
  }

  //TODO: Make this dependent on the theme and set it to
  //[_previewBackgroundLight] or [_previewBackgroundDark] accordingly
  static const previewBackground = _previewBackgroundLight;
  static const _previewBackgroundLight = Color(0xfff5f5f5);
  // ignore: unused_field
  static const _previewBackgroundDark = Color(0xff1e1e1e);

  static const toolBar = Color(0xff2c2c2c);
  static const toolBarIcon = white;
  static final toolBarIconHover = white.withOpacity(0.08);
  static final toolBarIconFocus = white.withOpacity(0.12);

  static final colorPickerBorder = grey;
}
