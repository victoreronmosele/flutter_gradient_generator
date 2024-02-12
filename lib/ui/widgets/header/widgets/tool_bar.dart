import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/utils/analytics.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolBar extends StatelessWidget {
  ToolBar({
    Key? key,
  }) : super(key: key);

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);

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
                  child: InkWell(
                    onTap: () {
                      launchUrl(
                        Uri.parse('/'),

                        /// Open in current tab
                        webOnlyWindowName: '_self',
                      );
                    },
                    child: Text(
                      AppStrings.appTitle,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.white,
                          ),
                    ),
                  ),
                ),
                Tooltip(
                  message: AppStrings.downloadGradientAsImage,
                  child: IconButton(
                    onPressed: () async {
                      final analytics = context.read<Analytics>();

                      final gradientViewModel =
                          context.read<GradientViewModel>();

                      final gradient = gradientViewModel.gradient;

                      final flutterGradient = gradient.toFlutterGradient();

                      final imageBytes =
                          await screenshotController.captureFromWidget(
                        Container(
                          decoration: BoxDecoration(
                            gradient: flutterGradient,
                          ),
                        ),
                      );

                      await WebImageDownloader.downloadImageFromUInt8List(
                        uInt8List: imageBytes,
                        name: 'gradient.png',
                      );

                      analytics.logGradientDownloadedAsImageEvent(gradient);
                    },
                    icon: const Icon(
                      Icons.save_alt_outlined,
                      color: AppColors.toolBarIcon,
                    ),
                    iconSize: appDimensions.toolBarIconButtonSize,
                    hoverColor: AppColors.toolBarIconHover,
                    focusColor: AppColors.toolBarIconFocus,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
