import 'dart:async' show StreamSubscription;

import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../data/repositories/boxes_repository.dart';
import '../entities/box.dart';

class BoxesStore with ChangeNotifier {
  BoxesStore(this._repository) {
    _subscription = _repository.watchAllBoxes().listen(_onBoxesChanged);
    _onBoxesChanged(_repository.getAllBoxes());
  }

  final BoxesRepository _repository;

  StreamSubscription<List<Box>>? _subscription;

  List<Box> get boxes => _boxes;
  List<Box> _boxes = [];

  void _onBoxesChanged(List<Box> boxes) {
    _boxes = boxes;
    notifyListeners();
  }

  void createBox({
    required String code,
    required String name,
    required String description,
  }) {
    _repository.createBox(
      code: code,
      name: name,
      description: description,
    );
  }

  void updateBox({
    required int boxId,
    required String name,
    required String code,
    required String description,
  }) {
    _repository.updateBox(
      id: boxId,
      code: code,
      name: name,
      description: description,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _boxes = [];
    super.dispose();
  }
}
