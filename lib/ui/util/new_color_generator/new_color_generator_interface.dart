import 'package:flutter_gradient_generator/data/app_typedefs.dart';

abstract interface class NewColorGeneratorInterface {
  ColorAndStop generateNewColorAndStop(
      {required ColorAndStop seedColorAndStop});
}
