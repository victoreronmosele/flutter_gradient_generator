import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:flutter_gradient_generator/ui/widgets/selection_widgets/selection_container_widget.dart';
import 'package:flutter_gradient_generator/ui/widgets/selection_widgets/color_and_stop_selection_widgets/stop_text_box.dart';
import 'package:flutter_gradient_generator/utils/color_and_stop_util.dart';
import 'package:provider/provider.dart';
import 'package:web_color_picker/web_color_picker.dart';

class ColorAndStopSelectionWidget extends StatefulWidget {
  const ColorAndStopSelectionWidget({super.key});

  @override
  State<ColorAndStopSelectionWidget> createState() =>
      _ColorAndStopSelectionWidgetState();
}

class _ColorAndStopSelectionWidgetState
    extends State<ColorAndStopSelectionWidget> {
  late AppDimensions appDimensions;
  late GradientViewModel gradientViewModelReadOnly;

  double get compactButtonMargin => appDimensions.compactButtonMargin;
  double get compactButtonWidth => appDimensions.compactButtonWidth;
  double get compactButtonHeight => appDimensions.compactButtonHeight;

  double get deleteButtonIconSize => appDimensions.deleteButtonIconSize;

  double get generatorScreenContentWidth =>
      appDimensions.generatorScreenContentWidth;

  @override
  Widget build(BuildContext context) {
    return SelectionWidgetContainer(
      title: AppStrings.colorsAndStops,
      selectionWidget: getSelectionWidget(),
      titleTrailingWidget: getAddColorButton(),
      titleBottomMargin: 2.0,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appDimensions = AppDimensions.of(context);
    gradientViewModelReadOnly = context.read<GradientViewModel>();
  }

  Widget getAddColorButton() {
    return Tooltip(
      message: AppStrings.addColor,
      child: IconButton(
        icon: const Icon(Icons.add),
        onPressed: gradientViewModelReadOnly.addNewColor,
        iconSize: 16.0,
      ),
    );
  }

  Widget getColorAndStopDisplaySection() {
    /// This [Selector] is needed to prevent the [HtmlColorInput] from
    /// rebuilding when the color is changed from the [HtmlColorInput] itself.
    ///
    /// This is because the color picker will be closed when tapped as a result
    /// of the [HtmlColorInput] rebuilding.
    ///
    /// This only happens in Chrome.
    return Selector<GradientViewModel, GradientViewModel>(
      selector: (_, gradientViewModel) => gradientViewModel,
      shouldRebuild: (previous, next) {
        return !next.changeIsFromHtmlColorInput;
      },
      builder: (_, gradientViewModel, ___) {
        final colorAndStopList =
            gradientViewModel.gradient.getColorAndStopList();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            colorAndStopList.length,
            (index) {
              final colorAndStop = colorAndStopList.elementAt(index);

              final color = colorAndStop.color;
              final stop = colorAndStop.stop;

              final canDeleteColorAndStops = ColorAndStopUtil()
                  .isColorAndStopListMoreThanMinimum(colorAndStopList);

              final colorAndStopSelectionWidgetItem = Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        WebColorPicker.builder(
                          key: ValueKey(color),
                          initialColor: color,
                          onInput: (newColor, event) {
                            gradientViewModelReadOnly.changeColor(
                              newColor: newColor,
                              currentColorAndStopIndex: index,
                            );
                          },
                          builder: ((context, selectedColor) {
                            return Container(
                              width: compactButtonWidth,
                              height: compactButtonHeight,
                              decoration: BoxDecoration(
                                color: selectedColor ?? color,
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                  color: AppColors.colorPickerBorder,
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(
                          width: compactButtonMargin,
                        ),
                        StopTextBox(
                          key: UniqueKey(),
                          stop: stop,
                          onStopChanged: (int newStop) {
                            gradientViewModelReadOnly.changeStop(
                                newStop: newStop,
                                currentColorAndStopIndex: index);
                          },
                        ),
                        SizedBox(
                          width: compactButtonMargin,
                        ),
                        SizedBox(
                          width: compactButtonWidth,
                          child: canDeleteColorAndStops
                              ? Center(
                                  child: Tooltip(
                                    message: AppStrings.deleteColor,
                                    waitDuration:
                                        const Duration(milliseconds: 500),
                                    child: InkWell(
                                      radius: deleteButtonIconSize,
                                      onTap: () {
                                        gradientViewModelReadOnly
                                            .deleteSelectedColorAndStopIfMoreThanMinimum(
                                                indexToDelete: index);
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color:
                                            AppColors.darkGrey.withOpacity(0.5),
                                        size: deleteButtonIconSize,
                                        semanticLabel: AppStrings.deleteColor,
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                ],
              );

              return colorAndStopSelectionWidgetItem;
            },
          ),
        );
      },
    );
  }

  Widget getInstructionTopRow() {
    final colorsAndStopsLabelStyle = TextStyle(
      fontSize: 12.0,
      color: Colors.black.withOpacity(0.6),
    );

    return Row(
      children: [
        SizedBox(
          width: compactButtonWidth,
          child: Text(
            AppStrings.tapToEdit,
            textAlign: TextAlign.left,
            style: colorsAndStopsLabelStyle,
          ),
        ),
        SizedBox(
          width: compactButtonMargin,
        ),
        SizedBox(
          width: compactButtonWidth,
          child: Text(
            AppStrings.enterInPercentage,
            textAlign: TextAlign.left,
            style: colorsAndStopsLabelStyle,
          ),
        )
      ],
    );
  }

  Widget getSelectionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getInstructionTopRow(),
        const SizedBox(height: 6),
        getColorAndStopDisplaySection(),
      ],
    );
  }
}
