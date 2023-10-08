import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/ui/util/new_color_generator/new_color_generator_interface.dart';
import 'package:tinycolor2/tinycolor2.dart';

class NewColorGenerator implements NewColorGeneratorInterface {
  /// Generates a new [ColorAndStop]
  ///
  /// The [seedColorAndStop] is used to generate the new [ColorAndStop]
  @override
  ColorAndStop generateNewColorAndStop(
      {required ColorAndStop seedColorAndStop}) {
    final (color: seedColor, stop: seedStop) = seedColorAndStop;

    final newColor = seedColor.spin(30);
    final int newStop =
        (seedStop == 100 ? 100 : ((seedStop + 100) / 2)).floor();

    return (color: newColor, stop: newStop);
  }
}
