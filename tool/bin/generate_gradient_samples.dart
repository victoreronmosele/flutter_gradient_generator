import 'package:tool/tool.dart' as tool;

void main(List<String> arguments) {
  try {
    println('Generating gradient samples... 🚀', addNewLineToBeginning: true);
    tool.generateGradientSamples();
    println('Gradient samples generated! 🎉');
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
