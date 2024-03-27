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
  Alignment get beginAlignment => switch (getGradientDirection()) {
        GradientDirectionTopLeft() => Alignment.topLeft,
        GradientDirectionTopCenter() => Alignment.topCenter,
        GradientDirectionTopRight() => Alignment.topRight,
        GradientDirectionCenterLeft() => Alignment.centerLeft,
        GradientDirectionCenter() => Alignment.center,
        GradientDirectionCenterRight() => Alignment.centerRight,
        GradientDirectionBottomLeft() => Alignment.bottomLeft,
        GradientDirectionBottomCenter() => Alignment.bottomCenter,
        GradientDirectionBottomRight() => Alignment.bottomRight,
        GradientDirectionCustom(alignment: final alignment) => alignment,
      };

  @visibleForTesting
  Alignment get endAlignment => switch (getGradientDirection()) {
        GradientDirectionTopLeft() => Alignment.bottomRight,
        GradientDirectionTopCenter() => Alignment.bottomCenter,
        GradientDirectionTopRight() => Alignment.bottomLeft,
        GradientDirectionCenterLeft() => Alignment.centerRight,
        GradientDirectionCenter() => Alignment.center,
        GradientDirectionCenterRight() => Alignment.centerLeft,
        GradientDirectionBottomLeft() => Alignment.topRight,
        GradientDirectionBottomCenter() => Alignment.topCenter,
        GradientDirectionBottomRight() => Alignment.topLeft,
        GradientDirectionCustom(endAlignment: final endAlignment) =>
          endAlignment,
      };

  @override
  GradientDirectionCustom gradientDirectionAsCustom() {
    return GradientDirectionCustom(
      alignment: beginAlignment,
      endAlignment: endAlignment,
    );
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
  FlutterGradientConverter getFlutterGradientConverter() {
    return ({required colors, stops}) => LinearGradient(
          colors: colors,
          begin: beginAlignment,
          end: endAlignment,
          stops: stops,
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
