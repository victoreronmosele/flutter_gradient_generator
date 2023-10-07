import 'dart:ui_web' as ui_web;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/utils/color_and_stop_util.dart';

//TODO: Remove dependencies on Flutter Gradient Generator logic
// and make this a standalone widget in a separate package
class HtmlColorInput extends StatefulWidget {
  const HtmlColorInput({
    super.key,
    required this.uniqueId,
    this.initialColor,
    this.onInput,
    this.onClick,
  });

  final String uniqueId;
  final Color? initialColor;
  final void Function(html.Event)? onInput;
  final void Function()? onClick;

  @override
  State<HtmlColorInput> createState() => _HtmlColorInputState();
}

class _HtmlColorInputState extends State<HtmlColorInput> {
  @override
  void initState() {
    super.initState();

    /// This is needed for the initial color to be set
    registerColorInputView();
  }

  void registerColorInputView() {
    ui_web.platformViewRegistry.registerViewFactory(widget.uniqueId,
        (int viewId) {
      final inputElement = html.InputElement()
        ..type = 'color'
        ..value = widget.initialColor == null
            ? null
            : ColorAndStopUtil().colorToHex(widget.initialColor!)
        ..onInput.listen((event) {
          widget.onInput?.call(event);
        })
        ..onClick.listen((_) {
          widget.onClick?.call();
        })
        ..style.width = '100%'
        ..style.height = '100%';

      return inputElement;
    });
  }

  @override
  void didUpdateWidget(covariant HtmlColorInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// This is needed to update the color of the input element
    registerColorInputView();
  }

  @override
  Widget build(BuildContext context) {
    final AppDimensions appDimensions = AppDimensions.of(context);
    final compactButtonWidth = appDimensions.compactButtonWidth;
    final compactButtonHeight = appDimensions.compactButtonHeight;

    return SizedBox(
      width: compactButtonWidth,
      height: compactButtonHeight,
      child: HtmlElementView(
        viewType: widget.uniqueId,
      ),
    );
  }
}
