import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/compact_button.dart';
import 'package:flutter_gradient_generator/ui/widgets/selection_widgets/color_and_stop_selection_widgets/outlined_text_field.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/compact_buttons/direction_button.dart';
import 'package:flutter_gradient_generator/ui/widgets/selection_widgets/selection_container_widget.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class DirectionSelectionWidget extends StatelessWidget {
  DirectionSelectionWidget({
    super.key,
  });

  /// The index of the center alignment icon set in the total icon set list,
  /// [iconSetList]
  final centerGradientDirectionIndexInIconSetList = 1;

  /// The index of the center alignment icon in the center alignment icon set,
  /// [iconSetList].
  ///
  /// This refers to `GradientDirection.center` in the center alignment icon set
  /// and it does not refer `GradientDirection.centerLeft` or `GradientDirection.centerRight`
  ///
  final centerGradientDirectionIndexWithinCenterDirectionSet = 1;

  ///TODO: Move this to [DirectionButton]
  final iconSetList = [
    {
      GradientDirection.topLeft: MaterialCommunityIcons.arrow_top_left,
      GradientDirection.topCenter: MaterialCommunityIcons.arrow_up,
      GradientDirection.topRight: MaterialCommunityIcons.arrow_top_right,
    },
    {
      GradientDirection.centerLeft: MaterialCommunityIcons.arrow_left,
      GradientDirection.center: MaterialCommunityIcons.circle_outline,
      GradientDirection.centerRight: MaterialCommunityIcons.arrow_right,
    },
    {
      GradientDirection.bottomLeft: MaterialCommunityIcons.arrow_bottom_left,
      GradientDirection.bottomCenter: MaterialCommunityIcons.arrow_down,
      GradientDirection.bottomRight: MaterialCommunityIcons.arrow_bottom_right,
    }
  ];

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);

    final gradientViewModel = context.watch<GradientViewModel>();

    final gradient = gradientViewModel.gradient;

    final gradientStyle = gradient.getGradientStyle();
    final selectedGradientDirection = gradient.getGradientDirection();

    final compactButtonMargin = appDimensions.compactButtonMargin;

    return SelectionWidgetContainer(
      title: AppStrings.direction,
      selectionWidget: Column(
        children: [
          ...iconSetList.map(
            (Map<GradientDirection, IconData> gradientDirectionToIconSetMap) {
              final iconSetIndex =
                  iconSetList.indexOf(gradientDirectionToIconSetMap);
              const firstIconSetIndex = 0;

              return Column(
                children: [
                  if (iconSetIndex != firstIconSetIndex)
                    const SizedBox(height: 8.0),
                  Row(
                      children:
                          gradientDirectionToIconSetMap.values.map((icon) {
                    final iconIndex = gradientDirectionToIconSetMap.values
                        .toList()
                        .indexOf(icon);
                    final gradientDirection =
                        gradientDirectionToIconSetMap.keys.elementAt(iconIndex);

                    const firstIconIndex = 0;

                    final gradientStyleIsLinear =
                        gradientStyle == GradientStyle.linear;

                    final thisIsTheMiddleCenterDirectionButton = iconSetIndex ==
                            centerGradientDirectionIndexInIconSetList &&
                        iconIndex ==
                            centerGradientDirectionIndexWithinCenterDirectionSet;

                    /// Circle radial button is not shown for linear gradients
                    final showDirection = !(gradientStyleIsLinear &&
                        thisIsTheMiddleCenterDirectionButton);

                    return Row(
                      children: [
                        if (iconIndex != firstIconIndex)
                          SizedBox(width: compactButtonMargin),
                        Visibility(
                          visible: showDirection,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: DirectionButton(
                            icon: icon,
                            gradientDirection: gradientDirection,
                            isSelected:
                                gradientDirection == selectedGradientDirection,
                            onGradientDirectionChanged:
                                gradientViewModel.changeGradientDirection,
                          ),
                        ),
                      ],
                    );
                  }).toList()),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          CompactButton.text(
            text: AppStrings.custom,
            onPressed: () {
              gradientViewModel.changeGradientDirectionToCustom();
            },
            foregroundColor: Colors.black,
            backgroundColor:
                selectedGradientDirection is GradientDirectionCustom
                    ? AppColors.grey
                    : Colors.transparent,
            borderSide: BorderSide(
              color: AppColors.grey,
            ),
          ),
          if (selectedGradientDirection
              case final GradientDirectionCustom customDirection)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(AppStrings.alignment),
                const SizedBox(height: 8.0),
                _AlignmentInputGroup(
                  alignment: customDirection.alignment,
                  onAlignmentChanged: (newAlignment) {
                    gradientViewModel.changeGradientDirection(
                      GradientDirectionCustom(
                        alignment: newAlignment,
                        endAlignment: customDirection.endAlignment,
                      ),
                    );
                  },
                ),
                if (gradientStyle == GradientStyle.linear) ...[
                  const SizedBox(height: 8.0),
                  const Text(AppStrings.endAlignment),
                  const SizedBox(height: 8.0),
                  _AlignmentInputGroup(
                    alignment: customDirection.endAlignment,
                    onAlignmentChanged: (newAlignment) {
                      gradientViewModel.changeGradientDirection(
                        GradientDirectionCustom(
                          alignment: customDirection.alignment,
                          endAlignment: newAlignment,
                        ),
                      );
                    },
                  ),
                ]
              ],
            )
        ],
      ),
    );
  }
}

class _AlignmentInputGroup extends StatelessWidget {
  const _AlignmentInputGroup({
    required this.alignment,
    required this.onAlignmentChanged,
  });

  final Alignment alignment;
  final void Function(Alignment) onAlignmentChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(AppStrings.alignmentX),
        const SizedBox(width: 8.0),
        _AlignmentDimensionInput(
          value: alignment.x,
          onValueChanged: (newX) {
            onAlignmentChanged(Alignment(newX, alignment.y));
          },
        ),
        const SizedBox(width: 8.0),
        const Text(AppStrings.alignmentY),
        const SizedBox(width: 8.0),
        _AlignmentDimensionInput(
          value: alignment.y,
          onValueChanged: (newY) {
            onAlignmentChanged(Alignment(alignment.x, newY));
          },
        ),
      ],
    );
  }
}

class _AlignmentDimensionInput extends StatefulWidget {
  const _AlignmentDimensionInput({
    required this.value,
    required this.onValueChanged,
  });

  final double value;
  final void Function(double) onValueChanged;

  @override
  State<_AlignmentDimensionInput> createState() =>
      _AlignmentDimensionInputState();
}

class _AlignmentDimensionInputState extends State<_AlignmentDimensionInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    updateControllerText();
    _controller.addListener(() {
      widget.onValueChanged(double.parse(_controller.text));
    });
  }

  @override
  void didUpdateWidget(covariant _AlignmentDimensionInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != double.parse(_controller.text)) {
      updateControllerText();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void updateControllerText() {
    _controller.text = widget.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      controller: _controller,
      focusNode: _focusNode,
      onTap: () {},
      onTapOutside: (_) {},
      onSubmitted: (_) => {},
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
      ],
    );
  }
}
