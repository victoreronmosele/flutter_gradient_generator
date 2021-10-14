import 'package:flutter/material.dart';

class LinearGradient {
  LinearGradient({required this.colorList});

  final List<Color> colorList;

  String _widgetStringTemplate =
      '''class PreviewScreen extends StatelessWidget {
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

  String toWidgetString() {
    return _widgetStringTemplate;
  }
}
