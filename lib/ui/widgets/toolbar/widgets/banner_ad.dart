import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/models/banner_ad_config.dart';
import 'package:flutter_gradient_generator/utils/analytics.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

class BannerAd extends StatelessWidget {
  const BannerAd({super.key, required this.bannerAdConfig});

  final BannerAdConfig bannerAdConfig;

  @override
  Widget build(BuildContext context) {
    final supportingText = bannerAdConfig.supportingText;
    final ctaButtonTitle = bannerAdConfig.ctaButtonTitle;
    final ctaButtonUrl = bannerAdConfig.ctaButtonUrl;
    final isNew = bannerAdConfig.isNew;

    final foregroundColor = AppColors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isNew)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'NEW',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: foregroundColor,
                      ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
            ],
          ),
        Flexible(
          child: Text(
            supportingText,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foregroundColor,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Link(
            uri: Uri.parse(ctaButtonUrl),
            target: LinkTarget.blank,
            builder: (context, followLink) {
              return OutlinedButton(
                onPressed: () async {
                  final analytics = context.read<Analytics>();

                  analytics.logBannerAdCTAButtonClickEvent(
                    name: ctaButtonTitle,
                    url: ctaButtonUrl,
                  );

                  followLink?.call();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: foregroundColor,
                  side: BorderSide(
                    color: foregroundColor,
                  ),
                ),
                child: Text(
                  ctaButtonTitle,
                  textAlign: TextAlign.center,
                ),
              );
            }),
      ],
    );
  }
}
