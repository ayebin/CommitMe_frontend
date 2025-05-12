import 'package:flutter/material.dart';
import 'package:commit_me/page/chat_screen.dart';
import 'package:commit_me/page/chat_setting.dart';
import 'package:commit_me/design/color_system.dart';
import 'package:commit_me/page/nevigation_menu.dart';

class ChatbotPage extends StatefulWidget {

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigationMenu(),
      body: Column(
        children: [
          //NavigationDeco(),
          Expanded(
            child: Row(
              children: [
                Expanded(flex: 1, child: ChatSetting()),
                Expanded(flex: 1, child: ChatScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget NavigationDeco() {
    return Container(
      color: Color(0xFFE5EDF2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 245,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Colors.grey))
            ),
          ),
          Container(
            width: 60,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 2, color: Color(0xFF689ADB)))
            ),
          ),
          Container(
            width: 1205,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Colors.grey))
            ),
          ),
        ],
      ),
    );
  }
}