// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/compact_button.dart';
import 'package:flutter_gradient_generator/ui/widgets/generator_widgets/selection_container_widget.dart';
import 'package:flutter_gradient_generator/ui/widgets/generator_widgets/selection_widgets/color_and_stop_selection_widgets/stop_text_box.dart';
import 'package:flutter_gradient_generator/utils/color_and_stop_util.dart';
import 'package:html_color_input/html_color_input.dart';
import 'package:provider/provider.dart';

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
      titleWidgetInformation: getTitleWidgetInformation(
        onRandomButtonPressed: () {
          gradientViewModelReadOnly.randomizeColors();
        },
      ),
      selectionWidget: getSelectionWidget(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appDimensions = AppDimensions.of(context);
    gradientViewModelReadOnly = context.read<GradientViewModel>();
  }

  Widget getAddColorButton() {
    return SizedBox(
      width: generatorScreenContentWidth,
      child: CompactButton.text(
        onPressed: gradientViewModelReadOnly.addNewColor,
        backgroundColor: AppColors.grey,
        foregroundColor: Colors.black,
        text: AppStrings.addColor,
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Selector<GradientViewModel, GradientViewModel>(
                          selector: (_, gradientViewModel) => gradientViewModel,
                          shouldRebuild: (previous, next) {
                            return true;
                          },
                          builder: (_, gradientViewModel, __) {
                            final currentSelectedColorIndexFromBuilder =
                                gradientViewModel.currentSelectedColorIndex;

                            final colorAndStopListFromBuilder =
                                gradientViewModel.gradient
                                    .getColorAndStopList();

                            final currentSelectorColorAndStopFromBuilder =
                                colorAndStopListFromBuilder.elementAt(
                                    currentSelectedColorIndexFromBuilder);

                            // ignore: unused_local_variable
                            final (color: colorFromBuilder, stop: _) =
                                currentSelectorColorAndStopFromBuilder;

                            return Container(
                              color:
                                  index == currentSelectedColorIndexFromBuilder
                                      ? colorFromBuilder.withOpacity(0.1)
                                      : null,
                              height: compactButtonHeight,
                              width: generatorScreenContentWidth,
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            HtmlColorInput(
                              key: ValueKey(color),
                              initialColor: color,
                              onInput: (newColor, event) {
                                gradientViewModelReadOnly.changeColor(
                                  newColor: newColor,
                                  currentColorAndStopIndex: index,
                                );
                              },
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
                              onTap: () {
                                gradientViewModelReadOnly
                                    .changeCurrentSelectedColorIndex(
                                        newCurrentSelectedColorIndex: index,
                                        isChangeFromHtmlColorInput: false);
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
                                            color: AppColors.darkGrey
                                                .withOpacity(0.5),
                                            size: deleteButtonIconSize,
                                            semanticLabel:
                                                AppStrings.deleteColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
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
        const SizedBox(
          height: 8.0,
        ),
        getAddColorButton(),
      ],
    );
  }

  ({String mainTitle, CompactButton trailingActionWidget})
      getTitleWidgetInformation(
          {required void Function() onRandomButtonPressed}) {
    return (
      mainTitle: AppStrings.colorsAndStops,
      trailingActionWidget: CompactButton.text(
        onPressed: () {
          onRandomButtonPressed();
        },
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        borderSide: BorderSide(
          color: AppColors.grey,
        ),
        text: AppStrings.random,
      ),
    );
  }
}
