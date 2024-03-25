import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/generated/gradient_samples.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/models/gradient_factory.dart';
import 'package:flutter_gradient_generator/models/linear_style_gradient.dart';
import 'package:flutter_gradient_generator/ui/util/new_color_generator/new_color_generator.dart';
import 'package:flutter_gradient_generator/ui/util/new_color_generator/new_color_generator_interface.dart';
import 'package:flutter_gradient_generator/utils/color_and_stop_util.dart';

class GradientViewModel with ChangeNotifier {
  final _colorAndStopUtil = ColorAndStopUtil();

  /// The default gradient shown when the app is first opened.
  late final AbstractGradient defaultGradient = LinearStyleGradient(
      colorAndStopList: AppColors.initialColorAndStopList,
      gradientDirection: GradientDirection.topLeft);

  final NewColorGeneratorInterface _newColorGenerator = NewColorGenerator();

  AbstractGradient get gradient => _gradient;
  late AbstractGradient _gradient = defaultGradient;

  /// Whether the color change is from the [HtmlColorInput] widget.
  ///
  /// This is needed to prevent rebuilds in listening widgets.
  ///
  /// It is used specifically to prevent the [HtmlColorInput] widget from closing
  /// when tapped.
  bool changeIsFromHtmlColorInput = false;

  void addNewColor() {
    final lastColorAndStop = _gradient.getColorAndStopList().last;
    final newColorAndStop = _newColorGenerator.generateNewColorAndStop(
      seedColorAndStop: lastColorAndStop,
    );

    onNewColorAndStopAdded(newColorAndStop);
  }

  void changeColor({
    required Color newColor,
    required int currentColorAndStopIndex,
  }) {
    final colorAndStopList = _gradient.getColorAndStopList();

    // ignore: unused_local_variable
    final (color: _, stop: stop) =
        colorAndStopList.elementAt(currentColorAndStopIndex);

    final newColorAndStop = (
      color: newColor,
      stop: stop,
    );

    /// Creates a copy of the `colorAndStopList` so modifying the new list does not modify `colorAndStopList`
    final List<ColorAndStop> newColorAndStopList = List.from(colorAndStopList);
    newColorAndStopList[currentColorAndStopIndex] = newColorAndStop;

    _onColorAndStopListChanged(
      newColorAndStopList,
      isChangeFromHtmlColorInput: true,
    );
  }

  void changeStop({
    required int newStop,
    required int currentColorAndStopIndex,
  }) {
    final colorAndStopList = _gradient.getColorAndStopList();

    final (color: color, stop: _) =
        colorAndStopList.elementAt(currentColorAndStopIndex);

    final newColorAndStop = (
      color: color,
      stop: newStop,
    );

    /// Creates a copy of the `colorAndStopList` so modifying the new list does not modify `colorAndStopList`
    final List<ColorAndStop> newColorAndStopList = List.from(colorAndStopList);
    newColorAndStopList[currentColorAndStopIndex] = newColorAndStop;

    _onColorAndStopListChanged(
      newColorAndStopList,
      isChangeFromHtmlColorInput: false,
    );
  }

  /// Deletes the currently selected [ColorAndStop] if there are more than
  /// [minimumNumberOfColors] colors in the gradient.
  void deleteSelectedColorAndStopIfMoreThanMinimum(
      {required int indexToDelete}) {
    final currentColorAndStopList = _gradient.getColorAndStopList();

    final colorAndStopListIsMoreThanMinimum = _colorAndStopUtil
        .isColorAndStopListMoreThanMinimum(currentColorAndStopList);

    /// Only delete the currently selected [ColorAndStop] if there are more than
    /// [minimumNumberOfColors] colors in the gradient.
    if (colorAndStopListIsMoreThanMinimum) {
      final colorAndStopToDelete = currentColorAndStopList[indexToDelete];

      _onColorAndStopDeleted(colorAndStopToDelete);
    }
  }

