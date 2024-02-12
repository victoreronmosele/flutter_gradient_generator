import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/utils/analytics.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// TODO: Make this ad dynamic and not hardcoded.
/// Probably use Firebase Remote Config.
///
/// A banner ad that is shown on the top of the app.
class BannerAd extends StatelessWidget {
  const BannerAd({
    super.key,
    required this.onClose,
  });

  /// The callback to call when the close button is pressed.
  ///
  /// It is meant to close the banner ad.
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);
    final gradientViewModel = context.read<GradientViewModel>();

    final bannerAdHorizontalPadding = appDimensions.bannerAdHorizontalPadding;

    const foregroundColor = AppColors.white;

    const ctaButtonTitle = AppStrings.giveFeedback;

    return Container(
      decoration: BoxDecoration(
        gradient: gradientViewModel.defaultGradient.toFlutterGradient(),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: bannerAdHorizontalPadding,
        ),
        child: Row(
          children: [
            /// This accounts for the close button on the right of the banner ad.
            ///
            /// It enables the actual banner ad message to be centered.
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Have thoughts on the website\'s design or features?',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: foregroundColor,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        const ctaButtonUrl = AppStrings.feedbackUrl;

                        final analytics = context.read<Analytics>();

                        /// TODO: Remove this when the banner ad is dynamic
                        ///
                        /// This is only left for now since the banner ad is
                        /// for giving feedback.
                        analytics.logFeedbackButtonClickEvent();

                        analytics.logBannerAdCTAButtonClickEvent(
                          name: ctaButtonTitle,
                          url: ctaButtonUrl,
                        );

                        launchUrl(
                          Uri.parse(
                            ctaButtonUrl,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: foregroundColor,
                        side: const BorderSide(
                          color: foregroundColor,
                        ),
                      ),
                      child: const Text(
                        ctaButtonTitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CloseButton(
              color: foregroundColor,
              onPressed: () {
                final analytics = context.read<Analytics>();

                analytics.logBannerAdCloseButtonClickEvent();

                onClose();
              },
            )
          ],
        ),
      ),
    );
  }
}
