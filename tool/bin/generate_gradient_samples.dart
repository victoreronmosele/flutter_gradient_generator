import 'dart:io';

import 'package:file/local.dart';
import 'package:path/path.dart';
import 'package:tool/tool.dart' as tool;

void main(List<String> arguments) {
  try {
    println('Generating gradient samples... 🚀', addNewLineToBeginning: true);

    final gradientsJsonPath = join(dirname(Platform.script.toFilePath()), '..',
        'assets', 'gradients.json');

    final generatedGradientSamplesPath = join(
        dirname(Platform.script.toFilePath()),
        '../..',
        'lib',
        'generated',
        'gradient_samples.dart');

    tool.generateGradientSamples(
      gradientsJsonPath: gradientsJsonPath,
      generatedGradientSamplesPath: generatedGradientSamplesPath,
      fileSystem: const LocalFileSystem(),
      onGenerationComplete: () {
        // Analyze the generated file

        final dartAnalyzeResult =
            Process.runSync('dart', ['analyze', generatedGradientSamplesPath]);

        if (dartAnalyzeResult.exitCode != 0) {
          throw Exception(
              'Failed to analyze the generated gradient_samples.dart file');
        }

        // Format the generated file

        final dartFormatResult =
            Process.runSync('dart', ['format', generatedGradientSamplesPath]);

        if (dartFormatResult.exitCode != 0) {
          throw Exception(
              'Failed to format the generated gradient_samples.dart file');
        }

        println('Gradient samples generated! 🎉');
      },
    );
  } catch (e) {
    print('Error generating gradient samples 😢:');
    println('    $e');
  }
}

/// Prints the [object] to the console with a new line at the end.
///
/// Optionally, a new line can be added to the beginning of the output by
/// setting [addNewLineToBeginning] to `true`.
///
/// [addNewLineToBeginning] defaults to `false`.
void println(Object? object, {bool addNewLineToBeginning = false}) {
  if (addNewLineToBeginning) {
    print('\n');
  }
  print(object);
  print('\n');
}
