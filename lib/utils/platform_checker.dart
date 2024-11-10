import 'package:web/web.dart';

class PlatformChecker {
  bool isMac() {
    return window.navigator.platform.toLowerCase().contains('mac');
  }
}
