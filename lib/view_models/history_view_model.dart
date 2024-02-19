import 'package:flutter/foundation.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';

class HistoryViewModel with ChangeNotifier {
  HistoryViewModel({
    required this.onUndoOrRedo,
  });

  /// Called when an undo or redo action is performed.
  final void Function() onUndoOrRedo;

  List<AbstractGradient> get history => _history;

  /// The list of gradients that have been generated.
  final List<AbstractGradient> _history = [];

  List<AbstractGradient> get removedGradients => _removedGradients;

  /// The list of gradients that have been removed as a result of an undo action.
  final List<AbstractGradient> _removedGradients = [];

  void addNewGradientToHistory(AbstractGradient gradient) {
    _history.add(gradient);

    _removedGradients.clear();

    notifyListeners();
  }

  void undo() {
    if (_history.isEmpty) {
      return;
    }

    final removedGradient = _history.removeLast();
    _removedGradients.add(removedGradient);

    notifyListeners();

    onUndoOrRedo();
  }

  void redo() {
    if (_removedGradients.isEmpty) {
      return;
    }

    final lastRemovedGradient = _removedGradients.removeLast();
    _history.add(lastRemovedGradient);

    notifyListeners();

    onUndoOrRedo();
  }
}
