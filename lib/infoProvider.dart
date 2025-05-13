import 'package:flutter/material.dart';

class InfoProvider with ChangeNotifier {
  int? _infoId;
  int? get infoId => _infoId;

  void setInfoId(int? infoid) {
    _infoId = infoid;
    notifyListeners();
  }
}