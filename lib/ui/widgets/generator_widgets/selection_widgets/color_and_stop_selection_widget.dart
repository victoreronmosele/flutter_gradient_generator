// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/services/gradient_service.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/compact_button.dart';
import 'package:flutter_gradient_generator/ui/widgets/generator_widgets/selection_container_widget.dart';
import 'package:flutter_gradient_generator/ui/widgets/generator_widgets/selection_widgets/color_and_stop_selection_widgets/html_color_input.dart';
import 'package:flutter_gradient_generator/ui/widgets/generator_widgets/selection_widgets/color_and_stop_selection_widgets/stop_text_box.dart';
import 'package:flutter_gradient_generator/utils/color_and_stop_util.dart';

class ColorAndStopSelectionWidget extends StatefulWidget {
  const ColorAndStopSelectionWidget({super.key});

  @override
  State<ColorAndStopSelectionWidget> createState() =>
      _ColorAndStopSelectionWidgetState();
}

class _ColorAndStopSelectionWidgetState
    extends State<ColorAndStopSelectionWidget> {
  late AppDimensions appDimensions;
  late GradientService gradientService;

  double get compactButtonMargin => appDimensions.compactButtonMargin;
  double get compactButtonWidth => appDimensions.compactButtonWidth;
  double get compactButtonHeight => appDimensions.compactButtonHeight;

  List<ColorAndStop> get colorAndStopList =>
      gradientService.gradient.getColorAndStopList();
  int get currentSelectedColorIndex =>
      gradientService.currentSelectedColorIndex;

  double get deleteButtonIconSize => appDimensions.deleteButtonIconSize;

  double get generatorScreenContentWidth =>
      appDimensions.generatorScreenContentWidth;

  @override
  Widget build(BuildContext context) {
    return SelectionWidgetContainer(
      titleWidgetInformation: getTitleWidgetInformation(
        onRandomButtonPressed: () {
          gradientService.randomizeColors();
        },
      ),
      selectionWidget: getSelectionWidget(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appDimensions = AppDimensions.of(context);
    gradientService = GradientServiceProvider.of(context).gradientService;
  }

  Widget getAddColorButton() {
    return SizedBox(
      width: generatorScreenContentWidth,
      child: CompactButton.text(
        onPressed: gradientService.addNewColor,
        backgroundColor: AppColors.grey,
        foregroundColor: Colors.black,
        text: AppStrings.addColor,
      ),
    );
  }

  Widget getColorAndStopDisplaySection() {
    return Column(
      children: List.generate(
        colorAndStopList.length,
        (index) {
          final colorAndStop = colorAndStopList.elementAt(index);

          final (:color, :stop) = colorAndStop;

          final canDeleteColorAndStops = ColorAndStopUtil()
              .isColorAndStopListMoreThanMinimum(colorAndStopList);

          final colorAndStopSelectionWidgetItem = Column(
            children: [
              Container(
                color: index == currentSelectedColorIndex
                    ? color.withOpacity(0.1)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      HtmlColorInput(
                          key: ValueKey(color),
                          initialColor: color,
                          uniqueId: 'color-input$color',
                          onInput: (event) {
                            final eventTarget =
                                event.currentTarget as html.InputElement;
                            final eventTargetValue = eventTarget.value;

                            if (eventTargetValue == null) {
                              return;
                            }

                            final color = ColorAndStopUtil().hexToColor(
                              eventTargetValue,
                            );

                            gradientService.changeColor(
                              newColor: color,
                              currentColorAndStopIndex: index,
                            );
                          }),
                      SizedBox(
                        width: compactButtonMargin,
                      ),
                      StopTextBox(
                        key: UniqueKey(),
                        stop: stop,
                        onStopChanged: (int newStop) {
                          gradientService.changeStop(
                              newStop: newStop,
                              currentColorAndStopIndex: index);
                        },
                        onTap: () {
                          gradientService.currentSelectedColorIndex = index;
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
                                      gradientService
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
