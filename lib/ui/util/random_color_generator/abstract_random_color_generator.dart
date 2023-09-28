import 'package:flutter_gradient_generator/data/app_typedefs.dart';

abstract interface class AbstractRandomColorGenerator {
  List<ColorAndStop>
      getRandomColorAndStopsOfCurrentGradientColorAndStopListLength({
    required int currentGradientColorAndStopListLength,
  });
}
