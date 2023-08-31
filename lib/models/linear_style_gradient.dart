import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:quiver/core.dart';

// ignore: must_be_immutable
class LinearStyleGradient extends AbstractGradient {
  LinearStyleGradient(
      {required List<ColorAndStop> colorAndStopList,
      required GradientDirection gradientDirection})
      : super(
          colorAndStopList: colorAndStopList,
          gradientDirection: gradientDirection,
        );

  String get _widgetStringTemplate => '''LinearGradient(
          colors: ${getColorList()},
          stops: ${getStopListForFlutterCode()},
          begin: $beginAlignment,
          end: $endAlignment,
        )
      ''';

  @visibleForTesting
  Alignment get beginAlignment {
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

  @visibleForTesting
  Alignment get endAlignment {
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
      begin: beginAlignment,
      end: endAlignment,
      stops: getStopListForFlutterCode(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinearStyleGradient &&
          runtimeType == other.runtimeType &&
          toWidgetString() == other.toWidgetString() &&
          getGradientStyle() == other.getGradientStyle() &&
          toFlutterGradient() == other.toFlutterGradient();

  @override
  int get hashCode => hash3(toWidgetString().hashCode,
      getGradientStyle().hashCode, toFlutterGradient().hashCode);
}
