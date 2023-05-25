import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';

/// Holds the selection widgets
///
/// The selection container contains:
/// - a title
/// - a selection widget
///
/// It allows the user to expand and collapse the selection widget
class SelectionWidgetContainer extends StatefulWidget {
  const SelectionWidgetContainer(
      {super.key,
      required this.titleWidgetInformation,
      required this.selectionWidget});

  /// Holds the information for the title widget
  ///
  /// It holds the following:
  ///
  /// - a [mainTitle] String which is the text describing the selection widget
  ///
  /// - an [trailingActionWidget] widget which is an extra button to the right of the title.
  /// Set to [SizedBox.shrink()] if you don't want an action button
  ///
  final ({
    String mainTitle,
    Widget trailingActionWidget
  }) titleWidgetInformation;
  final Widget selectionWidget;

  @override
  State<SelectionWidgetContainer> createState() =>
      _SelectionWidgetContainerState();
}

class _SelectionWidgetContainerState extends State<SelectionWidgetContainer>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _openAndCloseTween =
      Tween<double>(begin: -0.25, end: 0);

  bool isExpanded = true;

  late AnimationController _animationController;
  late Animation<double> _expansionIconTurns;
  late Animation<double> _selectionWidgetOpacity;
  late Animation<double> _selectionWidgetSizeFactor;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _expansionIconTurns =
        _animationController.drive(_openAndCloseTween.chain(_easeInTween));
    _selectionWidgetOpacity = _animationController.drive(_easeInTween);
    _selectionWidgetSizeFactor = _animationController.drive(_easeInTween);

    _animationController.value = 1.0;

    _animationController.forward();
  }

  void _toggleExpansion() {
    isExpanded = !isExpanded;

    if (isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppDimensions appDimensions = AppDimensions.of(context);

    final compactButtonMargin = appDimensions.compactButtonMargin;

    final (mainTitle: mainTitle, trailingActionWidget: trailingActionWidget) =
        widget.titleWidgetInformation;

    final expansionIconSize = appDimensions.expansionIconSize;
    final selectionContainerMainTitleWidth =
        appDimensions.selectionContainerMainTitleWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: RotationTransition(
                  turns: _expansionIconTurns,
                  child: GestureDetector(
                      onTap: _toggleExpansion,
                      child: Icon(
                        Icons.expand_more,
                        size: expansionIconSize,
                        color: Colors.white,
                      ))),
            ),
            SizedBox(width: compactButtonMargin),
            SizedBox(
              width: selectionContainerMainTitleWidth,
              child: Text(
                mainTitle,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: compactButtonMargin),
            trailingActionWidget,
          ],
        ),
        SizeTransition(
          sizeFactor: _selectionWidgetSizeFactor,
          child: FadeTransition(
              opacity: _selectionWidgetOpacity,
              child: Column(
                children: [const SizedBox(height: 16), widget.selectionWidget],
              )),
        ),
      ],
    );
  }
}
