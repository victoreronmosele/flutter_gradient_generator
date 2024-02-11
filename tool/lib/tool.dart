import 'dart:convert';
import 'package:file/file.dart';

/// Generates the gradient samples used in the app from the gradients.json file.
///
/// Throws an [Exception] if the gradients.json file is not found.
/// 
/// [onGenerationComplete] is called when the generation is complete.
void generateGradientSamples({
  required String gradientsJsonPath,
  required String generatedGradientSamplesPath,
  required FileSystem fileSystem,
  required void Function() onGenerationComplete,
}) {
  try {
    //////////////////////////////////////////////////////
    /////// Read and parse the gradients.json file ///////
    //////////////////////////////////////////////////////

    final gradientsJsonFile = fileSystem.file(gradientsJsonPath);

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

    buffer.writeln('// This is a generated file. Do not edit it manually.');
    buffer.writeln('//');
    buffer.writeln(
        '// To regenerate this file, run the following command from the project root:');
    buffer.writeln('// dart tool/bin/generate_gradient_samples.dart\n');

    buffer.writeln('import \'package:flutter/material.dart\';\n');

    buffer.writeln('class _GradientSample {');
    buffer.writeln(
        '    const _GradientSample({required this.name, required this.colors});\n');
    buffer.writeln('    final String name;');
    buffer.writeln('    final List<Color> colors;');
    buffer.writeln('}\n');

    buffer.write('const gradientSamples = <_GradientSample>[\n');

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
          .map((color) => 'Color($color)')
          .toList();

      buffer.write('_GradientSample(');
      buffer.write('name: \'${gradientName.replaceAll("'", "\\'")}\', ');
      buffer.write('colors: [');
      buffer.writeAll(gradientColorsHex, ', ');
      buffer.write(',]');
      buffer.write('),\n');
    }

    buffer.write('];');

    //////////////////////////////////////////////////////
    /////// Write the generated gradient_samples.dart /////
    //////////////////////////////////////////////////////

    final generatedGradientSamplesFile =
        fileSystem.file(generatedGradientSamplesPath);

    generatedGradientSamplesFile.writeAsStringSync(buffer.toString());

    //////////////////////////////////////////////////////
    /////// Call onGenerationComplete callback ////////////
    ////////////////////////////////////////////////////////

    onGenerationComplete();
  } catch (e) {
    // Rethrowing so that the caller handles the exception.
    rethrow;
  }
}
