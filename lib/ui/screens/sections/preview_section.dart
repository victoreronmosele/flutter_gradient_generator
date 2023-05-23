import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';

class PreviewSection extends StatelessWidget {
  final AbstractGradient gradient;

  /// The border radius of the preview section.
  final double borderRadius;

  PreviewSection({Key? key, required this.gradient, required this.borderRadius})
      : super(key: key);

  late final List<Color> colorList = gradient.getColorList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient.toFlutterGradient(),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
