import 'package:file/memory.dart';
import 'package:path/path.dart';
import 'package:tool/tool.dart';
import 'package:test/test.dart';

void main() {
  group('generateGradientSamples', () {
    final gradientsJsonPath = 'assets/gradients.json';
    final generatedGradientSamplesPath = 'lib/generated/gradient_samples.dart';

    late MemoryFileSystem memoryFileSystem;

    setUp(() {
      memoryFileSystem = MemoryFileSystem();

      memoryFileSystem.directory(dirname(gradientsJsonPath)).createSync();

      memoryFileSystem
          .directory(dirname(generatedGradientSamplesPath))
          .createSync(recursive: true);
    });

    test(
      'should generate correct gradient samples content at the specified path',
      () {
        memoryFileSystem.file(gradientsJsonPath).writeAsStringSync('''
      [
        {
          "name": "Sample Gradient 1",
          "colors": ["#FF0000", "#00FF00", "#0000FF"]
        },
        {
          "name": "Sample Gradient 2",
          "colors": ["#FF0000", "#00FF00"]
        }
      ]
      ''');

        generateGradientSamples(
          gradientsJsonPath: gradientsJsonPath,
          generatedGradientSamplesPath: generatedGradientSamplesPath,
          fileSystem: memoryFileSystem,
          onGenerationComplete: () {},
        );

        final generatedGradientSamplesFile =
            memoryFileSystem.file(generatedGradientSamplesPath);

        expect(generatedGradientSamplesFile.existsSync(), true);

        final generatedGradientSamplesFileContent =
            generatedGradientSamplesFile.readAsStringSync();

        final expectedGeneratedGradientSamplesFileContent = '''
// This is a generated file. Do not edit it manually.
//
// To regenerate this file, run the following command from the project root:
// dart tool/bin/generate_gradient_samples.dart

import 'package:flutter/material.dart';

class _GradientSample {
    const _GradientSample({required this.name, required this.colors});

    final String name;
    final List<Color> colors;
}

const gradientSamples = <_GradientSample>[
_GradientSample(name: 'Sample Gradient 1', colors: [Color(0xFFFF0000), Color(0xFF00FF00), Color(0xFF0000FF),]),
_GradientSample(name: 'Sample Gradient 2', colors: [Color(0xFFFF0000), Color(0xFF00FF00),]),
];
''';

        expect(generatedGradientSamplesFileContent.trim(),
            expectedGeneratedGradientSamplesFileContent.trim());
      },
    );

    test('should throw an exception if the gradients.json file is not found',
        () {
      expect(
        () => generateGradientSamples(
          gradientsJsonPath: gradientsJsonPath,
          generatedGradientSamplesPath: generatedGradientSamplesPath,
          fileSystem: memoryFileSystem,
          onGenerationComplete: () {},
        ),
        throwsException,
      );
    });
  });
}