  void changeCustomGradientDirectionAlignment(Alignment alignment) {
    if (_gradient.getGradientDirection()
        case final GradientDirectionCustom customDirection) {
      final newGradientDirection = GradientDirection.custom(
        alignment: alignment,
        endAlignment: customDirection.endAlignment,
      );

      changeGradientDirection(newGradientDirection);
    }
  }

  void changeCustomGradientDirectionEndAlignment(Alignment endAlignment) {
    if (_gradient.getGradientDirection()
        case final GradientDirectionCustom customDirection) {
      final newGradientDirection = GradientDirection.custom(
        alignment: customDirection.alignment,
        endAlignment: endAlignment,
      );

      changeGradientDirection(newGradientDirection);
    }
  }

  void changeGradientDirection(GradientDirection newGradientDirection) {
    if (_gradient.getGradientDirection() != newGradientDirection) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: _gradient.getGradientStyle(),
        colorAndStopList: _gradient.getColorAndStopList(),
        gradientDirection: newGradientDirection,
      );

      _gradient = newGradient;

      notifyListeners();
    }
  }

  void changeGradientStyle(GradientStyle newGradientStyle) {
    if (_gradient.getGradientStyle() != newGradientStyle) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: newGradientStyle,
        colorAndStopList: _gradient.getColorAndStopList(),
        gradientDirection: _gradient.getGradientDirection(),
      );

      _gradient = newGradient;

      notifyListeners();
    }
  }

  void setNewFlutterGradient(Gradient newFlutterGradient) {
    final colorCount = newFlutterGradient.colors.length;

    final colorAndStopList = newFlutterGradient.colors.mapIndexed(
      (index, color) {
        final stop = ((100 * index) / (colorCount - 1)).ceil();

        return (color: color, stop: stop);
      },
    );

    _gradient = GradientFactory().getGradient(
      gradientStyle: _gradient.getGradientStyle(),
      colorAndStopList: colorAndStopList.toList(),
      gradientDirection: _gradient.getGradientDirection(),
    );

    notifyListeners();
  }

  void onNewColorAndStopAdded(ColorAndStop newColorAndStop) {
    final List<ColorAndStop> colorAndStopListCopy =
        List<ColorAndStop>.from(_gradient.getColorAndStopList());

    colorAndStopListCopy.add(newColorAndStop);

    final updatedColorAndStopList = colorAndStopListCopy;

    _onColorAndStopListChanged(
      updatedColorAndStopList,
      isChangeFromHtmlColorInput: false,
    );
  }

  void displayRandomGradientFromSamples() {
    final Random random = Random();

    final randomGradientFromSamples =
        gradientSamples[random.nextInt(gradientSamples.length)];

    final flutterGradientConverter = gradient.getFlutterGradientConverter();

    final randomGradient = flutterGradientConverter(
      colors: randomGradientFromSamples.colors,
    );

    setNewFlutterGradient(randomGradient);
  }

  void _onColorAndStopDeleted(ColorAndStop colorAndStopToDelete) {
    final List<ColorAndStop> colorAndStopListCopy =
        List<ColorAndStop>.from(_gradient.getColorAndStopList());

    colorAndStopListCopy.remove(colorAndStopToDelete);

    final updatedColorAndStopList = colorAndStopListCopy;

    _onColorAndStopListChanged(
      updatedColorAndStopList,
      isChangeFromHtmlColorInput: false,
    );
  }

  void _onColorAndStopListChanged(List<ColorAndStop> newColorAndStopList,
      {required bool isChangeFromHtmlColorInput}) {
    if (!const ListEquality<ColorAndStop>()
        .equals(_gradient.getColorAndStopList(), newColorAndStopList)) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: _gradient.getGradientStyle(),
        colorAndStopList: newColorAndStopList,
        gradientDirection: _gradient.getGradientDirection(),
      );

      _gradient = newGradient;

      changeIsFromHtmlColorInput = isChangeFromHtmlColorInput;

      notifyListeners();
    }
  }
}
