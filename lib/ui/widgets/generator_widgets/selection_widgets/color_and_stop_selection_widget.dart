import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/abstract_random_color_generator.dart';
import 'package:flutter_gradient_generator/ui/util/color_picker/abstract_color_picker.dart';
import 'package:flutter_gradient_generator/ui/util/color_picker/cyclop_color_picker.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/random_color_generator.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/compact_button.dart';

class ColorAndStopSelectionWidget extends StatelessWidget {
  const ColorAndStopSelectionWidget({
    Key? key,
    required this.colorList,
    required this.stopList,
    required this.onColorListChanged,
    required this.onStopListChanged,
  }) : super(key: key);

  final List<Color> colorList;
  final List<int> stopList;
  final void Function(List<Color>) onColorListChanged;
  final void Function(List<int>) onStopListChanged;

  final AbstractColorPicker colorPicker = const CyclopColorPicker();
  final AbstractRandomColorGenerator randomColorGenerator =
      const RandomColorGenerator();

  @override
  Widget build(BuildContext context) {
    final colorsAndStopsLabelStyle = TextStyle(
      fontSize: 12.0,
      color: Colors.black.withOpacity(0.6),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: ((2 * AppDimensions.compactButtonWidth) +
                  AppDimensions.compactButtonMargin),
              child: Text(
                AppStrings.colorsAndStops,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.compactButtonMargin),
            CompactButton(
              onPressed: () {
                final List<Color> twoRandomColors =
                    randomColorGenerator.getTwoRandomColors();

                onColorListChanged(twoRandomColors);
              },
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              borderSide: BorderSide(
                color: AppColors.grey,
              ),
              child: const Text(AppStrings.random),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(
              width: AppDimensions.compactButtonWidth,
              child: Text(
                AppStrings.tapToEdit,
                textAlign: TextAlign.left,
                style: colorsAndStopsLabelStyle,
              ),
            ),
            const SizedBox(
              width: AppDimensions.compactButtonMargin,
            ),
            SizedBox(
              width: AppDimensions.compactButtonWidth,
              child: Text(
                AppStrings.enterInPercentage,
                textAlign: TextAlign.left,
                style: colorsAndStopsLabelStyle,
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children: List.generate(
            colorList.length,
            (index) {
              final Color color = colorList.elementAt(index);
              final int stop = stopList.elementAt(index);

              return Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          CompactButton(
                            onPressed: () {
                              _selectColor(
                                context: context,
                                color: color,
                                index: index,
                              );
                            },
                            backgroundColor: color,
                            foregroundColor: Colors.black,
                            borderSide: BorderSide(
                              color: AppColors.grey,
                            ),
                            child: const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: AppDimensions.compactButtonMargin,
                      ),
                      Column(
                        children: [
                          StopTextBox(
                            stop: stop,
                            onStopChanged: (int newStop) {
                              _changeStop(stop: newStop, index: index);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _selectColor({
    required BuildContext context,
    required Color color,
    required int index,
  }) {
    colorPicker.selectColor(
        context: context,
        currentColor: color,
        onColorSelected: (selectedColor) {
          /// Creates a copy of the `colorList` so modifying the new list does not modify colorList
          final List<Color> newColorList = List.from(colorList);
          newColorList[index] = selectedColor;

          onColorListChanged(newColorList);
        });
  }

  void _changeStop({
    required int stop,
    required int index,
  }) {
    /// Creates a copy of the `stopList` so modifying the new list does not modify stopList
    final List<int> newStopList = List.from(stopList);
    newStopList[index] = stop;

    onStopListChanged(newStopList);
  }
}

/// A [TextField] that holds the stop value for a color on the Gradient. It only
/// allows integers between [maximumInteger] and [minimumInteger].
class StopTextBox extends StatefulWidget {
  const StopTextBox({
    super.key,
    required this.stop,
    required this.onStopChanged,
  });

  final int stop;
  final void Function(int) onStopChanged;

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

    /// Reset the text field tap count when the text field loses focus.
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        textFieldTapCount = 0;
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
      onTap: onTextFieldTap,
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
    if (value == null) {
      return;
    }

    final int? stop = int.tryParse(value);

    if (stop != null) {
      widget.onStopChanged(stop);
    }
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
    return SizedBox(
      width: AppDimensions.compactButtonWidth,
      height: AppDimensions.compactButtonHeight,
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

  get _maximumIntegerAsString => maximumInteger.toString();
  get _maximumIntegerLength => _maximumIntegerAsString.length;

  get _minimumIntegerAsString => minimumInteger.toString();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    /// Gets the length of the new text.
    final newTextLength = newValue.text.length;

    if (newTextLength > _maximumIntegerLength) {
      return oldValue.copyWith(text: _maximumIntegerAsString);
    }

    final newVaultAsInt = int.tryParse(newValue.text);

    if (newVaultAsInt == null) {
      return const TextEditingValue(text: '');
    }

    if (newVaultAsInt > maximumInteger) {
      return TextEditingValue(text: _maximumIntegerAsString);
    }

    if (newVaultAsInt < minimumInteger) {
      return TextEditingValue(text: _minimumIntegerAsString);
    }

    return newValue;
  }
}
