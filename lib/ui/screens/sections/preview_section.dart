import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:provider/provider.dart';

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
    final screenSize = MediaQuery.of(context).size;

    final screenHeight = screenSize.height;

    final previewWidgetSize = screenHeight / 1.5;

    final gradient = context.select<GradientViewModel, AbstractGradient>(
        (GradientViewModel viewModel) => viewModel.gradient);

    final flutterGradient = gradient.toFlutterGradient();

    return Center(
      child: Container(
        color: AppColors.previewBackground,
        child: Center(
          child: Container(
            constraints: BoxConstraints.tight(
              Size.square(
                previewWidgetSize,
              ),
            ),
            decoration: BoxDecoration(
              gradient: flutterGradient,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}
