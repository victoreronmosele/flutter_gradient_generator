import 'package:flutter/material.dart';

/// Holds the dimensions of the app.
///
/// It is an [InheritedWidget] so that it can be accessed from anywhere in the
/// widget tree using:
/// ```dart
///  AppDimensions.of(context)
/// ```
///
/// For example, to get the width of a wide button, you can use:
/// ```dart
/// AppDimensions.of(context).wideButtonWidth
/// ```
// ignore: must_be_immutable
class AppDimensions extends InheritedWidget {
  AppDimensions({
    super.key,
    required super.child,
    required Orientation orientation,
    required double screenWidth,
  }) : shouldDisplayPortraitUI = (orientation == Orientation.portrait) &&
            (screenWidth < _portraitModeMaxWidth) {
    generatorScreenWidth =
        shouldDisplayPortraitUI ? screenWidth : _landscapeGeneratorScreenWidth;
  }

  /// Whether the app should display the portrait UI.
  final bool shouldDisplayPortraitUI;

  static const double _landscapeGeneratorScreenWidth = 320;

  static const double _portraitModeMaxWidth = 500;

  double generatorScreenWidth = _landscapeGeneratorScreenWidth;

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
  double get expansionIconSize => 20;
  double get selectionContainerMainTitleWidth => (generatorScreenContentWidth -
      (compactButtonWidth + (2 * compactButtonMargin) + expansionIconSize));

  @override
  bool updateShouldNotify(covariant AppDimensions oldWidget) {
    return oldWidget.shouldDisplayPortraitUI != shouldDisplayPortraitUI ||
        oldWidget.generatorScreenWidth != generatorScreenWidth;
  }

  static AppDimensions? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppDimensions>();
  }

  static AppDimensions of(BuildContext context) {
    final AppDimensions? result = maybeOf(context);
    assert(result != null,
        'No AppDimensions found in context. Ensure to wrap the widget tree with [AppDimensions]');
    return result!;
  }
}
