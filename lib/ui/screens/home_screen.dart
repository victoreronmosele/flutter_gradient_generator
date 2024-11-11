import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/left_section.dart';
import 'package:flutter_gradient_generator/ui/widgets/header/header.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/generator_section.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/preview_section.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/version_history_section.dart';
import 'package:flutter_gradient_generator/view_models/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);

    final homeViewModel = context.watch<HomeViewModel>();

    //TODO: Handle portrait UI
    // ignore: unused_local_variable
    final displayPortrait = appDimensions.shouldDisplayPortraitUI;

    final generatorScreenWidth = appDimensions.generatorScreenWidth;
    final previewSectionWidth = appDimensions.previewSectionWidth;

    return Focus(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Header(),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: generatorScreenWidth,
                      child: const LeftSection(),
                    ),
                    SizedBox(
                      width: previewSectionWidth,
                      child: const PreviewSection.landscape(),
                    ),
                    SizedBox(
                      width: generatorScreenWidth,
                      child: homeViewModel.isShowingVersionHistory
                          ? const VersionHistorySection()
                          : const GeneratorSection(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
