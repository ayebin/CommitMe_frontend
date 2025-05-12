import 'package:flutter/material.dart';
import 'package:commit_me/page/menu.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigationMenu(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
        color: Color(0xFFF0F8FF), // Light blue background color
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left section: Centered Text and Button
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Developer.',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '당신의 첫 면접을 도와드릴게요.',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '코드처럼 정교하게, 나를 표현하는 글쓰기',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '지금부터 당신만의 스크립트를 작성해보세요',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        //action추가
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF007BFF), // Blue button
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        '면접 준비하기',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Right section: Image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Image.asset('assets/images/illustration.png', width: 300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}