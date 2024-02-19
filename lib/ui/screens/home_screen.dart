import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/left_section.dart';
import 'package:flutter_gradient_generator/ui/widgets/header/header.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/generator_section.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/preview_section.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late GradientViewModel gradientService;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      gradientService = context.read<GradientViewModel>();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appDimensions = AppDimensions.of(context);

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
                      child: const GeneratorSection(),
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
