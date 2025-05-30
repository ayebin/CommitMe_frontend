import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MessageProvider with ChangeNotifier {
  List<Map<String, String>> _messages = [];
  List<Map<String, String>> get messages => _messages;

  String firstSystemMessage = "안녕하세요! 👋\n"
      "IT 계열 맞춤형 면접 준바 서비스 **CommitMe**입니다 ✨\n\n"
      "알려주신 기본 정보를 바탕으로, 면접을 잘 대비할 수 있게 도와드리겠습니다! 💻️💪🏻\n"
      "\n"
      "1️⃣ '시작' 또는 '준비 됨' 이라고 말씀해주시면 예상 질문을 드리겠습니다!📃\n"
      "2️⃣ 질문에 답변을 해주시면, 보완해야할 점을 알려드리겠습니다!📍\n"
      "\n준비되셨습니까? 😊💬";

  String getLatestContentBySubstring(String substring) {
    final filteredMessages = _messages
        .where((message) => message['content']?.contains(substring) ?? false)
        .toList();
    if (filteredMessages.isEmpty) {
      return '';
    }
    return filteredMessages.last['content'] ?? '';
  }


  String getLatestContentByPrefix(List<String> prefixes) {
    final filteredMessages = _messages.where((message) {
      final content = message['content'] ?? '';
      return prefixes.any((prefix) => content.contains(prefix));
    }).toList();

    if (filteredMessages.isEmpty) {
      return '';
    }
    return filteredMessages.last['content'] ?? '';
  }

  void addMessage(String content, String sender) {

    _messages.removeWhere((msg) => msg['sender'] == 'loading');

    _messages.add({'content': content, 'sender': sender});
    notifyListeners();
  }

  void setMessages(List<dynamic> messages) {
    _messages = messages.map((message) {
      return {
        'content': message['content']?.toString() ?? '',
        'sender': message['sender']?.toString() ?? ''
      };
    }).toList();

    notifyListeners();
  }

  Future<void> loadMessages(int sessionId) async {
    final url = Uri.parse('http://127.0.0.1:5000/llm/messages');
    try {
      final response = await http.get(
        url.replace(queryParameters: {'session_id': sessionId.toString()}),
        headers: {'Content-type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> messages = jsonDecode(response.body);
        setMessages(messages);

        addSystemMessage(firstSystemMessage);

      } else {
        print('Failed to load message: ${response.body}');
      }
      notifyListeners();
    } catch (e) {
      print('Error loading messages: $e');
    }
    notifyListeners();
  }

  void addLoadingMessage() {
    _messages.add({'content': '', 'sender': 'loading'});
    notifyListeners();
  }

  void updateResponseMessage(String content) {
    _messages.removeWhere((msg) => msg['sender'] == 'loading');
    _messages.add({'content': content, 'sender': 'system'});
    notifyListeners();
  }

  void addSystemMessage(String content) {
    _messages.add({'content': content, 'sender': 'system'});
    notifyListeners();
  }

}