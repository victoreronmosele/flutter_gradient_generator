import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';

class AppTitleWidget extends StatelessWidget {
  const AppTitleWidget({
    Key? key,
    required this.forPortrait,
  }) : super(key: key);

  final bool forPortrait;

  @override
  Widget build(BuildContext context) {
    final titleToDisplay =
        forPortrait ? AppStrings.appTitle : AppStrings.appTitleNewLine;

    return Text(
      titleToDisplay.toUpperCase(),
      textAlign: TextAlign.left,
      style:  TextStyle(
        fontSize: forPortrait ? 20.0 : 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
