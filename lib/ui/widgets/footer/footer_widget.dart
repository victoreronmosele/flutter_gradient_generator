import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWidget extends StatefulWidget {
  const FooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  final _builtTapRecognizer = TapGestureRecognizer();
  final _nameTapGestureRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    _builtTapRecognizer.onTap = () {
      launchUrl(Uri.parse(AppStrings.githubUrl));
    };

    _nameTapGestureRecognizer.onTap = () {
      launchUrl(Uri.parse(AppStrings.personalWebsiteUrl));
    };
  }

  @override
  void dispose() {
    super.dispose();
    _builtTapRecognizer.dispose();
    _nameTapGestureRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);

    final generatorScreenContentWidth =
        appDimensions.generatorScreenContentWidth;
    final generatorScreenHorizontalPadding =
        appDimensions.generatorScreenHorizontalPadding;
    final generatorScreenVerticalPadding =
        appDimensions.generatorScreenVerticalPadding;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: generatorScreenContentWidth,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: generatorScreenHorizontalPadding,
          vertical: generatorScreenVerticalPadding / 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${AppStrings.built} ',
                    style:
                        const TextStyle(decoration: TextDecoration.underline),
                    recognizer: _builtTapRecognizer,
                  ),
                  const TextSpan(
                    text: AppStrings.by,
                  ),
                  TextSpan(
                    text: ' ${AppStrings.victorEronmosele}',
                    style:
                        const TextStyle(decoration: TextDecoration.underline),
                    recognizer: _nameTapGestureRecognizer,
                  ),
                ],
              ),
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
