import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:provider/provider.dart';

const _pointerSize = 60.0;
const _pointerIconSize = 24.0;
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
                    onAlignmentChanged: gradientViewModel
                        .changeCustomGradientDirectionAlignment,
                  ),
                  if (gradient.getGradientStyle() == GradientStyle.linear)
                    _AlignmentPicker(
                      gradientViewModel: gradientViewModel,
                      alignment: direction.endAlignment,
                      onAlignmentChanged: gradientViewModel
                          .changeCustomGradientDirectionEndAlignment,
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

class _AlignmentPicker extends StatefulWidget {
  const _AlignmentPicker({
    required this.gradientViewModel,
    required this.alignment,
    required this.onAlignmentChanged,
  });

  final GradientViewModel gradientViewModel;
  final Alignment alignment;
  final ValueChanged<Alignment> onAlignmentChanged;

  @override
  State<_AlignmentPicker> createState() => _AlignmentPickerState();
}

class _AlignmentPickerState extends State<_AlignmentPicker> {
  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final BoxConstraints(:maxWidth, :maxHeight) = constraints;

      void callAlignmentChanged(DragUpdateDetails details) {
        final Offset(:dx, :dy) = details.localPosition;

        widget.onAlignmentChanged(Alignment(
          (dx / maxWidth) * 2 - 1,
          (dy / maxHeight) * 2 - 1,
        ));
      }

      final top = (widget.alignment.y + 1) / 2 * maxHeight - _halfPointerSize;
      final left = (widget.alignment.x + 1) / 2 * maxWidth - _halfPointerSize;

      return GestureDetector(
        onPanUpdate: callAlignmentChanged,
        onTapDown: (_) => setState(() => dragging = true),
        onTapUp: (_) => setState(() => dragging = false),
        onPanEnd: (_) => setState(() => dragging = false),
        child: SizedBox.expand(
          child: Stack(
            children: [
              Positioned(
                top: top,
                left: left,
                width: _pointerSize,
                height: _pointerSize,
                child: MouseRegion(
                  cursor: dragging
                      ? SystemMouseCursors.grabbing
                      : SystemMouseCursors.grab,
                  child: Container(
                    color: Colors.transparent,
                    child: const Center(
                      child: Icon(
                        Icons.add_circle_outline_sharp,
                        size: _pointerIconSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
