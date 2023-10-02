import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/services/gradient_service.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/generator_section.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/preview_section.dart';
import 'package:flutter_gradient_generator/ui/widgets/footer/footer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final focusNode = FocusNode();
  late GradientService gradientService;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      gradientService = GradientServiceProvider.of(context).gradientService;

      /// This is the event handler that is called when a key is pressed.
      ///
      /// The purpose here is to enable the user to delete a [ColorAndStop] by
      /// pressing the delete or backspace key.
      HardwareKeyboard.instance
          .addHandler(_checkKeyEventAndMaybeDeleteColorAndStop);
    });
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
      gradientService.deleteSelectedColorAndStopIfMoreThanMinimum(
          indexToDelete: gradientService.currentSelectedColorIndex);
    }

    /// If the user presses the delete or backspace key, then `true` is returned
    /// which prevents the key event from being propagated to the rest of the app.
    ///
    /// And if the user presses any other key, then `false` is returned which
    /// allows the key event to be propagated to the rest of the app.
    return deleteOrBackspacePressed;
  }

  @override
  void dispose() {
    focusNode.dispose();
    HardwareKeyboard.instance
        .removeHandler(_checkKeyEventAndMaybeDeleteColorAndStop);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);

    final displayPortrait = appDimensions.shouldDisplayPortraitUI;

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
              child: const Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: GeneratorSection(),
                  ),
                  FooterWidget()
                ],
              ),
            ),
            if (!displayPortrait)
              const Flexible(
                child: PreviewSection.landscape(),
              ),
          ],
        ),
      ),
    );
  }
}
