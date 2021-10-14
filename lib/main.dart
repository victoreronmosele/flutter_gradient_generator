import 'package:flutter/material.dart';
import 'package:dart_style/dart_style.dart';
import 'package:syntax_highlighter/syntax_highlighter.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: GeneratorScreen()),
          Expanded(child: PreviewScreen()),
        ],
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.red,
          ],
        ),
      ),
    );
  }
}

class GeneratorScreen extends StatelessWidget {
  final String _exampleCode = '''class PreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.red,
          ],
        ),
      ),
    );
  }
}''';

  const GeneratorScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SyntaxHighlighterStyle style =
        Theme.of(context).brightness == Brightness.dark
            ? SyntaxHighlighterStyle.darkThemeStyle()
            : SyntaxHighlighterStyle.lightThemeStyle();

    return Column(
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'monospace',
            ),
            children: <TextSpan>[
              DartSyntaxHighlighter(style).format(
                DartFormatter().format(_exampleCode),
              ),
              DartSyntaxHighlighter(style).format(Text(
                "Cow",
                style: TextStyle(
                  color: Colors.green,
                ),
              ).toStringDeep()),
            ],
          ),
        ),
      ],
    );
  }
}
