import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

/// Generates the gradient samples used in the app from the gradients.json file.
///
/// Throws an [Exception] if the gradients.json file is not found.
void generateGradientSamples() {
  try {
    //////////////////////////////////////////////////////
    /////// Read and parse the gradients.json file ///////
    //////////////////////////////////////////////////////

    final gradientsJsonPath = join(dirname(Platform.script.toFilePath()), '..',
        'assets', 'gradients.json');

    final gradientsJsonFile = File(gradientsJsonPath);

    if (!gradientsJsonFile.existsSync()) {
      throw Exception('gradients.json file not found');
    }

    final gradientsJson = gradientsJsonFile.readAsStringSync();

    final gradientsJsonDecoded = (json.decode(
      gradientsJson,
    ) as List<dynamic>)
        .cast<Map<String, dynamic>>();

    ///////////////////////////////////////////////////////
    /// Generate the gradient_samples.dart file content ///
    ///////////////////////////////////////////////////////

    final buffer = StringBuffer();

    buffer.writeln('import \'package:flutter/material.dart\';\n');

    buffer.writeln('class _GradientSample {');
    buffer.writeln(
        '    _GradientSample({required this.name, required this.colors});\n');
    buffer.writeln('    final String name;');
    buffer.writeln('    final List<Color> colors;');
    buffer.writeln('}\n');

    buffer.write('final gradientSamples = <_GradientSample>[');

    for (final gradient in gradientsJsonDecoded) {
      final gradientName = gradient['name'] as String;
      final gradientColors = gradient['colors'] as List<dynamic>;

      final gradientColorsHex = gradientColors
          .map((color) => color as String)
          .map((color) {
            String updatedColor = color;

            /// Remove the # prefix if present
            if (color.startsWith('#')) {
              updatedColor = color.substring(1);
            }

            /// Convert 3 digit hex color to 6 digit hex color
            /// 
            /// For example, #fff to #ffffff
            if (updatedColor.length == 3) {
              final r = updatedColor[0];
              final g = updatedColor[1];
              final b = updatedColor[2];

              updatedColor = '$r$r$g$g$b$b';
            }

            return '0xFF$updatedColor';
          })
          .map((color) => 'const Color($color)')
          .toList();

      buffer.write('_GradientSample(');
      buffer.write('name: \'${gradientName.replaceAll("'", "\\'")}\',');
      buffer.write('colors: [');
      buffer.writeAll(gradientColorsHex, ',');
      buffer.write(',]');
      buffer.write('),\n');
    }

    buffer.write('\n');
    buffer.write('];');

    //////////////////////////////////////////////////////
    /////// Write the generated gradient_samples.dart /////
    //////////////////////////////////////////////////////

    final generatedGradientSamplesPath = join(
        dirname(Platform.script.toFilePath()),
        '../..',
        'lib',
        'generated',
        'gradient_samples.dart');

    final generatedGradientSamplesFile = File(generatedGradientSamplesPath);

    generatedGradientSamplesFile.writeAsStringSync(buffer.toString());

    //////////////////////////////////////////////////////
    /////// Analyze and format the generated file /////////
    ////////////////////////////////////////////////////////

    final dartAnalyzeResult =
        Process.runSync('dart', ['analyze', generatedGradientSamplesPath]);

    if (dartAnalyzeResult.exitCode != 0) {
      throw Exception(
          'Failed to analyze the generated gradient_samples.dart file');
    }

    final dartFormatResult =
        Process.runSync('dart', ['format', generatedGradientSamplesPath]);

    if (dartFormatResult.exitCode != 0) {
      throw Exception(
          'Failed to format the generated gradient_samples.dart file');
    }
  } catch (e) {
    // Rethrowing so that the caller handles the exception.
    rethrow;
  }
}
