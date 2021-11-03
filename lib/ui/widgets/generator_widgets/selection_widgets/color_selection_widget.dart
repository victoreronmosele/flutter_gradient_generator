import 'package:cyclop/cyclop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/ui/util/abstract_color_picker.dart';
import 'package:flutter_gradient_generator/ui/util/cyclop_color_picker.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/compact_button.dart';

class ColorSelectionWidget extends StatelessWidget {
  const ColorSelectionWidget(
      {Key? key, required this.colorList, required this.onColorListChanged})
      : super(key: key);

  final List<Color> colorList;
  final void Function(List<Color>) onColorListChanged;

  final AbstractColorPicker colorPicker = const CyclopColorPicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Colors',
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
              final Color color = colorList.elementAt(index);
              final int lastIndex = colorList.length - 1;

              return Row(
                children: [
                  if (index != 0)
                    SizedBox(width: AppDimensions.compactButtonPadding),
                  ColorButton(
                    color: color,
                    onColorChanged: (selectedColor) {
                      /// Creates a copy of the `colorList` so modifying the new list does not modify colorList
                      final List<Color> newColorList = List.from(colorList);
                      newColorList[index] = selectedColor;

                      onColorListChanged(newColorList);
                    },
                    child: CompactButton(
                      child: SizedBox.shrink(),
                      onPressed: () {},
                      backgroundColor: color,
                      foregroundColor: Colors.black,
                      borderSide: BorderSide(
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  if (index == lastIndex)
                    SizedBox(width: AppDimensions.compactButtonPadding),
                  if (index == lastIndex)
                    CompactButton(
                      child: Text('Random'),
                      onPressed: () async {},
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
}
