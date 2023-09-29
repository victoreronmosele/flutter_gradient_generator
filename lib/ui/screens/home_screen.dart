import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/models/gradient_factory.dart';
import 'package:flutter_gradient_generator/models/linear_style_gradient.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/generator_section.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/preview_section.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/abstract_random_color_generator.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/random_color_generator.dart';
import 'package:flutter_gradient_generator/ui/widgets/footer/footer_widget.dart';
import 'package:flutter_gradient_generator/utils/color_and_stop_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final AbstractRandomColorGenerator randomColorGenerator =
      const RandomColorGenerator();

  final focusNode = FocusNode();

  late final AbstractGradient defaultGradient = LinearStyleGradient(
      colorAndStopList: randomColorGenerator
          .getRandomColorAndStopsOfCurrentGradientColorAndStopListLength(
        currentStopList: ColorAndStopUtil().initialStopList,
      ),
      gradientDirection: GradientDirection.topLeft);

  late AbstractGradient gradient = defaultGradient;

  /// The index of the currently selected color in the color list being
  /// showned on the [GeneratorSection]
  int currentSelectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
    gradient = defaultGradient;

    /// This is the event handler that is called when a key is pressed.
    ///
    /// The purpose here is to enable the user to delete a [ColorAndStop] by
    /// pressing the delete or backspace key.
    HardwareKeyboard.instance
        .addHandler(_checkKeyEventAndMaybeDeleteColorAndStop);
  }

  /// Checks if the key event is a delete or backspace key event
  /// and if so, deletes the currently selected [ColorAndStop].
  bool _checkKeyEventAndMaybeDeleteColorAndStop(event) {
    /// If a text field has focus, then the key event is not handled.
    if (focusNode.hasFocus) return false;

    /// If the event is not a key down event, then the key event is not handled.
    /// This is so that we don't perform the same deletion multiple times.
    if (event is! KeyDownEvent) return false;

    final keyPressed = event.logicalKey;

    final deleteOrBackspacePressed = [
      LogicalKeyboardKey.backspace,
      LogicalKeyboardKey.delete
    ].contains(keyPressed);

    if (deleteOrBackspacePressed) {
      deleteSelectedColorAndStopIfMoreThanMinimum(
          indexToDelete: currentSelectedColorIndex);
    }

    /// If the user presses the delete or backspace key, then `true` is returned
    /// which prevents the key event from being propagated to the rest of the app.
    ///
    /// And if the user presses any other key, then `false` is returned which
    /// allows the key event to be propagated to the rest of the app.
    return deleteOrBackspacePressed;
  }

  /// Deletes the currently selected [ColorAndStop] if there are more than
  /// [minimumNumberOfColors] colors in the gradient.
  void deleteSelectedColorAndStopIfMoreThanMinimum(
      {required int indexToDelete}) {
    final currentColorAndStopList = gradient.getColorAndStopList();

    final colorAndStopListIsMoreThanMinimum = ColorAndStopUtil()
        .isColorAndStopListMoreThanMinimum(currentColorAndStopList);

    /// Only delete the currently selected [ColorAndStop] if there are more than
    /// [minimumNumberOfColors] colors in the gradient.
    if (colorAndStopListIsMoreThanMinimum) {
      final colorAndStopToDelete = currentColorAndStopList[indexToDelete];

      _onColorAndStopDeleted(colorAndStopToDelete);
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    HardwareKeyboard.instance
        .removeHandler(_checkKeyEventAndMaybeDeleteColorAndStop);

    super.dispose();
  }

  void onGradientStyleChanged(GradientStyle newGradientStyle) {
    if (gradient.getGradientStyle() != newGradientStyle) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: newGradientStyle,
        colorAndStopList: gradient.getColorAndStopList(),
        gradientDirection: gradient.getGradientDirection(),
      );

      setState(() {
        gradient = newGradient;
      });
    }
  }

  void onGradientDirectionChanged(GradientDirection newGradientDirection) {
    if (gradient.getGradientDirection() != newGradientDirection) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: gradient.getGradientStyle(),
        colorAndStopList: gradient.getColorAndStopList(),
        gradientDirection: newGradientDirection,
      );

      setState(() {
        gradient = newGradient;
      });
    }
  }

  void onColorAndStopListChanged(List<ColorAndStop> newColorAndStopList,
      {required int index}) {
    if (!const ListEquality<ColorAndStop>()
        .equals(gradient.getColorAndStopList(), newColorAndStopList)) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: gradient.getGradientStyle(),
        colorAndStopList: newColorAndStopList,
        gradientDirection: gradient.getGradientDirection(),
      );

      setState(() {
        gradient = newGradient;
        currentSelectedColorIndex = index;
      });
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

    onColorAndStopListChanged(updatedColorAndStopList,
        index: newColorAndStopIndex);
  }

  void onColorAndStopDeleteButtonPressed({required int indexToDelete}) {
    deleteSelectedColorAndStopIfMoreThanMinimum(indexToDelete: indexToDelete);
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

    onColorAndStopListChanged(updatedColorAndStopList,
        index: newSelectedColorIndex);
  }

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);

    final displayPortrait = appDimensions.shouldDisplayPortraitUI;

    final previewSection = PreviewSection(
        gradient: gradient, borderRadius: displayPortrait ? 16.0 : 0.0);

    return Focus(
      focusNode: focusNode,
      child: Scaffold(
        body: Row(
          crossAxisAlignment: displayPortrait
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: displayPortrait ? 1 : 0,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: GeneratorSection(
                      gradient: gradient,
                      onGradientStyleChanged: onGradientStyleChanged,
                      onGradientDirectionChanged: onGradientDirectionChanged,
                      onColorAndStopListChanged: onColorAndStopListChanged,
                      onNewColorAndStopAdded: onNewColorAndStopAdded,
                      onColorAndStopDeleteButtonPressed:
                          onColorAndStopDeleteButtonPressed,
                      portraitInformation: (
                        previewWidgetForPortrait: previewSection,
                        isPortrait: displayPortrait,
                      ),
                      currentSelectedColorIndex: currentSelectedColorIndex,
                    ),
                  ),
                  const FooterWidget()
                ],
              ),
            ),
            if (!displayPortrait) Flexible(child: previewSection),
          ],
        ),
      ),
    );
  }
}
