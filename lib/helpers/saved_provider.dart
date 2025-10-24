import 'package:flutter/material.dart';
import '../model/lamaran.dart';

class SavedProvider with ChangeNotifier {
  final List<Lamaran> _savedList = [];

  List<Lamaran> get savedList => _savedList;

  void toggleSave(Lamaran lamaran) {
    final isSaved = _savedList.any(
      (item) =>
          item.posisi == lamaran.posisi &&
          item.perusahaan == lamaran.perusahaan,
    );

    if (isSaved) {
      _savedList.removeWhere(
        (item) =>
            item.posisi == lamaran.posisi &&
            item.perusahaan == lamaran.perusahaan,
      );
    } else {
      _savedList.add(lamaran);
    }

    notifyListeners();
  }

  bool isSaved(Lamaran lamaran) {
    return _savedList.any(
      (item) =>
          item.posisi == lamaran.posisi &&
          item.perusahaan == lamaran.perusahaan,
    );
  }
}
