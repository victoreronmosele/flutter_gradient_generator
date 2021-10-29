import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class GeneratorScreen extends StatelessWidget {
  final AbstractGradient gradient;
  final void Function(GradientStyle) onGradientStyleChanged;

  const GeneratorScreen(
      {Key? key, required this.gradient, required this.onGradientStyleChanged})
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

    final Color selectedStyleButtonColor = Color(0xfff1f4f8);
    final Color unselectedStyleButtonColor = Colors.white;

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
            ),
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
                                color: Color(0xfff1f4f8),
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
                        color: Color(0xfff1f4f8),
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

class DirectionWidget extends StatelessWidget {
  final GradientStyle gradientStyle;

  DirectionWidget({
    Key? key,
    required this.gradientStyle,
  }) : super(key: key);

  final int circleDirectionIconSetNumber = 1;
  final int circleDirectionIconNumberInSet = 1;

  final List<List<IconData>> iconSetList = [
    [
      MaterialCommunityIcons.arrow_top_left,
      MaterialCommunityIcons.arrow_up,
      MaterialCommunityIcons.arrow_top_right
    ],
    [
      MaterialCommunityIcons.arrow_left,
      MaterialCommunityIcons.circle_outline,
      MaterialCommunityIcons.arrow_right,
    ],
    [
      MaterialCommunityIcons.arrow_bottom_left,
      MaterialCommunityIcons.arrow_down,
      MaterialCommunityIcons.arrow_bottom_right,
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: iconSetList.map((List<IconData> iconSet) {
          final int iconSetIndex = iconSetList.indexOf(iconSet);
          final int firstIconSetIndex = 0;

          return Column(
            children: [
              if (iconSetIndex != firstIconSetIndex) SizedBox(height: 8.0),
              Row(
                  children: iconSet.map((icon) {
                final int iconIndex = iconSet.indexOf(icon);
                final int firstIconIndex = 0;

                final bool isCircleRadialButton =
                    iconSetIndex == circleDirectionIconSetNumber &&
                        iconIndex == circleDirectionIconNumberInSet;

                return Expanded(
                  child: Row(
                    children: [
                      if (iconIndex != firstIconIndex) SizedBox(width: 8.0),
                      Expanded(
                        child: Visibility(
                          child: DirectionButton(icon: icon),
                          visible: isCircleRadialButton
                              ? gradientStyle == GradientStyle.radial
                              : true,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()),
            ],
          );
        }).toList());
  }
}

class DirectionButton extends StatelessWidget {
  final IconData icon;
  const DirectionButton({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Icon(
        icon,
        size: 12.0,
      ),
      onPressed: () async {},
      style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          primary: Colors.black,
          textStyle: TextStyle(fontWeight: FontWeight.bold),
          side: BorderSide(
            color: Color(0xfff1f4f8),
          )),
    );
  }
}

class GetGradientButton extends StatefulWidget {
  const GetGradientButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Future<void> Function() onTap;

  @override
  State<GetGradientButton> createState() => _GetGradientButtonState();
}

class _GetGradientButtonState extends State<GetGradientButton> {
  bool _showCopiedText = false;

  String get _buttonText => _showCopiedText
      ? AppStrings.gradientCodeCopied
      : AppStrings.getGradientCode;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: TextButton(
        child: Text(_buttonText),
        onPressed: () async {
          await widget.onTap();

          setState(() {
            _showCopiedText = true;
          });

          await Future.delayed(Duration(seconds: 2));

          setState(() {
            _showCopiedText = false;
          });
        },
        style: TextButton.styleFrom(
          backgroundColor: Color(0xfff1f4f8),
          primary: Colors.black,
          textStyle: TextStyle(fontWeight: FontWeight.bold),
          padding: EdgeInsets.all(24),
        ),
      ),
    );
  }
}
