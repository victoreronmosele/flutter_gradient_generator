import 'package:flutter/services.dart';

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
