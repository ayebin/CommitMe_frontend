import 'package:flutter/material.dart';

class ChatWidgetProvider with ChangeNotifier {
  String _role = '자기소개서/이력서 중심형';
  String _feedbackLength = '기본';
  String _feedbackType = '균형 잡힌 답변';

  String get role => _role;
  String get feedbackLength => _feedbackLength;
  String get feedbackType => _feedbackType;

  void setRole(String newRole) {
    _role = newRole;
    notifyListeners();
  }

  void setFeedbackLength(String newLength) {
    _feedbackLength = newLength;
    notifyListeners();
  }

  void setFeedbackType(String newType) {
    _feedbackType = newType;
    notifyListeners();
  }

  void resetToDefault() {
    _role = '자기소개서/이력서 중심형';
    _feedbackLength = '기본';
    _feedbackType = '균형 잡힌 답변';
    notifyListeners();
  }

  Map<String, String> toJson() {
    return {
      'role': _role,
      'feedbackLength': _feedbackLength,
      'feedbackType': _feedbackType,
    };
  }
}
