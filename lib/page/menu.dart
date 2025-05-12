import 'package:flutter/material.dart';
import 'package:commit_me/design/color_system.dart';
import 'package:commit_me/page/home.dart';
// import 'package:travelmate/page/chatbotPage.dart';
// import 'package:travelmate/page/home.dart';
// import 'package:travelmate/page/map.dart';
// import 'package:travelmate/page/travelpickPage.dart';

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
        child: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
                  MaterialPageRoute(builder: (context) => Placeholder()),
                );
              }),

              SizedBox(width: 40),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70.0);
}
