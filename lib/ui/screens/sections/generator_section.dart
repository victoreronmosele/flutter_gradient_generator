import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/copy_gradient_button.dart';
import 'package:flutter_gradient_generator/ui/widgets/selection_widgets/color_and_stop_selection_widget.dart';
import 'package:flutter_gradient_generator/ui/widgets/selection_widgets/direction_selection_widget.dart';
import 'package:flutter_gradient_generator/ui/widgets/selection_widgets/style_selection_widget.dart';

class GeneratorSection extends StatelessWidget {
  const GeneratorSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const divider = Divider(
      thickness: 0.5,
      height: 0,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const StyleSelectionWidget(),
          const SizedBox(height: 16),
          divider,
          const SizedBox(height: 16),
          DirectionSelectionWidget(),
          const SizedBox(height: 16),
          divider,
          // Using 6 instead of 16 to match the design due to additional space
          // added by the plus button in the `ColorAndStopSelectionWidget`
          const SizedBox(height: 6),

          ///TODO: Improve scrolling experience and performance by showing
          /// `ColorAndStop` widgets on demand
          const ColorAndStopSelectionWidget(),
          // Using 6 instead of 16 to match the design due to additional space
          // added by the plus button in the `ColorAndStopSelectionWidget`
          const SizedBox(height: 6),
          divider,
          const SizedBox(height: 16),
          const CopyGradientButton(),
          const SizedBox(height: 16),
          divider,
        ],
      ),
    );
  }
}
