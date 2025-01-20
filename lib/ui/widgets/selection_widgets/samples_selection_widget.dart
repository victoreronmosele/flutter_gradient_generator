import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/data/app_strings.dart';
import 'package:flutter_gradient_generator/generated/gradient_samples.dart';
import 'package:flutter_gradient_generator/ui/widgets/selection_widgets/selection_container_widget.dart';
import 'package:flutter_gradient_generator/utils/analytics.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:provider/provider.dart';

class SampleSelectionWidget extends StatefulWidget {
  const SampleSelectionWidget({
    super.key,
  });

  @override
  State<SampleSelectionWidget> createState() => _SampleSelectionWidgetState();
}

class _SampleSelectionWidgetState extends State<SampleSelectionWidget> {
  final scrollController = ScrollController();

  bool showFadingGradient = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final maxScrollExtent = scrollController.position.maxScrollExtent;
      final currentScrollExtent = scrollController.offset;

      final bool shouldShowFadingGradient =
          currentScrollExtent < maxScrollExtent;

      if (shouldShowFadingGradient != showFadingGradient) {
        setState(() {
          showFadingGradient = shouldShowFadingGradient;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget getSampleItem({
    required BuildContext context,
    required GradientViewModel gradientViewModel,
    required int index,
    required String name,
    required Gradient gradient,
  }) {
    return Column(
      children: [
        if (index != 0)
          const SizedBox(
            height: 6,
          ),
        Material(
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              final analytics = context.read<Analytics>();

              analytics.logGradientSampleClickEvent(name);

              gradientViewModel.setNewFlutterGradient(gradient);
            },
            child: Ink(
              decoration: BoxDecoration(
                gradient: gradient,
              ),
              height: 48,
              child: Center(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        color: Colors.black54,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);
    final gradientViewModel = context.watch<GradientViewModel>();

    final currentGradient = gradientViewModel.gradient;
    final currentFlutterGradientConverter =
        currentGradient.getFlutterGradientConverter();

    final chooseRandomGradientIconButtonSize =
        appDimensions.chooseRandomGradientIconButtonSize;
    final sampleTitleBottomMargin = appDimensions.sampleTitleBottomMargin;

    return SelectionWidgetContainer(
      title: AppStrings.samples,
      scrollSelectionWidgetBelowTitle: true,
      selectionWidget: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            showFadingGradient
                ? Colors.black.withOpacity(0.5)
                : Colors.transparent,
            showFadingGradient ? Colors.black : Colors.transparent,
          ],
          stops: const [
            0.8,
            0.9,
            1,
          ],
        ).createShader(bounds),
        blendMode: BlendMode.dstOut,
        child: ListView.builder(
          controller: scrollController,
          prototypeItem: getSampleItem(
            context: context,
            gradientViewModel: gradientViewModel,

            /// index is set to 1 so that the top margin is added in
            /// the prototype item since items with index 0 do not have a top
            /// margin.
            ///
            /// Setting this to 0 would break the layout of the actual items,
            /// causing them to overflow by the height of the top margin.
            ///
            /// See the `getSampleItem` method for more details
            index: 1,
            name: 'Sample',
            gradient: const LinearGradient(
              colors: [Colors.black, Colors.white],
            ),
          ),
          shrinkWrap: true,
          itemCount: gradientSamples.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final sample = gradientSamples[index];

            final name = sample.name;
            final colors = sample.colors;

            final gradient = currentFlutterGradientConverter(colors: colors);

            return getSampleItem(
              context: context,
              gradientViewModel: gradientViewModel,
              index: index,
              name: name,
              gradient: gradient,
            );
          },
        ),
      ),
      titleTrailingWidget: Tooltip(
        message: AppStrings.chooseRandomGradient,
        child: IconButton(
            onPressed: () {
              final analytics = context.read<Analytics>();

              analytics.logRandomGradientSampleButtonClickEvent();

              gradientViewModel.displayRandomGradientFromSamples();
            },
            icon: const Icon(Icons.shuffle),
            iconSize: chooseRandomGradientIconButtonSize),
      ),
      titleBottomMargin: sampleTitleBottomMargin,
    );
  }
}
