import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/ui/widgets/generator_widgets/selection_widgets/color_and_stop_selection_widgets/outlined_text_field.dart';
import 'package:flutter_gradient_generator/utils/minimum_maximum_integer_input_formatter.dart';

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
