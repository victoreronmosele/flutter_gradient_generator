import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';

class RadialStyleGradient extends AbstractGradient {
  RadialStyleGradient({required List<Color> colorList})
      : super(colorList: colorList);

  String get _colorsInIndividualLines => getColorList().join(',\n ');

  String get _widgetStringTemplate =>
      '''class PreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
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
