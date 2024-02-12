import 'dart:math';

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
    required this.screenWidth,
    required this.screenHeight,
  }) : shouldDisplayPortraitUI = (orientation == Orientation.portrait) &&
            (screenWidth < _portraitModeMaxWidth) {
    generatorScreenWidth =
        shouldDisplayPortraitUI ? screenWidth : _landscapeGeneratorScreenWidth;
  }

  final double screenHeight;
  final double screenWidth;

  final double deleteButtonIconSize = 16;

  /// Whether the app should display the portrait UI.
  final bool shouldDisplayPortraitUI;

  static const double _landscapeGeneratorScreenWidth = 320;

  static const double _portraitModeMaxWidth = 500;

  /// The width of the generator screen including the padding.
  ///
  /// For the width of the actual content (without the padding), use
  /// [generatorScreenContentWidth].
  double generatorScreenWidth = _landscapeGeneratorScreenWidth;

  double get generatorScreenHorizontalPadding => generatorScreenWidth / 10;
  double get generatorScreenVerticalPadding => generatorScreenHorizontalPadding;

  /// The width of the generator screen content.
  ///
  /// This is the width of the generator screen excluding the padding.
  ///
  /// For the width of the entire generator screen (including the padding), use
  /// [generatorScreenWidth].
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
  double get expansionIconSize => 16;

  double get selectionContainerMainTitleWidth => (generatorScreenContentWidth -
      (compactButtonWidth + (2 * compactButtonMargin) + expansionIconSize));

  double get bannerAdHorizontalPadding => generatorScreenHorizontalPadding;

  double get toolBarHeight => 48;

  double get chooseRandomGradientIconButtonSize => 16;

  double get sampleTitleBottomMargin => 2.0;

  // Using 6 instead of 16 to match the design due to additional space
  // added by the shuffle button in the `ColorAndStopSelectionWidget`
  double get sampleSectionVerticalPadding => 6.0;

  double get footerVerticalPadding => 8.0;

  double get samplesListViewSize =>
      screenHeight -
      ((chooseRandomGradientIconButtonSize * 2) +
          sampleTitleBottomMargin +
          (2 * sampleSectionVerticalPadding) +
          (2 * toolBarHeight) +
          (2 * footerVerticalPadding) +
          (4 * sampleSectionVerticalPadding) +
          16.0 +
          (3 * 14.0) +
          (3 * 8.0) +
          (2 * sampleSectionVerticalPadding));

  double get _minimumPreviewSectionWidth => generatorScreenWidth;

  double get previewSectionWidth => max(
      screenWidth - (2 * generatorScreenWidth), _minimumPreviewSectionWidth);

  double get toolBarIconButtonSize => 20;

  /// Ensure to update this method when adding new properties or constructor
  /// parameters that should trigger a rebuild when changed.
  @override
  bool updateShouldNotify(covariant AppDimensions oldWidget) {
    return oldWidget.shouldDisplayPortraitUI != shouldDisplayPortraitUI ||
        oldWidget.screenWidth != screenWidth ||
        oldWidget.screenHeight != screenHeight;
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
