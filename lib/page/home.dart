import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:commit_me/design/color_system.dart';
import 'package:commit_me/page/nevigation_menu.dart';
import 'package:commit_me/page/info.dart';
import 'package:provider/provider.dart';
import 'package:commit_me/userProvider.dart';
import 'package:commit_me/infoProvider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _createUser();  // 여기서 context 사용 가능
  }

  Future<void> _createUser() async {
    try {
      final response = await Uri.parse('http://127.0.0.1:5000/user/add_user'); // 주소는 서버에 맞게 수정
      final result = await http.post(response);

      if (result.statusCode == 201) {
        final int userId = jsonDecode(result.body)['user_id'];

        // userId 설정
        Provider.of<UserProvider>(context, listen: false).setUserId(userId);

        // ✅ InfoProvider 초기화 (이력서 등 상태 리셋)
        Provider.of<InfoProvider>(context, listen: false).clear();
      } else {
        print('user 생성 실패: ${result.body}');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigationMenu(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 190.0, vertical: 200.0),
        color: Color(0xFFF0F8FF),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 왼쪽 텍스트 영역 (너비 고정)
            SizedBox(
              width: 600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, Developers.',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '당신의 첫 면접을 도와드릴게요.',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '코드처럼 정교하게, 나를 표현하는 글쓰기',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    '지금부터 당신만의 스크립트를 작성해보세요',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InfoPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainBlue,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      minimumSize: Size(380, 70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      '면접 준비하기',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 오른쪽 이미지 영역 (남은 공간 전부)
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/illustration.png',
                  fit: BoxFit.contain, // 필요 시 크기 보존
                  width: 600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}