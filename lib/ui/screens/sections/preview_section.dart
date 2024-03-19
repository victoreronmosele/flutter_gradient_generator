import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:provider/provider.dart';

const _pointerSize = 24.0;
const _halfPointerSize = _pointerSize / 2;

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

    final gradientViewModel = context.watch<GradientViewModel>();
    final gradient = gradientViewModel.gradient;

    final flutterGradient = gradient.toFlutterGradient();

    return Center(
      child: Container(
        color: AppColors.previewBackground,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(
              Size.square(
                previewWidgetSize,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: flutterGradient,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                ),
                if (gradient.getGradientDirection()
                    case final GradientDirectionCustom direction) ...[
                  _AlignmentPicker(
                    gradientViewModel: gradientViewModel,
                    alignment: direction.alignment,
                    onAlignmentChanged: (newAlignment) {
                      gradientViewModel.changeGradientDirection(
                        GradientDirection.custom(
                          alignment: newAlignment,
                          endAlignment: direction.endAlignment,
                        ),
                      );
                    },
                  ),
                  if (gradient.getGradientStyle() == GradientStyle.linear)
                    _AlignmentPicker(
                      gradientViewModel: gradientViewModel,
                      alignment: direction.endAlignment,
                      onAlignmentChanged: (newAlignment) {
                        gradientViewModel.changeGradientDirection(
                          GradientDirection.custom(
                            alignment: direction.alignment,
                            endAlignment: newAlignment,
                          ),
                        );
                      },
                    ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AlignmentPicker extends StatelessWidget {
  const _AlignmentPicker({
    required this.gradientViewModel,
    required this.alignment,
    required this.onAlignmentChanged,
  });

  final GradientViewModel gradientViewModel;
  final Alignment alignment;
  final ValueChanged<Alignment> onAlignmentChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final BoxConstraints(:maxWidth, :maxHeight) = constraints;

      void callAlignmentChanged(DragUpdateDetails details) {
        final Offset(:dx, :dy) = details.localPosition;

        onAlignmentChanged(Alignment(
          (dx / maxWidth) * 2 - 1,
          (dy / maxHeight) * 2 - 1,
        ));
      }

      return GestureDetector(
        onVerticalDragUpdate: callAlignmentChanged,
        onHorizontalDragUpdate: callAlignmentChanged,
        child: SizedBox.expand(
          child: Stack(
            children: [
              Positioned(
                top: (alignment.y + 1) / 2 * maxHeight - _halfPointerSize,
                left: (alignment.x + 1) / 2 * maxWidth - _halfPointerSize,
                width: _pointerSize,
                height: _pointerSize,
                child: const Icon(
                  Icons.add_circle_outline_sharp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
