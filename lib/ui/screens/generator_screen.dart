import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/ui/widgets/direction_widget.dart';
import 'package:flutter_gradient_generator/ui/widgets/get_gradient_button.dart';

class GeneratorScreen extends StatelessWidget {
  final AbstractGradient gradient;
  final void Function(GradientStyle) onGradientStyleChanged;
  final void Function(GradientDirection) onGradientDirectionChanged;

  const GeneratorScreen(
      {Key? key,
      required this.gradient,
      required this.onGradientStyleChanged,
      required this.onGradientDirectionChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _generatedCode = gradient.toWidgetString();

    final List<Color> colorList = gradient.getColorList();

    final gradientStyle = gradient.getGradientStyle();

    final bool isLinearGradientStyleSelected =
        gradientStyle == GradientStyle.linear;
    final bool isRadialGradientStyleSelected =
        gradientStyle == GradientStyle.radial;

    final Color selectedStyleButtonColor = AppColors.grey;
    final Color unselectedStyleButtonColor = AppColors.white;

    final Color linearStyleButtonColor = isLinearGradientStyleSelected
        ? selectedStyleButtonColor
        : unselectedStyleButtonColor;
    final Color radialStyleButtonColor = isRadialGradientStyleSelected
        ? selectedStyleButtonColor
        : unselectedStyleButtonColor;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appTitleNewLine.toUpperCase(),
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 48),
            Text(
              'Style',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  child: Text('Linear'),
                  onPressed: () {
                    onGradientStyleChanged(GradientStyle.linear);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: linearStyleButtonColor,
                    primary: Colors.black,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    fixedSize: const Size(64, 24),
                    side: BorderSide(color: selectedStyleButtonColor),
                  ),
                ),
                SizedBox(width: 8),
                TextButton(
                  child: Text('Radial'),
                  onPressed: () {
                    onGradientStyleChanged(GradientStyle.radial);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: radialStyleButtonColor,
                    primary: Colors.black,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    fixedSize: const Size(64, 24),
                    side: BorderSide(color: selectedStyleButtonColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Direction',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            DirectionWidget(
                gradientStyle: gradient.getGradientStyle(),
                selectedGradientDirection: gradient.getGradientDirection(),
                onGradientDirectionChanged: onGradientDirectionChanged),
            SizedBox(height: 24),
            Text(
              'Colors',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ...colorList.map(
                  (color) {
                    final int index = colorList.indexOf(color);

                    return Row(
                      children: [
                        if (index != 0) SizedBox(width: 8),
                        TextButton(
                          child: SizedBox.shrink(),
                          onPressed: () async {},
                          style: TextButton.styleFrom(
                              backgroundColor: color,
                              primary: Colors.black,
                              textStyle: TextStyle(fontWeight: FontWeight.bold),
                              fixedSize: const Size(64, 24),
                              side: BorderSide(
                                color: AppColors.grey,
                              )),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(width: 8),
                TextButton(
                  child: Text('Random'),
                  onPressed: () async {},
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      primary: Colors.black,
                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                      fixedSize: const Size(84, 24),
                      side: BorderSide(
                        color: AppColors.grey,
                      )),
                ),
              ],
            ),
            SizedBox(height: 48),
            GetGradientButton(onTap: () async {
              await Clipboard.setData(new ClipboardData(text: _generatedCode));
            }),
          ],
        ),
      ),
    );
  }
}


