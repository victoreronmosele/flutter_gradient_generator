import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions({
    required Orientation orientation,
    required double screenWidth,
  }) : displayPortrait = (orientation == Orientation.portrait) &&
            (screenWidth < portraitModeMaxWidth) {
    generatorScreenWidth =
        displayPortrait ? screenWidth : landscapeGeneratorScreenWidth;
  }

  final bool displayPortrait;

  static const double landscapeGeneratorScreenWidth = 320;

  static const double portraitModeMaxWidth = 500;

  double generatorScreenWidth = landscapeGeneratorScreenWidth;

  double get generatorScreenHorizontalPadding => generatorScreenWidth / 10;
  double get generatorScreenVerticalPadding => generatorScreenHorizontalPadding;
  double get generatorScreenContentWidth =>
      generatorScreenWidth - (2 * generatorScreenHorizontalPadding);
  double get numberOfCompactButtonPerRow => 3;
  double get compactButtonMargin => 12.0;
  double get compactButtonWidth =>
      (generatorScreenContentWidth -
          ((numberOfCompactButtonPerRow - 1) * compactButtonMargin)) /
      numberOfCompactButtonPerRow;
  double get compactButtonHeight => 32;
  double get compactButtonPadding => 16;
  double get wideButtonWidth => generatorScreenContentWidth;
  double get wideButtonHeight => 48;
  double get widebuttonPadding => 24;
}
