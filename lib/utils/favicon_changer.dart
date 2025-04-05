import 'package:web/web.dart';

class FaviconChanger {
  void changeFavicon({
    required String dataUrl,
  }) {
    final faviconElement = _getFaviconElement();

    faviconElement.setAttribute('href', dataUrl);
  }

  Element _getFaviconElement() {
    var favicon = document.querySelector('link[rel~="icon"]');

    if (favicon == null) {
      favicon = document.createElement('link');

      favicon.setAttribute('rel', 'icon');
      favicon.setAttribute('type', 'image/png');

      document.head?.appendChild(favicon);
    }

    return favicon;
  }
}
