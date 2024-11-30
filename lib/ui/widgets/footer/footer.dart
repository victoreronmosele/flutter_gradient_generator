import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/utils/analytics.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SimpleTextLink(
              //   text: AppStrings.requestFeature,
              //   onPressed: () {
              //     final analytics = context.read<Analytics>();

              //     analytics.logFeatureRequestButtonClickEvent();

              //     launchUrl(Uri.parse(AppStrings.featureRequestUrl));
              //   },
              // ),
              // const SizedBox(
              //   width: 16,
              // ),
              // SimpleTextLink(
              //   text: AppStrings.reportBug,
              //   onPressed: () {
              //     final analytics = context.read<Analytics>();

              //     analytics.logBugReportButtonClickEvent();

              //     launchUrl(Uri.parse(AppStrings.bugReportUrl));
              //   },
              // ),
              // const SizedBox(
              //   width: 16,
              // ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SimpleTextLink.fromTextSpan(
                    textSpan: TextSpan(
                      children: [
                        const TextSpan(
                          text: '${AppStrings.builtBy} ',
                        ),
                        WidgetSpan(
                          child: Link(
                            uri: Uri.parse(
                              AppStrings.victorEronmoseleWebsiteUrl,
                            ),
                            target: LinkTarget.blank,
                            builder: (context, followLink) => InkWell(
                              onTap: () {
                                final analytics = context.read<Analytics>();

                                analytics.logVictorEronmoseleClickEvent();

                                followLink?.call();
                              },
                              child: Transform.translate(
                                offset: const Offset(0, 1),
                                child: Text(
                                  AppStrings.victorEronmosele,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.toolBarIcon,
                                    color: AppColors.toolBarIcon,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    url: AppStrings.victorEronmoseleWebsiteUrl,
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, 1),
                  child: SimpleTextLink.fromText(
                    text: AppStrings.viewSourceCodeOnGitHub,
                    url: AppStrings.githubUrl,
                    onPressed: () {
                      final analytics = context.read<Analytics>();

                      analytics.logViewSourceCodeOnGitHubButtonClickEvent();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleTextLink extends StatelessWidget {
  SimpleTextLink.fromText({
    super.key,
    required String text,
    required this.url,
    required this.onPressed,
  }) : source = TextSource(text: text);

  SimpleTextLink.fromTextSpan({
    super.key,
    required TextSpan textSpan,
    required this.url,
  })  : source = TextSpanSource(textSpan: textSpan),
        onPressed = null;

  final SimpleTextLinkSource source;
  final String url;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.toolBarIcon,
        );

    return switch (source) {
      TextSource(text: final text) => Link(
          uri: Uri.parse(url),
          target: LinkTarget.blank,
          builder: (context, followLink) => InkWell(
            onTap: () {
              onPressed?.call();
              followLink?.call();
            },
            child: Text(
              text,
              style: textStyle?.copyWith(
                decoration: TextDecoration.underline,
                decorationColor: AppColors.toolBarIcon,
              ),
            ),
          ),
        ),
      TextSpanSource(textSpan: final textSpan) =>
        Text.rich(textSpan, style: textStyle),
    };
  }
}

sealed class SimpleTextLinkSource {
  const SimpleTextLinkSource();
}

class TextSource extends SimpleTextLinkSource {
  const TextSource({
    required this.text,
  });

  final String text;
}

class TextSpanSource extends SimpleTextLinkSource {
  const TextSpanSource({
    required this.textSpan,
  });

  final TextSpan textSpan;
}
