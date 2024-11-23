import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/models/banner_ad_config.dart';
import 'package:flutter_gradient_generator/ui/widgets/toolbar/widgets/banner_ad.dart';
import 'package:flutter_gradient_generator/utils/analytics.dart';
import 'package:flutter_gradient_generator/utils/gradient_downloader.dart';
import 'package:flutter_gradient_generator/utils/platform_checker.dart';
import 'package:flutter_gradient_generator/utils/remote_config.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:flutter_gradient_generator/ui/widgets/toolbar/widgets/tool_bar_icon_button.dart';
import 'package:flutter_gradient_generator/view_models/history_view_model.dart';
import 'package:flutter_gradient_generator/view_models/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({
    super.key,
  });

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  BannerAdConfig? bannerAdConfig;

  @override
  void initState() {
    super.initState();

    fetchBannerAdConfig();
  }

  Future<void> fetchBannerAdConfig() async {
    final remoteConfig = context.read<RemoteConfig>();

    bannerAdConfig = await remoteConfig.getBannerAdConfig();

    setState(() {
      // Refresh the page after fetching the banner ad
    });
  }

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);

    final historyViewModel = context.watch<HistoryViewModel>();
    final homeViewModel = context.watch<HomeViewModel>();

    final gradientDownloader = context.read<GradientDownloader>();
    final platformChecker = context.read<PlatformChecker>();

    final isMac = platformChecker.isMac();

    final generatorScreenHorizontalPadding =
        appDimensions.generatorScreenHorizontalPadding;

    final foregroundColor = AppColors.white;

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
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            /// Launch the root URL in the current tab
                            launchUrl(Uri.parse('/'),
                                webOnlyWindowName: '_self');
                          },
                          child: Text(
                            AppStrings.appTitle,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: foregroundColor),
                          ),
                        ),
                      ),
                      Flexible(
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: bannerAdConfig == null
                              ? SizedBox.shrink()
                              : BannerAd(
                                  bannerAdConfig: bannerAdConfig!,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                ToolBarIconButton(
                  toolTipMessage: ToolTipMessage(
                    toolTipTextList: [
                      ToolTipText(
                        value: historyViewModel.liveHistory.isEmpty
                            ? AppStrings.noActionsToUndo
                            : AppStrings.undo,
                        isKeyboardKey: false,
                      ),
                      const EmptySpaceToolTipText(),
                      if (historyViewModel.liveHistory.isNotEmpty)
                        ToolTipText(
                          value: AppStrings.getUndoShortcutText(isMac: isMac),
                          isKeyboardKey: true,
                        ),
                    ],
                  ),
                  onPressed: historyViewModel.liveHistory.isEmpty
                      ? null
                      : () {
                          final analytics = context.read<Analytics>();

                          analytics.logUndoButtonClickEvent();

                          historyViewModel.undo();
                        },
                  icon: Icons.undo,
                ),
                ToolBarIconButton(
                  toolTipMessage: ToolTipMessage(
                    toolTipTextList: [
                      ToolTipText(
                        value: historyViewModel.removedGradients.isEmpty
                            ? AppStrings.noActionsToRedo
                            : AppStrings.redo,
                        isKeyboardKey: false,
                      ),
                      const EmptySpaceToolTipText(),
                      if (historyViewModel.removedGradients.isNotEmpty)
                        ToolTipText(
                          value: AppStrings.getRedoShortcutText(isMac: isMac),
                          isKeyboardKey: true,
                        ),
                    ],
                  ),
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
                  icon: Icons.history_outlined,
                  toolTipMessage: ToolTipMessage(
                    toolTipTextList: [
                      ToolTipText(
                        value: AppStrings.versionHistory,
                        isKeyboardKey: false,
                      ),
                    ],
                  ),
                  onPressed: homeViewModel.isShowingVersionHistory ||
                          historyViewModel.fullHistory.isEmpty
                      ? null
                      : () async {
                          final analytics = context.read<Analytics>();

                          homeViewModel.showVersionHistory();

                          analytics.logVersionHistoryButtonClickEvent();
                        },
                ),
                ToolBarIconButton(
                  icon: Icons.save_alt_outlined,
                  toolTipMessage: ToolTipMessage(
                    toolTipTextList: [
                      ToolTipText(
                        value: AppStrings.downloadGradientAsImage,
                        isKeyboardKey: false,
                      ),
                    ],
                  ),
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
