import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';

class PreviewSection extends StatelessWidget {
  final AbstractGradient gradient;

  PreviewSection({Key? key, required this.gradient}) : super(key: key);

  late final List<Color> colorList = gradient.getColorList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient.toFlutterGradient(),
      ),
    );
  }
}
