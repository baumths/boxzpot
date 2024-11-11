import 'dart:async' show StreamSubscription;

import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../../data/repositories/boxes_repository.dart';
import '../../entities/box.dart';

class BoxStore with ChangeNotifier {
  BoxStore({
    required this.boxesRepository,
    required this.boxId,
  }) {
    _boxSubscription = boxesRepository.watchBox(boxId).listen(_onBoxChanged);
    _onBoxChanged(boxesRepository.getBoxById(boxId));
  }

  final BoxesRepository boxesRepository;
  final int boxId;

  StreamSubscription<Box>? _boxSubscription;

  Box get box => _box;
  late Box _box;

  void _onBoxChanged(Box box) {
    _box = box;
    notifyListeners();
  }

  @override
  void dispose() {
    _boxSubscription?.cancel();
    _boxSubscription = null;
    super.dispose();
  }
}
