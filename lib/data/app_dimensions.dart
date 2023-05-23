class AppDimensions {
  static const double landscapeGeneratorScreenWidth = 320;
  static const double portraitModeWidthLimit = 500;
  static double _generatorScreenWidth = landscapeGeneratorScreenWidth;

  static final double generatorScreenWidth = _generatorScreenWidth;

  static set generatorScreenWidth(double value) {
    _generatorScreenWidth = value;
  }

  static final double generatorScreenHorizontalPadding =
      generatorScreenWidth / 10;
  static final double generatorScreenVerticalPadding =
      generatorScreenHorizontalPadding;
  static final double generatorScreenContentWidth =
      generatorScreenWidth - (2 * generatorScreenHorizontalPadding);
  static const double numberOfCompactButtonPerRow = 3;
  static const double compactButtonMargin = 12.0;
  static final double compactButtonWidth = (generatorScreenContentWidth -
          ((numberOfCompactButtonPerRow - 1) * compactButtonMargin)) /
      numberOfCompactButtonPerRow;
  static const double compactButtonHeight = 32;
  static const double compactButtonPadding = 16;
  static final double wideButtonWidth = generatorScreenContentWidth;
  static const double wideButtonHeight = 48;
  static const double widebuttonPadding = 24;
}
