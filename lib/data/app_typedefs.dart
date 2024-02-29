import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';

/// An integer representing a Gradient color stop.
///
/// It is a value between 0 and 100.
typedef Stop = int;

/// A record that holds a [Color] and a [Stop].
typedef ColorAndStop = ({
  Color color,
  Stop stop,
});

/// A function that converts [colors] and optional
/// [stops] to a [Gradient] from Flutter's painting library.
typedef FlutterGradientConverter = Gradient Function(
    {required List<Color> colors, List<double>? stops});

/// A record that holds a [Gradient] and a [DateTime] timestamp when the
/// gradient was generated.
typedef TimeStampedGradient = ({
  AbstractGradient gradient,
  DateTime timeStamp,
});
