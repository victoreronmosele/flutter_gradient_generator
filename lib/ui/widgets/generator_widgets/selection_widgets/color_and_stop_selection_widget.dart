import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/ui/util/new_color_generator/new_color_generator_interface.dart';
import 'package:flutter_gradient_generator/ui/util/new_color_generator/new_color_generator.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/abstract_random_color_generator.dart';
import 'package:flutter_gradient_generator/ui/util/color_picker/color_picker_interface.dart';
import 'package:flutter_gradient_generator/ui/util/color_picker/cyclop_color_picker.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/random_color_generator.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/compact_button.dart';
import 'package:flutter_gradient_generator/ui/widgets/generator_widgets/selection_container_widget.dart';
import 'package:flutter_gradient_generator/ui/widgets/generator_widgets/selection_widgets/color_and_stop_selection_widgets/stop_text_box.dart';
import 'package:flutter_gradient_generator/utils/color_and_stop_util.dart';

enum ColorAndStopAdditionOrDeletionOperation {
  addition,
  deletion,
}

class ColorAndStopSelectionWidget extends StatefulWidget {
  const ColorAndStopSelectionWidget({
    Key? key,
    required this.colorAndStopList,
    required this.currentSelectedColorIndex,
    required this.onColorAndStopListChanged,
    required this.onNewColorAndStopAdded,
    required this.onColorAndStopDeleteButtonPressed,
  }) : super(key: key);

  final List<ColorAndStop> colorAndStopList;
  final int currentSelectedColorIndex;
  final void Function(List<ColorAndStop>, {required int index})
      onColorAndStopListChanged;
  final void Function(ColorAndStop) onNewColorAndStopAdded;
  final void Function({required int indexToDelete})
      onColorAndStopDeleteButtonPressed;

  @override
  State<ColorAndStopSelectionWidget> createState() =>
      _ColorAndStopSelectionWidgetState();
}

