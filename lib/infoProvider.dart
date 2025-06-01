import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class InfoProvider with ChangeNotifier {
  PlatformFile? _uploadedFile;
  int? _infoId;

  PlatformFile? get uploadedFile => _uploadedFile;
  int? get infoId => _infoId;

  void setUploadedFile(PlatformFile file) {
    _uploadedFile = file;
    notifyListeners();
  }

  void setInfoId(int id) {
    _infoId = id;
    notifyListeners();
  }

  // ✅ 추가: 상태 초기화 메서드
  void clear() {
    _uploadedFile = null;
    _infoId = null;
    notifyListeners();
  }
}