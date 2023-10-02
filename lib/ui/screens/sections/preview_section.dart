import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/services/gradient_service.dart';

class PreviewSection extends StatelessWidget {
  static const _portraitBorderRadius = 16.0;
  static const _landscapeBorderRadius = 0.0;

  /// The border radius of the preview section.
  final double borderRadius;

  const PreviewSection._({required this.borderRadius});

  /// Creates a [PreviewSection] for portrait mode.
  const PreviewSection.portrait({
    Key? key,
  }) : this._(borderRadius: _portraitBorderRadius);

  /// Creates a [PreviewSection] for landscape mode.
  const PreviewSection.landscape({
    Key? key,
  }) : this._(borderRadius: _landscapeBorderRadius);

  @override
  Widget build(BuildContext context) {
    final gradientService = GradientServiceProvider.of(context).gradientService;

    final gradient = gradientService.gradient;
    final flutterGradient = gradient.toFlutterGradient();

    return Container(
      decoration: BoxDecoration(
        gradient: flutterGradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
