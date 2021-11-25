import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';

class AppTitleWidget extends StatelessWidget {
  const AppTitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.appTitleNewLine.toUpperCase(),
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
