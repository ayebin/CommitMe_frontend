import 'package:flutter/material.dart';
import 'package:commit_me/page/chat_screen.dart';
import 'package:commit_me/page/chat_setting.dart';
import 'package:commit_me/design/color_system.dart';
import 'package:commit_me/page/nevigation_menu.dart';
import 'package:provider/provider.dart';
import 'package:commit_me/userProvider.dart';
import 'package:commit_me/infoProvider.dart';
import 'package:commit_me/sessionProvider.dart';
import 'package:commit_me/chatwidgetProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotPage extends StatefulWidget {

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  @override
  void initState() {
    super.initState();
    _createSession(); // 페이지 열릴 때 세션 생성

    final chatWidgetProvider = Provider.of<ChatWidgetProvider>(context, listen: false);
    chatWidgetProvider.resetToDefault();
  }

  Future<void> _createSession() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    final infoId = Provider.of<InfoProvider>(context, listen: false).infoId;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/sesh/add_session'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'info_id': infoId,
        }),
      );

      if (response.statusCode == 201) {
        final sessionId = jsonDecode(response.body)['session_id'];
        Provider.of<SessionProvider>(context, listen: false).setSessionId(sessionId);
      } else {
        print('세션 생성 실패: ${response.body}');
      }
    } catch (e) {
      print('세션 생성 중 오류: $e');
    }
  }




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
                Expanded(flex: 4, child: ChatScreen()),
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