import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/ui/widgets/selection_widgets/samples_selection_widget.dart';
import 'package:flutter_gradient_generator/utils/analytics.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LeftSection extends StatelessWidget {
  const LeftSection({super.key});

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);

    final generatorScreenHorizontalPadding =
        appDimensions.generatorScreenHorizontalPadding;

    final sampleSectionVerticalPadding =
        appDimensions.sampleSectionVerticalPadding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: sampleSectionVerticalPadding,
        ),
        const SampleSelectionWidget(),
        SizedBox(
          height: sampleSectionVerticalPadding,
        ),
        const Divider(
          thickness: 0.5,
          height: 0,
        ),
        Flexible(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: generatorScreenHorizontalPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SimpleTextLink(
                    text: AppStrings.requestFeature,
                    onPressed: () {
                      final analytics = context.read<Analytics>();

                      analytics.logFeatureRequestButtonClickEvent();

                      launchUrl(Uri.parse(AppStrings.featureRequestUrl));
                    },
                  ),
                  SizedBox(
                    height: sampleSectionVerticalPadding,
                  ),
                  SimpleTextLink(
                    text: AppStrings.reportBug,
                    onPressed: () {
                      final analytics = context.read<Analytics>();

                      analytics.logBugReportButtonClickEvent();

                      launchUrl(Uri.parse(AppStrings.bugReportUrl));
                    },
                  ),
                  SizedBox(
                    height: sampleSectionVerticalPadding,
                  ),
                  SimpleTextLink(
                    text: AppStrings.viewSourceCodeOnGitHub,
                    onPressed: () {
                      final analytics = context.read<Analytics>();

                      analytics.logViewSourceCodeOnGitHubButtonClickEvent();

                      launchUrl(Uri.parse(AppStrings.githubUrl));
                    },
                  ),
                  SizedBox(
                    height: sampleSectionVerticalPadding,
                  ),
                  const BuiltByVictorEronmosele(),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        const Divider(
          thickness: 0.5,
          height: 0,
        ),
      ],
    );
  }
}

class BuiltByVictorEronmosele extends StatefulWidget {
  const BuiltByVictorEronmosele({
    super.key,
  });

  @override
  State<BuiltByVictorEronmosele> createState() =>
      _BuiltByVictorEronmoseleState();
}

class _BuiltByVictorEronmoseleState extends State<BuiltByVictorEronmosele> {
  late final TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();

    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {

        final analytics = context.read<Analytics>();

        analytics.logVictorEronmoseleClickEvent();

        launchUrl(Uri.parse(AppStrings.victorEronmoseleWebsiteUrl));
      };
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
        );

    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: '${AppStrings.builtBy} ',
          ),
          TextSpan(
            text: AppStrings.victorEronmosele,
            style: textStyle?.copyWith(
              decoration: TextDecoration.underline,
            ),
            recognizer: _tapGestureRecognizer,
          ),
        ],
      ),
      style: textStyle,
    );
  }
}

class SimpleTextLink extends StatelessWidget {
  const SimpleTextLink({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              decoration: TextDecoration.underline,
            ),
      ),
    );
  }
}
