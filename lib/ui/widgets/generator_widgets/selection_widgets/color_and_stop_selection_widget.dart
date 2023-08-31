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

class ColorAndStopSelectionWidget extends StatefulWidget {
  const ColorAndStopSelectionWidget({
    Key? key,
    required this.colorAndStopList,
    required this.onColorAndStopListChanged,
    required this.onNewColorAndStopAdded,
    required this.currentSelectedColorIndex,
  }) : super(key: key);

  final List<ColorAndStop> colorAndStopList;
  final void Function(List<ColorAndStop>, {required int index})
      onColorAndStopListChanged;
  final void Function(ColorAndStop) onNewColorAndStopAdded;
  final int currentSelectedColorIndex;

  @override
  State<ColorAndStopSelectionWidget> createState() =>
      _ColorAndStopSelectionWidgetState();
}

class _ColorAndStopSelectionWidgetState
    extends State<ColorAndStopSelectionWidget> {
  final ColorPickerInterface colorPicker = const CyclopColorPicker();

  final AbstractRandomColorGenerator randomColorGenerator =
      const RandomColorGenerator();

  final NewColorGeneratorInterface newColorGenerator = NewColorGenerator();

  late int currentSelectedColorIndex;

  @override
  void initState() {
    super.initState();

    currentSelectedColorIndex = widget.currentSelectedColorIndex;
  }

  @override
  void didUpdateWidget(covariant ColorAndStopSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    currentSelectedColorIndex = widget.currentSelectedColorIndex;
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
    return SelectionWidgetContainer(
      titleWidgetInformation: (
        mainTitle: AppStrings.colorsAndStops,
        trailingActionWidget: CompactButton.text(
          onPressed: () {
            final twoRandomColorsAndStops =
                randomColorGenerator.getTwoRandomColorsAndStops();

            widget.onColorAndStopListChanged(twoRandomColorsAndStops, index: 0);
          },
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          borderSide: BorderSide(
            color: AppColors.grey,
          ),
          text: AppStrings.random,
        ),
      ),
      selectionWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          ),
          const SizedBox(height: 6),
          Column(
            children: List.generate(
              widget.colorAndStopList.length,
              (index) {
                final (:color, :stop) =
                    widget.colorAndStopList.elementAt(index);

                return Column(
                  children: [
                    Container(
                      color: index == currentSelectedColorIndex
                          ? color.withOpacity(0.1)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            CompactButton.empty(
                              onPressed: () {
                                _setSelectedColorIndex(
                                    newlySelectedIndex: index);

                                _selectColor(
                                  context: context,
                                  currentColorAndStopIndex: index,
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
                                _changeStop(
                                    newStop: newStop,
                                    currentColorAndStopIndex: index);
                              },
                              onTap: () {
                                _setSelectedColorIndex(
                                    newlySelectedIndex: index);
                              },
                            ),
                            SizedBox(
                              width: compactButtonMargin,
                            ),
                            SizedBox(
                              width: compactButtonWidth,
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
              },
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          SizedBox(
            width: generatorScreenContentWidth,
            child: CompactButton.text(
              onPressed: () {
                final (:startColorAndStop, :endColorAndStop) =
                    _getColorAndStopsForNewColorAddition();

                _addColor(
                  startColorAndStop: startColorAndStop,
                  endColorAndStop: endColorAndStop,
                );
              },
              backgroundColor: AppColors.grey,
              foregroundColor: Colors.black,
              text: AppStrings.addColor,
            ),
          ),
        ],
      ),
    );
  }

  void _setSelectedColorIndex({required int newlySelectedIndex}) {
    if (newlySelectedIndex != currentSelectedColorIndex) {
      setState(() {
        currentSelectedColorIndex = newlySelectedIndex;
      });
    }
  }

  ({ColorAndStop? startColorAndStop, ColorAndStop? endColorAndStop})
      _getColorAndStopsForNewColorAddition() {
    final colorAndStopList = widget.colorAndStopList;

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

  void _addColor({
    required ColorAndStop? startColorAndStop,
    required ColorAndStop? endColorAndStop,
  }) {
    final newColorAndStop = newColorGenerator.generateNewColorAndStopBetween(
        startColorAndStop: startColorAndStop, endColorAndStop: endColorAndStop);

    if (newColorAndStop == null) {
      return;
    }

    widget.onNewColorAndStopAdded(newColorAndStop);
  }

  void _selectColor({
    required BuildContext context,
    required int currentColorAndStopIndex,
  }) {
    final (:color, :stop) =
        widget.colorAndStopList.elementAt(currentColorAndStopIndex);

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
              List.from(widget.colorAndStopList);
          newColorAndStopList[currentColorAndStopIndex] = newColorAndStop;

          widget.onColorAndStopListChanged(newColorAndStopList,
              index: currentColorAndStopIndex);
        });
  }

  void _changeStop({
    required int newStop,
    required int currentColorAndStopIndex,
  }) {
    // ignore: unused_local_variable
    final (:color, :stop) =
        widget.colorAndStopList.elementAt(currentColorAndStopIndex);

    final newColorAndStop = (
      color: color,
      stop: newStop,
    );

    /// Creates a copy of the `colorAndStopList` so modifying the new list does not modify `colorAndStopList`
    final List<ColorAndStop> newColorAndStopList =
        List.from(widget.colorAndStopList);
    newColorAndStopList[currentColorAndStopIndex] = newColorAndStop;

    widget.onColorAndStopListChanged(newColorAndStopList,
        index: currentColorAndStopIndex);
  }
}

/// A [TextField] that holds the stop value for a color on the Gradient. It only
/// allows integers between [maximumInteger] and [minimumInteger].
class StopTextBox extends StatefulWidget {
  const StopTextBox({
    super.key,
    required this.stop,
    required this.onStopChanged,
    required this.onTap,
  });

  final int stop;
  final void Function(int) onStopChanged;
  final void Function() onTap;

  @override
  State<StopTextBox> createState() => _StopTextBoxState();
}

class _StopTextBoxState extends State<StopTextBox> {
  final maximumInteger = 100;

  final minumuInteger = 0;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  int get maximumIntegerLength => maximumInteger.toString().length;

  List<TextInputFormatter> get inputFormatters => [
        MinimumMaximumIntegerInputFormatter(
            maximumInteger: maximumInteger, minimumInteger: minumuInteger),
        LengthLimitingTextInputFormatter(maximumIntegerLength),
      ];

  /// Holds the number of times the user has tapped the text field in a row.
  ///
  /// This does not include taps outside of the text field.
  int textFieldTapCount = 0;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.stop.toString();

    _focusNode.addListener(() {
      /// Run when the text field loses focus.
      if (!_focusNode.hasFocus) {
        /// Reset the text field tap count.
        textFieldTapCount = 0;

        /// Submit the stop value.
        ///
        /// This was added to capture when another text field is tapped because
        /// the [onTapOutside] callback is not called when another text field is
        /// tapped.
        final text = _controller.text;

        onStopSubmitted(text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    textFieldTapCount = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      inputFormatters: inputFormatters,
      onSubmitted: onStopSubmitted,
      onTap: () {
        widget.onTap();
        onTextFieldTap();
      },
      onTapOutside: onTapOutside,
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.number,
    );
  }

  /// Called when the user taps outside of the text field.
  ///
  /// This helps to submit the stop value when the user taps outside of the
  /// text field.
  void onTapOutside(PointerDownEvent _) {
    /// Check if the text field is focused.
    final textFieldIsFocused = _focusNode.hasFocus;

    /// We want to submit the stop value if the text field is focused.
    /// No need to submit the stop value if the text field is not focused.
    if (textFieldIsFocused) {
      /// Unfocus the text field since the user tapped outside of it and
      /// the stop will be submitted.
      _focusNode.unfocus();

      /// Get the stop value from the text field.
      final text = _controller.text;

      /// Submit the stop value.
      onStopSubmitted(text);
    }
  }

  /// Called when the user has submitted the stop text in the text field.
  void onStopSubmitted(String? value) {
    /// Reset the stop to the previous stop if the value is null or empty.
    if (value == null || value.isEmpty) {
      resetStopToPreviousStop();

      return;
    }

    final int? stop = int.tryParse(value);

    /// Reset the stop to the previous stop if the stop is null.
    if (stop == null) {
      resetStopToPreviousStop();

      return;
    }

    /// Update the stop value.
    widget.onStopChanged(stop);

    return;
  }

  /// Resets the stop value to the previous stop value
  void resetStopToPreviousStop() {
    final previousStop = widget.stop;

    _controller.text = previousStop.toString();

    widget.onStopChanged(previousStop);
  }

  /// Called when the user taps on the text field.
  void onTextFieldTap() {
    /// Select the entire text in the text field the first time the user taps
    /// the text field.
    if (textFieldTapCount == 0) {
      selectEntireText();
    }

    /// Increment the number of times the user has tapped the text field.
    textFieldTapCount++;
  }

  /// Selects the entire text in the text field.
  void selectEntireText() {
    final textLength = _controller.text.length;

    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: textLength,
    );
  }
}

/// A [TextField] with an [OutlineInputBorder].
class OutlinedTextField extends StatelessWidget {
  const OutlinedTextField({
    super.key,
    required this.inputFormatters,
    required this.onSubmitted,
    required this.onTap,
    required this.controller,
    required this.focusNode,
    required this.onTapOutside,
    this.keyboardType,
  });

  final List<TextInputFormatter> inputFormatters;
  final ValueChanged<String?> onSubmitted;
  final void Function() onTap;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(PointerDownEvent) onTapOutside;

  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final AppDimensions appDimensions = AppDimensions.of(context);

    final compactButtonWidth = appDimensions.compactButtonWidth;
    final compactButtonHeight = appDimensions.compactButtonHeight;

    return SizedBox(
      width: compactButtonWidth,
      height: compactButtonHeight,
      child: TextField(
          inputFormatters: inputFormatters,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.zero,
          ),
          keyboardType: keyboardType,
          textAlign: TextAlign.center,
          onSubmitted: onSubmitted,
          controller: controller,
          focusNode: focusNode,
          onTap: onTap,
          onTapOutside: onTapOutside),
    );
  }
}

/// A [TextInputFormatter] that limits the input to a minimum and maximum integer.
///
/// If the input is greater than [maximumInteger], [maximumInteger],  is returned.
/// If the input is less than [minimumInteger], [minimumInteger] is returned.
class MinimumMaximumIntegerInputFormatter extends TextInputFormatter {
  MinimumMaximumIntegerInputFormatter({
    required this.maximumInteger,
    required this.minimumInteger,
  });

  final int maximumInteger;
  final int minimumInteger;

  String get _maximumIntegerAsString => maximumInteger.toString();
  int get _maximumIntegerLength => _maximumIntegerAsString.length;

  String get _minimumIntegerAsString => minimumInteger.toString();
  int get _minimumIntegerLength => _minimumIntegerAsString.length;

  /// Returns the [TextEditingValue] with the maximum integer as the text.
  TextEditingValue get _maximumIntegerTextEditingValue => TextEditingValue(
      text: _maximumIntegerAsString,
      selection: TextSelection.collapsed(offset: _maximumIntegerLength));

  /// Returns the [TextEditingValue] with the minimum integer as the text.
  TextEditingValue get _minimumIntegerTextEditingValue => TextEditingValue(
      text: _minimumIntegerAsString,
      selection: TextSelection.collapsed(offset: _minimumIntegerLength));

  /// Returns an empty [TextEditingValue].
  TextEditingValue get _emptyTextEditingValue => const TextEditingValue();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    /// Gets the length of the new text.
    final newTextLength = newValue.text.length;

    /// If the new text length is greater than the maximum integer length,
    /// return the [_maximumIntegerTextEditingValue]
    ///
    /// Example:
    /// Assume:
    /// - the maximum integer is 100.
    /// - the user types 1000.
    ///
    /// The new text length is 4, which is greater than the maximum integer length
    /// of 3. Therefore, return the [_maximumIntegerTextEditingValue].
    if (newTextLength > _maximumIntegerLength) {
      return _maximumIntegerTextEditingValue;
    }

    /// Try to parse the new text as an integer.
    final newVaultAsInt = int.tryParse(newValue.text);

    /// [newVaultAsInt] is null if the new text is not a valid integer.
    /// So return [_emptyTextEditingValue]
    if (newVaultAsInt == null) {
      return _emptyTextEditingValue;
    }

    /// If the new integer is greater than the maximum integer, return the
    /// [_maximumIntegerTextEditingValue].
    if (newVaultAsInt > maximumInteger) {
      return _maximumIntegerTextEditingValue;
    }

    /// If the new integer is less than the minimum integer, return the
    /// [_minimumIntegerTextEditingValue].
    if (newVaultAsInt < minimumInteger) {
      return _minimumIntegerTextEditingValue;
    }

    /// If the new integer is valid, return [newValue]
    return newValue;
  }
}