class _ColorAndStopSelectionWidgetState
    extends State<ColorAndStopSelectionWidget>
    with SingleTickerProviderStateMixin {
  late final CurvedAnimation _curvedAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  final ColorPickerInterface colorPicker = const CyclopColorPicker();

  final AbstractRandomColorGenerator randomColorGenerator =
      const RandomColorGenerator();

  final NewColorGeneratorInterface newColorGenerator = NewColorGenerator();

  bool get canDeleteColorAndStop => ColorAndStopUtil()
      .isColorAndStopListMoreThanMinimum(colorAndStopListFromWidget);

  late int currentSelectedColorIndex;

  late final AnimationController _animationController;
  late final Animation<double> _colorAndStopAddedOrDeletedOpacity;
  late final Animation<double> _colorAndStopAddedOrDeletedSizeFactor;

  /// This is the source of truth for the actual [ColorAndStop]s that are
  /// currently being showned on the [GeneratorSection].
  List<ColorAndStop> get colorAndStopListFromWidget => widget.colorAndStopList;

  /// This is the list of [ColorAndStop]s that was previously showned on the
  /// [GeneratorSection].
  ///
  /// It is non-null when the [colorAndStopListFromWidget] is changed since at the first
  /// build, the [previousColorAndStopList] is null.
  ///
  /// Changes to the [colorAndStopListFromWidget] are detected in the [didUpdateWidget]
  /// and they could be:
  /// - Adding a [ColorAndStop]
  /// - Deleting a [ColorAndStop]
  /// - Changing a [ColorAndStop]
  /// - Gnerating a new set of [ColorAndStop] like when the user taps the random button.
  List<ColorAndStop>? previousColorAndStopList;

  @override
  void initState() {
    super.initState();

    currentSelectedColorIndex = widget.currentSelectedColorIndex;

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    _colorAndStopAddedOrDeletedOpacity = _curvedAnimation;
    _colorAndStopAddedOrDeletedSizeFactor = _curvedAnimation;
  }

  @override
  void didUpdateWidget(covariant ColorAndStopSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    currentSelectedColorIndex = widget.currentSelectedColorIndex;

    previousColorAndStopList = oldWidget.colorAndStopList;

    /// This tells us whether a new [ColorAndStop] has been added to or deleted
    /// from the [colorAndStopList].
    ///
    /// In other [ColorAndStop]s list modification cases like generating
    /// random [ColorAndStop]s, the length of the [colorAndStopList] will be
    /// the same as the [previousColorAndStopList].
    ///
    final colorAndStopListWasChangedByAddingOrDeleting =
        previousColorAndStopList!.length != colorAndStopListFromWidget.length;

    if (colorAndStopListWasChangedByAddingOrDeleting) {
      final newColorAndStopWasAdded = colorAndStopListFromWidget.length >
          (previousColorAndStopList!.length);

      if (newColorAndStopWasAdded) {
        _animationController.reset();
        _animationController.forward();
      } else {
        _animationController.value = 1.0;
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppDimensions appDimensions = AppDimensions.of(context);

    final compactButtonWidth = appDimensions.compactButtonWidth;
    final compactButtonMargin = appDimensions.compactButtonMargin;

    final generatorScreenContentWidth =
        appDimensions.generatorScreenContentWidth;

    final colorsAndStopsLabelStyle = TextStyle(
      fontSize: 12.0,
      color: Colors.black.withOpacity(0.6),
    );

    const deleteButtonIconSize = 16.0;

    /// This is the list of [ColorAndStop]s that is used only for the animation
    /// when adding or deleting a [ColorAndStop].
    ///
    final List<ColorAndStop> colorAndStopListForAnimation;

    ColorAndStop? addedOrDeletedColorAndStop;

    ColorAndStopAdditionOrDeletionOperation?
        addedOrDeletedColorAndStopOperation;

    if (previousColorAndStopList != null) {
      /// This tells us whether a new [ColorAndStop] has been added to or deleted
      /// from the [colorAndStopList].
      ///
      /// In other [ColorAndStop]s list modification cases like generating
      /// random [ColorAndStop]s, the length of the [colorAndStopList] will be
      /// the same as the [previousColorAndStopList].
      ///
      final colorAndStopListWasChangedByAddingOrDeleting =
          previousColorAndStopList!.length != colorAndStopListFromWidget.length;

      if (colorAndStopListWasChangedByAddingOrDeleting) {
        final newColorAndStopWasAdded = colorAndStopListFromWidget.length >
            (previousColorAndStopList!.length);

        if (newColorAndStopWasAdded) {
          addedOrDeletedColorAndStop = colorAndStopListFromWidget
              .where((element) => !previousColorAndStopList!.contains(element))
              .first;
          addedOrDeletedColorAndStopOperation =
              ColorAndStopAdditionOrDeletionOperation.addition;

          /// [colorAndStopListForAnimation] is set to the [colorAndStopList]
          /// because it holds the newly added [ColorAndStop].
          colorAndStopListForAnimation = colorAndStopListFromWidget;
        } else {
          addedOrDeletedColorAndStop = previousColorAndStopList!
              .where((element) => !colorAndStopListFromWidget.contains(element))
              .first;
          addedOrDeletedColorAndStopOperation =
              ColorAndStopAdditionOrDeletionOperation.deletion;

          /// [colorAndStopListForAnimation] is set to the [previousColorAndStopList]
          /// because it holds the deleted [ColorAndStop].
          colorAndStopListForAnimation = previousColorAndStopList!;
        }
      } else {
        /// [colorAndStopListForAnimation] is set to the [colorAndStopList]
        /// since the [colorAndStopList] was not changed by adding or deleting
        ///
        /// This could be when the user changes the stop value of a [ColorAndStop]
        /// or when the random [ColorAndStop]s are generated.
        colorAndStopListForAnimation = colorAndStopListFromWidget;
      }
    } else {
      /// [colorAndStopListForAnimation] is set to the [colorAndStopList]
      /// since the [previousColorAndStopList] is null.
      colorAndStopListForAnimation = colorAndStopListFromWidget;
    }

    ({String mainTitle, CompactButton trailingActionWidget})
        getTitleWidgetInformation() {
      return (
        mainTitle: AppStrings.colorsAndStops,
        trailingActionWidget: CompactButton.text(
          onPressed: () {
            final twoRandomColorsAndStops = randomColorGenerator
                .getRandomColorAndStopsOfCurrentGradientColorAndStopListLength(
                    currentStopList:
                        colorAndStopListFromWidget.map((e) => e.stop).toList());

            widget.onColorAndStopListChanged(twoRandomColorsAndStops,
                index: currentSelectedColorIndex);
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

    Widget getSelectionWidget() {
      Widget getInstructionTopRow() {
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

      Widget getColorAndStopDisplaySection() {
        return Column(
          children: List.generate(
            colorAndStopListForAnimation.length,
            (indexForAnimation) {
              final colorAndStop =
                  colorAndStopListForAnimation.elementAt(indexForAnimation);

              final (:color, :stop) = colorAndStop;

              /// This is the actual index of the [ColorAndStop] in the
              /// [colorAndStopListFromWidget].
              ///
              /// [indexForAnimation] is the index of the [ColorAndStop] in the
              /// [colorAndStopListForAnimation] but we won't use it in actual
              /// logic.
              final actualIndex = colorAndStopListFromWidget.indexOf(
                colorAndStop,
              );

              final thisIsTheAnimatingColorAndStop =
                  addedOrDeletedColorAndStop == colorAndStop;

              void setSelectedColorIndex({required int newlySelectedIndex}) {
                if (newlySelectedIndex != currentSelectedColorIndex) {
                  setState(() {
                    currentSelectedColorIndex = newlySelectedIndex;
                  });
                }
              }

              void selectColor({
                required BuildContext context,
                required int currentColorAndStopIndex,
              }) {
                final (:color, :stop) = colorAndStopListFromWidget
                    .elementAt(currentColorAndStopIndex);

                colorPicker.selectColor(
                    context: context,
                    currentColor: color,
                    onColorSelected: (selectedColor) {
                      final newColorAndStop = (
                        color: selectedColor,
                        stop: stop,
                      );

                      /// Creates a copy of the `colorAndStopList` so modifying the new list does not modify `colorAndStopList`
                      final List<ColorAndStop> newColorAndStopList =
                          List.from(colorAndStopListFromWidget);
                      newColorAndStopList[currentColorAndStopIndex] =
                          newColorAndStop;

                      widget.onColorAndStopListChanged(newColorAndStopList,
                          index: currentColorAndStopIndex);
                    });
              }

              void changeStop({
                required int newStop,
                required int currentColorAndStopIndex,
              }) {
                // ignore: unused_local_variable
                final (:color, :stop) = colorAndStopListFromWidget
                    .elementAt(currentColorAndStopIndex);

                final newColorAndStop = (
                  color: color,
                  stop: newStop,
                );

                /// Creates a copy of the `colorAndStopList` so modifying the new list does not modify `colorAndStopList`
                final List<ColorAndStop> newColorAndStopList =
                    List.from(colorAndStopListFromWidget);
                newColorAndStopList[currentColorAndStopIndex] = newColorAndStop;

                widget.onColorAndStopListChanged(newColorAndStopList,
                    index: currentColorAndStopIndex);
              }

              final colorAndStopSelectionWidgetItem = IgnorePointer(
                ignoring: thisIsTheAnimatingColorAndStop &&
                    addedOrDeletedColorAndStopOperation ==
                        ColorAndStopAdditionOrDeletionOperation.deletion,
                child: Column(
                  children: [
                    Container(
                      color: actualIndex == currentSelectedColorIndex
                          ? color.withOpacity(0.1)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            CompactButton.empty(
                              onPressed: () {
                                setSelectedColorIndex(
                                    newlySelectedIndex: actualIndex);

                                selectColor(
                                  context: context,
                                  currentColorAndStopIndex: actualIndex,
                                );
                              },
                              backgroundColor: color,
                              foregroundColor: Colors.black,
                              borderSide: BorderSide(
                                color: AppColors.grey,
                              ),
                            ),
                            SizedBox(
                              width: compactButtonMargin,
                            ),
                            StopTextBox(
                              key: UniqueKey(),
                              stop: stop,
                              onStopChanged: (int newStop) {
                                changeStop(
                                    newStop: newStop,
                                    currentColorAndStopIndex: actualIndex);
                              },
                              onTap: () {
                                setSelectedColorIndex(
                                    newlySelectedIndex: actualIndex);
                              },
                            ),
                            SizedBox(
                              width: compactButtonMargin,
                            ),
                            SizedBox(
                              width: compactButtonWidth,
                              child: canDeleteColorAndStop
                                  ? Center(
                                      child: Tooltip(
                                        message: AppStrings.deleteColor,
                                        waitDuration:
                                            const Duration(milliseconds: 500),
                                        child: InkWell(
                                          radius: deleteButtonIconSize,
                                          onTap: () {
                                            widget
                                                .onColorAndStopDeleteButtonPressed(
                                                    indexToDelete: actualIndex);
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
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                  ],
                ),
              );

              if (thisIsTheAnimatingColorAndStop) {
                return SizeTransition(
                  sizeFactor: _colorAndStopAddedOrDeletedSizeFactor,
                  child: FadeTransition(
                    opacity: _colorAndStopAddedOrDeletedOpacity,
                    child: colorAndStopSelectionWidgetItem,
                  ),
                );
              }

              return colorAndStopSelectionWidgetItem;
            },
          ),
        );
      }

      Widget getAddColorButton() {
        ({ColorAndStop? startColorAndStop, ColorAndStop? endColorAndStop})
            getColorAndStopsForNewColorAddition() {
          final colorAndStopList = colorAndStopListFromWidget;

          ColorAndStop? startColorAndStop;
          ColorAndStop? endColorAndStop;

          const firstIndex = 0;
          final lastIndex = colorAndStopList.length - 1;

          if (currentSelectedColorIndex == firstIndex) {
            const secondIndex = firstIndex + 1;

            startColorAndStop = colorAndStopList.elementAtOrNull(firstIndex);
            endColorAndStop = colorAndStopList.elementAtOrNull(secondIndex);
          } else if (currentSelectedColorIndex == lastIndex) {
            startColorAndStop =
                colorAndStopList.elementAtOrNull(currentSelectedColorIndex);
            endColorAndStop = null;
          } else {
            final nextIndex = currentSelectedColorIndex + 1;

            startColorAndStop =
                colorAndStopList.elementAtOrNull(currentSelectedColorIndex);
            endColorAndStop = colorAndStopList.elementAtOrNull(nextIndex);
          }

          return (
            startColorAndStop: startColorAndStop,
            endColorAndStop: endColorAndStop
          );
        }

        void addColor({
          required ColorAndStop? startColorAndStop,
          required ColorAndStop? endColorAndStop,
        }) {
          final newColorAndStop =
              newColorGenerator.generateNewColorAndStopBetween(
                  startColorAndStop: startColorAndStop,
                  endColorAndStop: endColorAndStop);

          if (newColorAndStop == null) {
            return;
          }

          widget.onNewColorAndStopAdded(newColorAndStop);
        }

        return SizedBox(
          width: generatorScreenContentWidth,
          child: CompactButton.text(
            onPressed: () {
              final (:startColorAndStop, :endColorAndStop) =
                  getColorAndStopsForNewColorAddition();

              addColor(
                startColorAndStop: startColorAndStop,
                endColorAndStop: endColorAndStop,
              );
            },
            backgroundColor: AppColors.grey,
            foregroundColor: Colors.black,
            text: AppStrings.addColor,
          ),
        );
      }

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

    return SelectionWidgetContainer(
      titleWidgetInformation: getTitleWidgetInformation(),
      selectionWidget: getSelectionWidget(),
    );
  }
}
