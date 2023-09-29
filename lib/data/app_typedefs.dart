import 'package:flutter/material.dart';

/// [Stop] is an integer representing a Gradient color stop.
///
/// It is a value between 0 and 100.
typedef Stop = int;

/// [ColorAndStop] is a record that holds a [Color] and a [Stop].
typedef ColorAndStop = ({
  Color color,
  Stop stop,
});
