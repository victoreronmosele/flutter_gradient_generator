import 'package:flutter_gradient_generator/data/app_strings.dart';

enum GradientStyle {
  linear(title: AppStrings.linear),
  radial(title: AppStrings.radial),
  sweep(title: AppStrings.sweep);

  const GradientStyle({required this.title});

  final String title;
}
