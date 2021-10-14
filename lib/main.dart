import 'package:any_syntax_highlighter/any_syntax_highlighter.dart';
import 'package:any_syntax_highlighter/themes/any_syntax_highlighter_theme_collection.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gradient Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Color> colorList = [Colors.red, Colors.blue, Colors.green];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: GeneratorScreen(colorList: colorList)),
          Expanded(child: PreviewScreen(colorList: colorList)),
        ],
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  final List<Color> colorList;

  const PreviewScreen({Key? key, required this.colorList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: colorList,
        ),
      ),
    );
  }
}

class GeneratorScreen extends StatelessWidget {
  final List<Color> colorList;

  GeneratorScreen({Key? key, required this.colorList}) : super(key: key);

  final _maximumLineNumber = 15;

  String get _colorsInIndividualLines => colorList.join(',\n ');

  late String _exampleCode = 
  
  '''
  Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [\n ${_colorsInIndividualLines}]
        ),
      ),
  ),
''';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnySyntaxHighlighter(
        _exampleCode,
        padding: 0,
        isSelectableText: true,
        fontSize: 16,
        theme: AnySyntaxHighlighterThemeCollection.defaultLightTheme,
        maxLines: _maximumLineNumber,
        textWidthBasis: TextWidthBasis.longestLine,
      ),
    );
  }
}
