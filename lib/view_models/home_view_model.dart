import 'package:flutter/foundation.dart';

class HomeViewModel with ChangeNotifier {
  bool _isShowingVersionHistory = false;

  bool get isShowingVersionHistory => _isShowingVersionHistory;

  void _modifyIsShowingVersionHistory({required bool shouldShow}) {
    _isShowingVersionHistory = shouldShow;

    notifyListeners();
  }

  void showVersionHistory() {
    _modifyIsShowingVersionHistory(shouldShow: true);
  }

  void hideVersionHistory() {
    _modifyIsShowingVersionHistory(shouldShow: false);
  }
}
