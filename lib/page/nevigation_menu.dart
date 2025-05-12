import 'package:flutter/material.dart';
import 'package:commit_me/design/color_system.dart';
import 'package:commit_me/page/home.dart';
import 'package:commit_me/page/info.dart';

class NavigationMenu extends StatelessWidget implements PreferredSizeWidget {
  Widget Menu(String name, GestureTapCallback onTap) {
    return InkWell(
      mouseCursor: MaterialStateMouseCursor.clickable,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (name == '홈') ...[
              Image.asset('assets/images/home.png', width: 18, height: 18),
              SizedBox(width: 6),
            ],
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black, // ✅ 텍스트 색상 추가
              ),
            ),
          ],
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1), // ✅ 하단 회색 줄
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: Image.asset('assets/images/logo.png', width: 200),
            ),
          ),
          Row(
            children: [
              Menu('홈', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }),
              Menu('면접준비', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InfoPage()),
                );
              }),
              SizedBox(width: 50),
            ],
          ),
        ],
      ),
    );
  }


  @override
  Size get preferredSize => Size.fromHeight(70.0);
}