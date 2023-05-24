import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';

/// Holds the selection widgets
///
/// The selection container contains:
/// - a title
/// - a selection widget
class SelectionWidgetContainer extends StatelessWidget {
  const SelectionWidgetContainer(
      {super.key,
      required this.titleWidgetInformation,
      required this.selectionWidget});

  final ({Widget mainTitle, Widget action}) titleWidgetInformation;
  final Widget selectionWidget;

  @override
  Widget build(BuildContext context) {
    final AppDimensions appDimensions = AppDimensions.of(context);

    final compactButtonWidth = appDimensions.compactButtonWidth;
    final compactButtonMargin = appDimensions.compactButtonMargin;

    final (mainTitle: mainTitle, action: action) = titleWidgetInformation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            width: ((2 * compactButtonWidth) + compactButtonMargin),
            child: mainTitle,
          ),
          SizedBox(width: compactButtonMargin),
          action,
        ]),
        const SizedBox(height: 16),
        selectionWidget,
      ],
    );
  }
}
