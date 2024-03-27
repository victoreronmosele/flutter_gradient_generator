import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:test/test.dart';

Matcher flutterGradientConverterEquals(
  FlutterGradientConverter expected, {
  required List<Color> colors,
  List<double>? stops,
}) =>
    _FlutterGradientConverterEquals(expected, colors: colors, stops: stops);

class _FlutterGradientConverterEquals extends Matcher {
  const _FlutterGradientConverterEquals(this.expected,
      {required this.colors, this.stops});

  final FlutterGradientConverter expected;
  final List<Color> colors;
  final List<double>? stops;

  @override
  bool matches(Object? actual, Map matchState) {
    if (actual is FlutterGradientConverter) {
      return actual.call(colors: colors, stops: stops) ==
          expected.call(colors: colors, stops: stops);
    }
    return false;
  }

  @override
  Description describe(Description description) =>
      description.addDescriptionOf(expected);
}
