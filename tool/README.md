# Flutter Gradient Generator Tool

A command-line application providing tools that assist with development of Flutter Gradient Generator.

## Current tools:
- ### Gradient Samples Generator: 
  
  This generates a Dart file containing a list of gradient samples used in the Flutter Gradient Generator.

  - The gradient samples are generated from the `gradients.json` file located in the `assets` directory.

  - The generated file is located in the `Flutter Gradient Generator` project at `lib/generated/gradient_samples.dart`.


  #### Usage: 
  Run the following command:
  ```dart
  dart bin/generate_gradient_samples.dart
  ```

## Testing:
The tool can be tested by running the following command:
```dart
flutter test
```