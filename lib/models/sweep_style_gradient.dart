import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:quiver/core.dart';

// ignore: must_be_immutable
class SweepStyleGradient extends AbstractGradient {
  SweepStyleGradient(
      {required List<ColorAndStop> colorAndStopList,
      required GradientDirection gradientDirection})
      : super(
          colorAndStopList: colorAndStopList,
          gradientDirection: gradientDirection,
        );

  String get _widgetStringTemplate => '''SweepGradient(
          colors: ${getColorList()},
          stops: ${getStopListForFlutterCode()},
          center: $centerAlignment,
        )
        ''';

  @visibleForTesting
  Alignment get centerAlignment {
    return switch (getGradientDirection()) {
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
  }

  @override
  String toWidgetString() {
    return _widgetStringTemplate;
  }

  @override
  GradientStyle getGradientStyle() {
    return GradientStyle.sweep;
  }

  @override
  FlutterGradientConverter getFlutterGradientConverter() {
    return ({required colors, stops}) {
      return SweepGradient(
        colors: colors,
        center: centerAlignment,
        stops: stops,
      );
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SweepStyleGradient &&
          runtimeType == other.runtimeType &&
          toWidgetString() == other.toWidgetString() &&
          getGradientStyle() == other.getGradientStyle() &&
          toFlutterGradient() == other.toFlutterGradient();

  @override
  int get hashCode => hash3(toWidgetString().hashCode,
      getGradientStyle().hashCode, toFlutterGradient().hashCode);
}
