import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MessageProvider with ChangeNotifier {
  List<Map<String, String>> _messages = [];
  List<Map<String, String>> get messages => _messages;

  String firstSystemMessage = "안녕하세요! 👋\n"
      "맞춤형 여행 서비스 **TravelMate**입니다 ✨\n\n"
      "알려주신 기본 정보를 바탕으로, 여행 준비부터 일정 계획까지 맞춤형 여행 서비스를 제공할게요! 🧳✈️\n"
      "\n"
      "1️⃣ 추천: ~~ 추천해줘 (나라, 장소, 음식 등)\n"
      "2️⃣ 일정: ~~ 일정 짜줘\n"
      "3️⃣ 준비물: ~~ 준비물 알려줘\n"
      "\n원하시는 내용을 말해주세요! 😊💬";

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
    _messages.add({'content': content, 'sender': 'answer'});
    notifyListeners();
  }

  void addSystemMessage(String content) {
    _messages.add({'content': content, 'sender': 'answer'});
    notifyListeners();
  }

}