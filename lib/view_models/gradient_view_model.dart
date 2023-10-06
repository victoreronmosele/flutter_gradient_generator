import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/models/gradient_factory.dart';
import 'package:flutter_gradient_generator/models/linear_style_gradient.dart';
import 'package:flutter_gradient_generator/ui/util/new_color_generator/new_color_generator.dart';
import 'package:flutter_gradient_generator/ui/util/new_color_generator/new_color_generator_interface.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/abstract_random_color_generator.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/random_color_generator.dart';
import 'package:flutter_gradient_generator/utils/color_and_stop_util.dart';

class GradientViewModel with ChangeNotifier {
  final AbstractRandomColorGenerator _randomColorGenerator =
      const RandomColorGenerator();
  final _colorAndStopUtil = ColorAndStopUtil();

  late final AbstractGradient _defaultGradient = LinearStyleGradient(
      colorAndStopList: AppColors.initialColorAndStopList,
      gradientDirection: GradientDirection.bottomLeft);

  final NewColorGeneratorInterface _newColorGenerator = NewColorGenerator();

  int _currentSelectedColorIndex = 0;

  late AbstractGradient gradient = _defaultGradient;

  /// Whether the color change is from the [HtmlColorInput] widget.
  ///
  /// This is needed to prevent the [HtmlColorInput] widget from closing when
  /// tapped.
  bool isColorChangeFromHtmlColorInput = false;

  /// The index of the currently selected color in the color list being
  /// showned on the [GeneratorSection]
  int get currentSelectedColorIndex => _currentSelectedColorIndex;

  set currentSelectedColorIndex(int newCurrentSelectedColorIndex) {
    if (newCurrentSelectedColorIndex != currentSelectedColorIndex) {
      _currentSelectedColorIndex = newCurrentSelectedColorIndex;
      notifyListeners();
    }
  }

  void addNewColor() {
    final (:startColorAndStop, :endColorAndStop) =
        _getColorAndStopsForNewColorAddition();

    final newColorAndStop = _newColorGenerator.generateNewColorAndStopBetween(
        startColorAndStop: startColorAndStop, endColorAndStop: endColorAndStop);

    if (newColorAndStop == null) {
      return;
    }

    onNewColorAndStopAdded(newColorAndStop);
  }

  void changeColor({
    required Color newColor,
    required int currentColorAndStopIndex,
  }) {
    final colorAndStopList = gradient.getColorAndStopList();

    // ignore: unused_local_variable
    final (:color, :stop) =
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
      index: currentColorAndStopIndex,
      isChangeFromHtmlColorInput: true,
    );
  }

  void changeStop({
    required int newStop,
    required int currentColorAndStopIndex,
  }) {
    final colorAndStopList = gradient.getColorAndStopList();

    // ignore: unused_local_variable
    final (:color, :stop) =
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
      index: currentColorAndStopIndex,
      isChangeFromHtmlColorInput: false,
    );
  }

  /// Deletes the currently selected [ColorAndStop] if there are more than
  /// [minimumNumberOfColors] colors in the gradient.
  void deleteSelectedColorAndStopIfMoreThanMinimum(
      {required int indexToDelete}) {
    final currentColorAndStopList = gradient.getColorAndStopList();

    final colorAndStopListIsMoreThanMinimum = _colorAndStopUtil
        .isColorAndStopListMoreThanMinimum(currentColorAndStopList);

    /// Only delete the currently selected [ColorAndStop] if there are more than
    /// [minimumNumberOfColors] colors in the gradient.
    if (colorAndStopListIsMoreThanMinimum) {
      final colorAndStopToDelete = currentColorAndStopList[indexToDelete];

      _onColorAndStopDeleted(colorAndStopToDelete);
    }
  }

  void changeGradientDirection(GradientDirection newGradientDirection) {
    if (gradient.getGradientDirection() != newGradientDirection) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: gradient.getGradientStyle(),
        colorAndStopList: gradient.getColorAndStopList(),
        gradientDirection: newGradientDirection,
      );

      gradient = newGradient;

      notifyListeners();
    }
  }

  void changeGradientStyle(GradientStyle newGradientStyle) {
    if (gradient.getGradientStyle() != newGradientStyle) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: newGradientStyle,
        colorAndStopList: gradient.getColorAndStopList(),
        gradientDirection: gradient.getGradientDirection(),
      );

      gradient = newGradient;

      notifyListeners();
    }
  }

  void onNewColorAndStopAdded(ColorAndStop newColorAndStop) {
    final List<ColorAndStop> colorAndStopListCopy =
        List<ColorAndStop>.from(gradient.getColorAndStopList());

    colorAndStopListCopy.add(newColorAndStop);

    colorAndStopListCopy.sort((a, b) => a.stop.compareTo(b.stop));

    final updatedColorAndStopList = colorAndStopListCopy;

    final newColorAndStopIndex =
        updatedColorAndStopList.lastIndexOf(newColorAndStop);

    _onColorAndStopListChanged(
      updatedColorAndStopList,
      index: newColorAndStopIndex,
      isChangeFromHtmlColorInput: false,
    );
  }

  void randomizeColors() {
    final newColorAndStopList = _randomColorGenerator
        .getRandomColorAndStopsOfCurrentGradientColorAndStopListLength(
      currentStopList:
          gradient.getColorAndStopList().map((e) => e.stop).toList(),
    );

    _onColorAndStopListChanged(
      newColorAndStopList,
      index: currentSelectedColorIndex,
      isChangeFromHtmlColorInput: false,
    );
  }

  ({ColorAndStop? startColorAndStop, ColorAndStop? endColorAndStop})
      _getColorAndStopsForNewColorAddition() {
    final colorAndStopList = gradient.getColorAndStopList();

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

  void _onColorAndStopDeleted(ColorAndStop colorAndStopToDelete) {
    final List<ColorAndStop> colorAndStopListCopy =
        List<ColorAndStop>.from(gradient.getColorAndStopList());

    colorAndStopListCopy.remove(colorAndStopToDelete);

    final updatedColorAndStopList = colorAndStopListCopy;

    final indexBeforeCurrentSelectedColorIndex = currentSelectedColorIndex - 1;

    final newSelectedColorIndex = indexBeforeCurrentSelectedColorIndex < 0
        ? 0
        : indexBeforeCurrentSelectedColorIndex;

    _onColorAndStopListChanged(
      updatedColorAndStopList,
      index: newSelectedColorIndex,
      isChangeFromHtmlColorInput: false,
    );
  }

  void _onColorAndStopListChanged(List<ColorAndStop> newColorAndStopList,
      {required int index, required bool isChangeFromHtmlColorInput}) {
    if (!const ListEquality<ColorAndStop>()
        .equals(gradient.getColorAndStopList(), newColorAndStopList)) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: gradient.getGradientStyle(),
        colorAndStopList: newColorAndStopList,
        gradientDirection: gradient.getGradientDirection(),
      );

      gradient = newGradient;
      currentSelectedColorIndex = index;
      isColorChangeFromHtmlColorInput = isChangeFromHtmlColorInput;

      notifyListeners();
    }
  }
}
