import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

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
  final GradientDirection selectedGradientDirection;
  final void Function(GradientDirection) onGradientDirectionChanged;

  DirectionWidget(
      {Key? key,
      required this.gradientStyle,
      required this.selectedGradientDirection,
      required this.onGradientDirectionChanged})
      : super(key: key);

  final int circleDirectionIconSetNumber = 1;
  final int circleDirectionIconNumberInSet = 1;

  final List<Map<GradientDirection, IconData>> iconSetList = [
    {
      GradientDirection.topLeft: MaterialCommunityIcons.arrow_top_left,
      GradientDirection.topCenter: MaterialCommunityIcons.arrow_up,
      GradientDirection.topRight: MaterialCommunityIcons.arrow_top_right,
    },
    {
      GradientDirection.centerLeft: MaterialCommunityIcons.arrow_left,
      GradientDirection.center: MaterialCommunityIcons.circle_outline,
      GradientDirection.centerRight: MaterialCommunityIcons.arrow_right,
    },
    {
      GradientDirection.bottomLeft: MaterialCommunityIcons.arrow_bottom_left,
      GradientDirection.bottomCenter: MaterialCommunityIcons.arrow_down,
      GradientDirection.bottomRight: MaterialCommunityIcons.arrow_bottom_right,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: iconSetList.map(
            (Map<GradientDirection, IconData> gradientDirectionToIconSetMap) {
          final int iconSetIndex =
              iconSetList.indexOf(gradientDirectionToIconSetMap);
          final int firstIconSetIndex = 0;

          return Column(
            children: [
              if (iconSetIndex != firstIconSetIndex) SizedBox(height: 8.0),
              Row(
                  children: gradientDirectionToIconSetMap.values.map((icon) {
                final int iconIndex =
                    gradientDirectionToIconSetMap.values.toList().indexOf(icon);
                final GradientDirection gradientDirection =
                    gradientDirectionToIconSetMap.keys.elementAt(iconIndex);

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
                          child: DirectionButton(
                              icon: icon,
                              gradientDirection: gradientDirection,
                              isSelected: gradientDirection ==
                                  selectedGradientDirection,
                              onGradientDirectionChanged:
                                  onGradientDirectionChanged),
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
  final GradientDirection gradientDirection;
  final bool isSelected;
  final void Function(GradientDirection) onGradientDirectionChanged;

  const DirectionButton(
      {Key? key,
      required this.icon,
      required this.gradientDirection,
      required this.isSelected,
      required this.onGradientDirectionChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color greyColor = Color(0xfff1f4f8);
    return TextButton(
      child: Icon(
        icon,
        size: 12.0,
      ),
      onPressed: () {
        onGradientDirectionChanged(gradientDirection);
      },
      style: TextButton.styleFrom(
          backgroundColor: isSelected ? greyColor : Colors.white,
          primary: Colors.black,
          textStyle: TextStyle(fontWeight: FontWeight.bold),
          side: BorderSide(
            color: greyColor,
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

  Color _getBackgroundColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return AppColors.darkGrey;
    }
    return AppColors.grey;
  }

  Color _getForegroundColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return AppColors.white;
    }
    return AppColors.black;
  }

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
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith(_getBackgroundColor),
          foregroundColor:
              MaterialStateProperty.resolveWith(_getForegroundColor),
          textStyle:
              MaterialStateProperty.all(TextStyle(fontWeight: FontWeight.bold)),
          padding: MaterialStateProperty.all(EdgeInsets.all(24)),
        ),
      ),
    );
  }
}
