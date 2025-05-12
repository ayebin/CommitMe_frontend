// upload_resume.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:commit_me/design/color_system.dart';
import 'package:file_picker/file_picker.dart';

Future<void> showUploadDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 200, vertical: 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: 600,
          height: 400,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white, // ✅ 여기가 중요!
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 타이틀과 닫기
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("파일 업로드", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              Divider(),

              // 드래그 영역 시각화 대체
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.picture_as_pdf, size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text("여기에 파일을 드래그하세요.\n(파일 형식: PDF)",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );

                          if (result != null) {
                            File file = File(result.files.single.path!);
                            // TODO: 파일 업로드 처리
                            Navigator.of(context).pop(); // 팝업 닫기
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.highBlue, // ✅ 여기에 원하는 색상 적용
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("내 컴퓨터에서 파일 선택"),
                      )

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
