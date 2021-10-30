import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';

class RadialStyleGradient extends AbstractGradient {
  RadialStyleGradient(
      {required List<Color> colorList,
      required GradientDirection gradientDirection})
      : super(colorList: colorList, gradientDirection: gradientDirection);

  final double _radialGradientRadius = 0.8;

  String get _widgetStringTemplate =>
      '''class PreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: ${getColorList()},
          center: $_centerAlignment,
          radius: $_radialGradientRadius,
        ),
      ),
    );
  }
}''';

  Alignment get _centerAlignment {
    Alignment alignment;

    switch (getGradientDirection()) {
      case GradientDirection.topLeft:
        alignment = Alignment.topLeft;
        break;
      case GradientDirection.topCenter:
        alignment = Alignment.topCenter;
        break;
      case GradientDirection.topRight:
        alignment = Alignment.topRight;
        break;
      case GradientDirection.centerLeft:
        alignment = Alignment.centerLeft;
        break;
      case GradientDirection.center:
        alignment = Alignment.center;
        break;
      case GradientDirection.centerRight:
        alignment = Alignment.centerRight;
        break;
      case GradientDirection.bottomLeft:
        alignment = Alignment.bottomLeft;
        break;
      case GradientDirection.bottomCenter:
        alignment = Alignment.bottomCenter;
        break;
      case GradientDirection.bottomRight:
        alignment = Alignment.bottomRight;
        break;
    }

    return alignment;
  }

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
      center: _centerAlignment,
      radius: _radialGradientRadius,
    );
  }
}
