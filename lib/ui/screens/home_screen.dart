import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/view_models/gradient_view_model.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/generator_section.dart';
import 'package:flutter_gradient_generator/ui/screens/sections/preview_section.dart';
import 'package:flutter_gradient_generator/ui/widgets/footer/footer_widget.dart';
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

    final displayPortrait = appDimensions.shouldDisplayPortraitUI;

    return Focus(
      child: Scaffold(
        body: Row(
          crossAxisAlignment: displayPortrait
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: displayPortrait ? 1 : 0,
              child: const Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: GeneratorSection(),
                  ),
                  FooterWidget()
                ],
              ),
            ),
            if (!displayPortrait)
              const Flexible(
                child: PreviewSection.landscape(),
              ),
          ],
        ),
      ),
    );
  }
}
