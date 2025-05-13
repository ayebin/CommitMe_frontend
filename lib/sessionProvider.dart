import 'package:flutter/material.dart';

class SessionProvider with ChangeNotifier {
  int? _sessionId;

  int? get sessionId => _sessionId;

  void setSessionId(int? id) {
    _sessionId = id;
    notifyListeners();
  }
}