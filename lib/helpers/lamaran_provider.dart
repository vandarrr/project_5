import 'package:flutter/material.dart';
import '../model/lamaran.dart';

class LamaranProvider with ChangeNotifier {
  final List<Lamaran> _lamaranList = [];

  List<Lamaran> get lamaranList => _lamaranList;

  void tambahLamaran(Lamaran lamaran) {
    _lamaranList.add(lamaran);
    notifyListeners();
  }
}
