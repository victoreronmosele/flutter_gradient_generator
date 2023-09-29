import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/ui/util/new_color_generator/new_color_generator_interface.dart';

class NewColorGenerator implements NewColorGeneratorInterface {
  /// Generates a new color and stop between [startColorAndStop] and [endColorAndStop].
  ///
  /// At least one of [startColorAndStop] and [endColorAndStop] should not be null.
  @override
  ColorAndStop? generateNewColorAndStopBetween(
      {required ColorAndStop? startColorAndStop,
      required ColorAndStop? endColorAndStop}) {
    /// If start and end colors are identical, return start color
    ///
    /// This does the following:
    /// - saves resources used to lerp between identical colors since the result
    /// will be the same as the start color
    /// - returns null if both start and end colors are null (ensures that at least
    /// one color is not null in the code following this line)
    if (identical(startColorAndStop, endColorAndStop)) return startColorAndStop;

    final Color? startColor = startColorAndStop?.color;
    final Color? endColor = endColorAndStop?.color;

    final int startStop = startColorAndStop?.stop ?? 0;
    final int endStop = endColorAndStop?.stop ?? 100;

    final int newStop = (startStop + endStop) ~/ 2;

    /// Create HSVColor from Color instances
    final HSVColor? startHSVColor =
        startColor == null ? null : HSVColor.fromColor(startColor);
    final HSVColor? endHSVColor =
        endColor == null ? null : HSVColor.fromColor(endColor);

    /// The midpoint of the interpolation between start and end colors.
    const midPointTimeline = 0.5;

    /// Create new HSVColor by lerping between start and end HSVColor
    /// using [midPointTimeline].
    ///
    /// [HSVColor.lerp] is used instead of [Color.lerp] because
    /// - [HSVColor.lerp] produces a more pleasing effect than [Color.lerp]
    /// as it interpolates between colors in HSV color space instead of RGB
    /// color space.
    /// - [HSVColor.lerp]'s result is visible while [Color.lerp]'s result is not
    /// since the original gradient linearly interpolates between colors in RGB
    /// color space which is what [Color.lerp] does.
    final HSVColor newHSVColor =
        HSVColor.lerp(startHSVColor, endHSVColor, midPointTimeline)!;

    final Color newColorFromHSV = newHSVColor.toColor();

    final ColorAndStop newColorAndStop =
        (color: newColorFromHSV, stop: newStop);

    return newColorAndStop;
  }
}
