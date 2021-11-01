class AppDimensions {
  static const double generatorScreenWidth = 320;
  static const double generatorScreenPadding = 32;
  static const double generatorScreenContentWidth =
      generatorScreenWidth - (2 * generatorScreenPadding);
  static const double numberOfCompactButtonPerRow = 3;
  static const double compactButtonMargin = 12.0;
  static const double compactButtonWidth =
      (generatorScreenContentWidth - 2 * compactButtonMargin) /
          numberOfCompactButtonPerRow;
  static const double compactButtonHeight = 32;
  static const double compactButtonPadding = 16;
  static const double wideButtonWidth = generatorScreenContentWidth;
  static const double wideButtonHeight = 48;
  static const double widebuttonPadding = 24;
}
