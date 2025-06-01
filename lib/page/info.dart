import 'package:flutter/material.dart';
import 'package:commit_me/page/nevigation_menu.dart';
import 'package:commit_me/design/color_system.dart';
import 'package:commit_me/page/chatbotPage.dart';
import 'package:commit_me/page/upload_resume.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:commit_me/userProvider.dart';
import 'package:commit_me/infoProvider.dart';
import 'package:http_parser/http_parser.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _historyController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();

  //로딩바
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 바깥 클릭 시 닫히지 않도록
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  "파일을 분석하고 있습니다...",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> _submitInfo(BuildContext context) async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    print('Sending userId: $userId');

    _showLoadingDialog(context); // <-- 로딩 다이얼로그 띄우기

    try {
      var uri = Uri.parse('http://127.0.0.1:5000/info/add_info');
      var request = http.MultipartRequest('POST', uri);

      request.fields['user_id'] = userId.toString();
      request.fields['position'] = _positionController.text;
      request.fields['interest'] = _interestController.text;
      request.fields['history'] = _historyController.text;
      request.fields['language'] = _languageController.text;
      request.fields['project'] = _projectController.text;

      final uploadedFile = Provider.of<InfoProvider>(context, listen: false).uploadedFile;
      if (uploadedFile != null) {
        if (uploadedFile.bytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'resume',
              uploadedFile.bytes!,
              filename: uploadedFile.name,
              contentType: MediaType('application', 'octet-stream'),
            ),
          );
        } else if (uploadedFile.path != null) {
          request.files.add(
            await http.MultipartFile.fromPath('resume', uploadedFile.path!),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      Navigator.of(context, rootNavigator: true).pop(); // <-- 로딩 다이얼로그 닫기

      if (response.statusCode == 201) {
        final infoId = jsonDecode(response.body)['info_id'];
        Provider.of<InfoProvider>(context, listen: false).setInfoId(infoId);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotPage()));
      } else {
        print('info 저장 실패: ${response.body}');
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop(); // 에러 시에도 닫기
      print('요청 중 오류 발생: $e');
    }
  }



  Widget _buildInputField(String label, TextEditingController controller) => TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey),
      floatingLabelStyle: TextStyle(color: Colors.black),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    ),
  );

  Widget _buildMultilineInputField(String label, TextEditingController controller) => TextField(
    controller: controller,
    maxLines: 4,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey),
      floatingLabelStyle: TextStyle(color: Colors.black),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    ),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavigationMenu(),
      body: Stack(
        children: [
          // 배경 이미지
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/info_background.png',
              height: 450,
              fit: BoxFit.cover,
            ),
          ),

          // 정보 입력 상단 라벨
          Positioned(
            left: 110,
            top: 210,
            child: Container(
              width: 220,
              height: 90,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: Color(0xFFDBE7ED),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Text("정보 입력", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.DarkBlue)),
            ),
          ),

          // 정보 입력 전체 박스
          Positioned(
            top: 270,
            left: 110,
            child: Container(
              width: 1300,
              height: 480,
              padding: EdgeInsets.fromLTRB(70, 70, 70, 70),
              decoration: BoxDecoration(
                color: Color(0xFFDBE7ED),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이력서 업로드 박스
                  // 이력서 업로드 박스
                  Container(
                    width: 400,
                    height: 400,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.mainBlue, width: 2),
                    ),
                    child: Consumer<InfoProvider>(
                      builder: (context, infoProvider, _) {
                        final uploadedFile = infoProvider.uploadedFile;

                        if (uploadedFile != null) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.insert_drive_file, size: 80, color: AppColors.mainBlue),
                              SizedBox(height: 20),
                              Text(
                                '업로드된 파일:',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 8),
                              Text(
                                uploadedFile.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  showUploadDialog(context);
                                },
                                icon: Icon(Icons.change_circle),
                                label: Text('다시 업로드'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainBlue,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(250, 60),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/upload_logo.png',
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(height: 10),
                              Text(
                                '당신의 CV를 업로드해 주세요.\n더 맞춤화된 스크립트 작성이 가능합니다.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  showUploadDialog(context);
                                },
                                icon: Icon(Icons.upload_file, size: 28),
                                label: Text('이력서 불러오기'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainBlue,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(250, 80),
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),


                  SizedBox(width: 60),

                  // 입력 폼
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 안내 문구 + 아이콘
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/notice.png',
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                '만약 준비된 이력서 없거나, 면접 준비만 하고 싶을 경우 아래 사항을 입력해주세요',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 18),

                        // 양쪽 입력 필드
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  _buildInputField('어떤 직무를 희망하시나요?', _positionController),
                                  SizedBox(height: 16),
                                  _buildInputField('어떤 경력이 있으신가요?', _historyController),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                children: [
                                  _buildInputField('현재 관심사가 무엇인가요?', _interestController),
                                  SizedBox(height: 16),
                                  _buildInputField('주 사용 / 가능한 언어는 무엇인가요?', _languageController),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),
                        _buildMultilineInputField('프로젝트 경험이 있다면, 자유롭게 작성해주세요', _projectController),
                        SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => _submitInfo(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: BorderSide(color: Colors.black),
                              minimumSize: Size(150, 45),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: Text('NEXT >', style: TextStyle(fontSize: 18)),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}