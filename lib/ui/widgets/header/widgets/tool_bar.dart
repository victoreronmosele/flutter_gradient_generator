import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/utils/analytics.dart';
import 'package:flutter_gradient_generator/utils/gradient_downloader.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:flutter_gradient_generator/ui/widgets/header/widgets/tool_bar_icon_button.dart';
import 'package:flutter_gradient_generator/view_models/history_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);
    final historyViewModel = context.watch<HistoryViewModel>();
    final gradientDownloader = context.read<GradientDownloader>();

    final generatorScreenHorizontalPadding =
        appDimensions.generatorScreenHorizontalPadding;

    return Container(
        color: AppColors.toolBar,
        height: appDimensions.toolBarHeight,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: generatorScreenHorizontalPadding,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        /// Launch the root URL in the current tab
                        launchUrl(Uri.parse('/'), webOnlyWindowName: '_self');
                      },
                      child: Text(
                        AppStrings.appTitle,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
                ),
                ToolBarIconButton(
                  toolTipMessage: historyViewModel.history.isEmpty
                      ? AppStrings.noActionsToUndo
                      : AppStrings.undo,
                  onPressed: historyViewModel.history.isEmpty
                      ? null
                      : () {
                          final analytics = context.read<Analytics>();

                          analytics.logUndoButtonClickEvent();

                          historyViewModel.undo();
                        },
                  icon: Icons.undo,
                ),
                ToolBarIconButton(
                  toolTipMessage: historyViewModel.removedGradients.isEmpty
                      ? AppStrings.noActionsToRedo
                      : AppStrings.redo,
                  onPressed: historyViewModel.removedGradients.isEmpty
                      ? null
                      : () {
                          final analytics = context.read<Analytics>();

                          analytics.logRedoButtonClickEvent();

                          historyViewModel.redo();
                        },
                  icon: Icons.redo,
                ),
                ToolBarIconButton(
                  icon: Icons.save_alt_outlined,
                  toolTipMessage: AppStrings.downloadGradientAsImage,
                  onPressed: () async {
                    final analytics = context.read<Analytics>();

                    final gradientViewModel = context.read<GradientViewModel>();

                    final gradient = gradientViewModel.gradient;

                    await gradientDownloader.downloadGradientAsImage(gradient);

                    analytics.logGradientDownloadedAsImageEvent(gradient);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
