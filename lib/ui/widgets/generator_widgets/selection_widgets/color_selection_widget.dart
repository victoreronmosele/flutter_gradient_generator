import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/abstract_random_color_generator.dart';
import 'package:flutter_gradient_generator/ui/util/color_picker/abstract_color_picker.dart';
import 'package:flutter_gradient_generator/ui/util/color_picker/cyclop_color_picker.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/random_color_generator.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/compact_button.dart';

class ColorSelectionWidget extends StatelessWidget {
  const ColorSelectionWidget(
      {Key? key, required this.colorList, required this.onColorListChanged})
      : super(key: key);

  final List<Color> colorList;
  final void Function(List<Color>) onColorListChanged;

  final AbstractColorPicker colorPicker = const CyclopColorPicker();
  final AbstractRandomColorGenerator randomColorGenerator =
      const RandomColorGenerator();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.colors,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: List.generate(
            colorList.length,
            (index) {
                            final int firstIconIndex = 0;


              final Color color = colorList.elementAt(index);
              final int lastIndex = colorList.length - 1;

              return Row(
                children: [
                  if (index != firstIconIndex)
                    SizedBox(width: AppDimensions.compactButtonMargin),
                  CompactButton(
                    child: SizedBox.shrink(),
                    onPressed: () {
                      _selectColor(
                        context: context,
                        color: color,
                        index: index,
                      );
                    },
                    backgroundColor: color,
                    foregroundColor: Colors.black,
                    borderSide: BorderSide(
                      color: AppColors.grey,
                    ),
                  ),
                  if (index == lastIndex)
                    SizedBox(width: AppDimensions.compactButtonMargin),
                  if (index == lastIndex)
                    CompactButton(
                      child: Text(AppStrings.random),
                      onPressed: () {
                        final List<Color> twoRandomColors =
                            randomColorGenerator.getTwoRandomColors();

                        onColorListChanged(twoRandomColors);
                      },
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      borderSide: BorderSide(
                        color: AppColors.grey,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _selectColor({
    required BuildContext context,
    required Color color,
    required int index,
  }) {
    colorPicker.selectColor(
        context: context,
        currentColor: color,
        onColorSelected: (selectedColor) {
          /// Creates a copy of the `colorList` so modifying the new list does not modify colorList
          final List<Color> newColorList = List.from(colorList);
          newColorList[index] = selectedColor;

          onColorListChanged(newColorList);
        });
  }
}
