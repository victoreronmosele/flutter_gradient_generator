import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';

/// Holds the selection widgets
///
/// The selection container contains:
/// - a title,
/// - a selection widget,
/// - an optional title trailing widget and
/// - an optional title bottom margin
///
/// It allows the user to expand and collapse the selection widget
class SelectionWidgetContainer extends StatefulWidget {
  const SelectionWidgetContainer({
    super.key,
    required this.title,
    required this.selectionWidget,
    this.titleTrailingWidget,
    this.titleBottomMargin = 16.0,
  });

  final String title;
  final Widget selectionWidget;
  final Widget? titleTrailingWidget;

  /// This helps to adjust the bottom margin of the title for when the title
  /// has a trailing widget which might take some extra vertical space.
  ///
  /// See [ColorAndStopSelectionWidget] for reference.
  final double titleBottomMargin;

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

    final expansionIconSize = appDimensions.expansionIconSize;

    final generatorScreenContentWidth =
        appDimensions.generatorScreenContentWidth;

    final generatorScreenHorizontalPadding =
        appDimensions.generatorScreenHorizontalPadding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: generatorScreenHorizontalPadding,
          ),
          child: SizedBox(
            width: generatorScreenContentWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RotationTransition(
                  turns: _expansionIconTurns,
                  child: GestureDetector(
                    onTap: _toggleExpansion,
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: expansionIconSize,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
                Expanded(
                  child: Text(widget.title,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                ),
                if (widget.titleTrailingWidget != null)
                  widget.titleTrailingWidget!,
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: generatorScreenHorizontalPadding),
          child: SizeTransition(
            sizeFactor: _selectionWidgetSizeFactor,
            child: FadeTransition(
                opacity: _selectionWidgetOpacity,
                child: Column(
                  children: [
                    SizedBox(
                      height: widget.titleBottomMargin,
                    ),
                    widget.selectionWidget
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
