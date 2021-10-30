import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';

class RadialStyleGradient extends AbstractGradient {
  RadialStyleGradient(
      {required List<Color> colorList,
      required GradientDirection gradientDirection})
      : super(colorList: colorList, gradientDirection: gradientDirection);

  String get _colorsInIndividualLines => getColorList().join(',\n ');

  String get _widgetStringTemplate =>
      '''class PreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
                    colors: [\n ${_colorsInIndividualLines}]

        ),
      ),
    );
  }
}''';

  @override
  String toWidgetString() {
    return _widgetStringTemplate;
  }

  @override
  GradientStyle getGradientStyle() {
    return GradientStyle.radial;
  }

  @override
  Gradient toFlutterGradient() {
    return RadialGradient(
      colors: getColorList(),
    );
  }
}
