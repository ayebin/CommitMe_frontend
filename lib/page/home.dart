import 'package:commit_me/design/color_system.dart';
import 'package:flutter/material.dart';
import 'package:commit_me/page/nevigation_menu.dart';
import 'package:commit_me/page/info.dart';

class HomePage extends StatelessWidget {
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