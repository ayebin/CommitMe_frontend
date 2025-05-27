import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class InfoProvider with ChangeNotifier {
  int? _infoId;
  int? get infoId => _infoId;

  void setInfoId(int? infoid) {
    _infoId = infoid;
    notifyListeners();
  }

  String? _uploadedFilePath;
  String? get uploadedFilePath => _uploadedFilePath;

  // 업로드된 파일 경로 저장 메서드
  PlatformFile? _uploadedFile; // ✅ 수정: path 대신 PlatformFile 전체 저장
  PlatformFile? get uploadedFile => _uploadedFile;

  // ✅ 수정된 메서드: 파일 객체 자체 저장
  void setUploadedFile(PlatformFile? file) {
    _uploadedFile = file;
    notifyListeners();
  }
}