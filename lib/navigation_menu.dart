import 'package:flutter/material.dart';
import 'package:commit_me/color_system.dart';


class NavigationMenu extends StatelessWidget implements PreferredSizeWidget{
  const NavigationMenu();

  Widget Menu(String name, GestureTapCallback onTap, {Color? color}) {
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
          style: TextStyle(
            fontWeight: color != null ? FontWeight.bold : FontWeight.w500,
            color: color ?? Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFE5EDF2),
      child: Row(
        children: [
          InkWell(
            onTap: () {
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 95, vertical: 15),
              child: Row(
                children: [
                  Icon(Icons.token, color: AppColors.highBlue, size: 30,),
                  SizedBox(width: 10,),
                  Text("MindDIARY", style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
                ],
              ),
            )
          ),
          Row(
            children: [
              Menu('DIARY',  () {}, color: Color(0xFF689ADB)),
              SizedBox(width: 20,),
              Menu('DIAGNOSIS', () {}),
              SizedBox(width: 20,),
              Menu('EMOTION', () {}),
              SizedBox(width: 20,),
              Menu('HISTORY', () { }),
              SizedBox(width: 20,),
              Menu('REPORT',() {}),
              SizedBox(width: 40,)
            ],
          ),
          SizedBox(width: 530,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.account_circle, size: 35, color: Colors.grey,),
              SizedBox(width: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 17,),
                  Text("USER01", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),),
                  Row(
                    children: [
                      Text("사용중", style: TextStyle(color: Color(0xFF1F6E2F), fontSize: 10),),
                      Padding(
                        padding: const EdgeInsets.only(left: 2, top: 2),
                        child: Icon(Icons.circle, size: 5, color: Color(0xFF1F6E2F),),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          SizedBox(width: 50,),
          CircleAvatar(child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(Icons.notifications, size:23, color: Colors.black,),
          ), backgroundColor: Colors.white,),
          SizedBox(width: 12,),
          CircleAvatar(child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(Icons.list, size:23, color: Colors.black,),
          ), backgroundColor: Colors.white,),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70.0);
}
