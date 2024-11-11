import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/ui/widgets/selection_widgets/selection_container_widget.dart';
import 'package:flutter_gradient_generator/utils/analytics.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:flutter_gradient_generator/view_models/history_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gradient_generator/view_models/home_view_model.dart';

class VersionHistorySection extends StatefulWidget {
  const VersionHistorySection({super.key});

  @override
  State<VersionHistorySection> createState() => _VersionHistorySectionState();
}

class _VersionHistorySectionState extends State<VersionHistorySection> {
  int? selectedVersionHistoryItemIndex;

  @override
  void initState() {
    super.initState();

    final historyViewModel = context.read<HistoryViewModel>();

    historyViewModel.addListener(() {
      setState(() {
        selectedVersionHistoryItemIndex = null;
      });
    });
  }

  String getVersionHistoryItemText({
    required DateTime timeStamp,
    required int index,
  }) {
    final formattedTimeStamp = DateFormat('MMM d, h:mm:ss a').format(timeStamp);

    return formattedTimeStamp;
  }

  @override
  Widget build(BuildContext context) {
    final historyViewModel = context.watch<HistoryViewModel>();

    final appDimensions = AppDimensions.of(context);

    final fullHistory = historyViewModel.fullHistory.reversed;

    final versionHistoryCloseIconButtonSize =
        appDimensions.versionHistoryCloseIconButtonSize;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 6.0,
        ),
        SelectionWidgetContainer(
          title: AppStrings.versionHistory,
          selectionWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              fullHistory.length,
              (index) {
                final versionHistoryItem = fullHistory.elementAt(index);

                return FractionallySizedBox(
                  widthFactor: 1.0,
                  child: TextButton(
                    onPressed: selectedVersionHistoryItemIndex == index
                        ? null
                        : () {
                            final analytics = context.read<Analytics>();

                            final gradientViewModel =
                                context.read<GradientViewModel>();

                            gradientViewModel.setGradientDetails(
                              gradientToSet: versionHistoryItem.gradient,
                              isNewGradient: false,
                            );

                            analytics.logVersionHistoryItemClickEvent();

                            setState(() {
                              selectedVersionHistoryItemIndex = index;
                            });
                          },
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                      backgroundColor: selectedVersionHistoryItemIndex == index
                          ? WidgetStateProperty.all(
                              Theme.of(context).colorScheme.secondaryContainer,
                            )
                          : WidgetStateProperty.all(Colors.transparent),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Text(
                      getVersionHistoryItemText(
                        timeStamp: versionHistoryItem.timeStamp,
                        index: index,
                      ),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                );
              },
            ),
          ),
          titleTrailingWidget: IconButton(
            icon: const Icon(Icons.close),
            iconSize: versionHistoryCloseIconButtonSize,
            onPressed: () {
              final homeViewModel = context.read<HomeViewModel>();

              homeViewModel.hideVersionHistory();
            },
          ),
          titleBottomMargin: 2.0,
        ),
      ],
    );
  }
}
