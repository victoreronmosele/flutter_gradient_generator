import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';

class LinearStyleGradient extends AbstractGradient {
  LinearStyleGradient(
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
        gradient: LinearGradient(
          begin: $_getBeginAlignment,
          end: $_getEndAlignment,
          colors: [\n ${_colorsInIndividualLines}]
        ),
      ),
    );
  }
}''';

  Alignment get _getBeginAlignment {
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

  Alignment get _getEndAlignment {
    Alignment alignment;

    switch (getGradientDirection()) {
      case GradientDirection.topLeft:
        alignment = Alignment.bottomRight;
        break;
      case GradientDirection.topCenter:
        alignment = Alignment.bottomCenter;
        break;
      case GradientDirection.topRight:
        alignment = Alignment.bottomLeft;
        break;
      case GradientDirection.centerLeft:
        alignment = Alignment.centerRight;
        break;
      case GradientDirection.center:
        alignment = Alignment.center;
        break;
      case GradientDirection.centerRight:
        alignment = Alignment.centerLeft;
        break;
      case GradientDirection.bottomLeft:
        alignment = Alignment.topRight;
        break;
      case GradientDirection.bottomCenter:
        alignment = Alignment.topCenter;
        break;
      case GradientDirection.bottomRight:
        alignment = Alignment.topLeft;
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
    return GradientStyle.linear;
  }

  @override
  Gradient toFlutterGradient() {
    return LinearGradient(
        colors: getColorList(),
        begin: _getBeginAlignment,
        end: _getEndAlignment);
  }
}
