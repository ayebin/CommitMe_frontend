import 'package:commit_me/Widget_Chat/reportDialog.dart';
import 'package:flutter/material.dart';
import 'package:commit_me/design/color_system.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:commit_me/userProvider.dart';
import 'package:commit_me/infoProvider.dart';
import 'package:commit_me/sessionProvider.dart';
import 'package:commit_me/chatwidgetProvider.dart';
import 'package:commit_me/messageProvider.dart';

class ChatScreen extends StatefulWidget {

  @override
  _ChatScreenState createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [];
  int otherMessageCount = 0;

  bool _showOverlay = true;

  int _questionIndex = 0;
  String _currentQuestion = "Q. 질문을 생성 중입니다...";

  bool _showFinishedPopup = false; // ✅ 질문 3개 단위마다 팝업을 한 번만 띄우기 위한 상태

  final TextEditingController _finalAnswerController = TextEditingController(); // 최종 답변 입력용
  String _feedbackText = '최종 답변 작성 후 제출 버튼을 누르시면 피드백이 생성됩니다.'; // 피드백 내용 표시용
  String? _qualityText;

  bool _isLoadingChat = false;
  bool _isLoadingFeedback = false;
  bool _isLoadingReport = false;

  bool _isFinalAnswerSubmitted = false;

  void _handleSendMessage(String message) async {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({'message': message, 'sender': 'user'}); //
      });

      await _sendMessageToBackend(message); //
    }
  }

  Future<void> _sendMessageToBackend(String message) async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    final infoId = Provider.of<InfoProvider>(context, listen: false).infoId;
    final sessionId = Provider.of<SessionProvider>(context, listen: false).sessionId;

    final chatSettings = Provider.of<ChatWidgetProvider>(context, listen: false);
    final role = chatSettings.role;
    final feedbackLength = chatSettings.feedbackLength;
    final feedbackType = chatSettings.feedbackType;

    final body = {
      'message': message,
      'user_id': userId,
      'info_id': infoId,
      'session_id': sessionId,
      'role': role,
      'feedbackLength': feedbackLength,
      'feedbackType': feedbackType,
    };

    setState(() {
      _isLoadingChat = true;
      _messages.add({
        'message': '',
        'sender': 'system',
        'loading': 'true' // ✅ 로딩 인디케이터용 메시지
      });
    });

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5000/chat/chatting"), // ✅ 백엔드 주소
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final botMessage = res['response'];

        setState(() {
          // ✅ 기존 로딩 메시지 제거
          _messages.removeWhere((msg) => msg['loading'] == 'true');

          // ✅ 실제 응답 추가
          _messages.add({'message': botMessage, 'sender': 'system'});
        });
      } else {
        print("백엔드 오류: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("에러 발생: $e");
    } finally {
      setState(() {
        _isLoadingChat = false;  // ✅ 로딩 종료
      });
    }
  }

  Future<void> _generateQuestion() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    final infoId = Provider.of<InfoProvider>(context, listen: false).infoId;
    final sessionId = Provider.of<SessionProvider>(context, listen: false).sessionId;

    final chatSettings = Provider.of<ChatWidgetProvider>(context, listen: false);
    final role = chatSettings.role;

    final body = {
      'user_id': userId,
      'info_id': infoId,
      'session_id': sessionId,
    };

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5000/chat/question"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final question = res['question'];

        setState(() {
          _messages.clear();
          _finalAnswerController.clear();
          _feedbackText = '최종 답변 작성 후 제출 버튼을 누르시면 피드백이 생성됩니다.';
          _isFinalAnswerSubmitted = false;  // ✅ 제출 상태 초기화
          _qualityText = null;
          _questionIndex += 1;
          _currentQuestion = "Q. $question";
        });
      } else {
        print("질문 생성 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("에러: $e");
    }
  }


  Future<void> _submitFinalAnswer(String finalAnswer) async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    final infoId = Provider.of<InfoProvider>(context, listen: false).infoId;
    final sessionId = Provider.of<SessionProvider>(context, listen: false).sessionId;

    final chatSettings = Provider.of<ChatWidgetProvider>(context, listen: false);
    final role = chatSettings.role;
    final feedbackLength = chatSettings.feedbackLength;
    final feedbackType = chatSettings.feedbackType;

    final body = {
      'user_id': userId,
      'info_id': infoId,
      'session_id': sessionId,
      'final_answer': finalAnswer,
      'role': role,
      'feedbackLength': feedbackLength,
      'feedbackType': feedbackType,
    };

    setState(() {
      _isLoadingFeedback = true;
    });

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5000/chat/feedback"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final feedback = res['feedback'];
        final quality = res['quality'];

        setState(() {
          _feedbackText = feedback;
          _qualityText = quality != null ? '피드백 점수: $quality / 5' : null;
          _isFinalAnswerSubmitted = true;
        });
      } else {
        print("백엔드 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("에러: $e");
    } finally {
      setState(() {
        _isLoadingFeedback = false;
      });
    }

  }

  Future<void> _fetchFinalReport() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    final infoId = Provider.of<InfoProvider>(context, listen: false).infoId;
    final sessionId = Provider.of<SessionProvider>(context, listen: false).sessionId;

    final chatSettings = Provider.of<ChatWidgetProvider>(context, listen: false);
    final role = chatSettings.role;
    final feedbackLength = chatSettings.feedbackLength;
    final feedbackType = chatSettings.feedbackType;

    final body = {
      'user_id': userId,
      'info_id': infoId,
      'session_id': sessionId,
      'role': role,
      'feedbackLength': feedbackLength,
      'feedbackType': feedbackType,
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Expanded(child: Text("최종 보고서를 생성 중입니다...")),
          ],
        ),
      ),
    );

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5000/chat/report"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final report = res['report'];

        Navigator.of(context).pop();

        showDialog(
          context: context,
          builder: (context) => ReportDialog(report: report), // ✅ 변경
        );
      } else {
        print("최종 보고서 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("에러: $e");
    }
  }

  Widget _buildOverlay(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.white.withOpacity(0.8), // 반투명 흰색
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _showOverlay = false;
            });
            _generateQuestion(); // ✅ 질문 생성 호출
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1B2559),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text("시작하기", style: TextStyle(fontSize: 25)),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double SW = MediaQuery.of(context).size.width;
    double SH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, top: 25, bottom: 25, right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                //질문칸
                Container(
                  width : 1200,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF9C9C9C)))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentQuestion,
                        style: TextStyle(fontSize: SH * 0.025),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "$_questionIndex / ${((_questionIndex - 1) ~/ 3 + 1) * 3}",
                        style: TextStyle(fontSize: SH * 0.018, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Row(
                    children: [
                      //질의응답 챗구간
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: _messages.map((messageData) {
                                    final sender = messageData['sender']!;
                                    final isLoading = messageData['loading'] == 'true'; // ✅ 로딩 메시지 구분
                                    final message = messageData['message'] ?? '';       // null safety

                                    if (isLoading) {
                                      // ✅ 로딩 인디케이터 표시
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 30, top: 10),
                                        child: Row(
                                          children: [
                                            CircularProgressIndicator(color: Color(0xFF1B2559)),
                                            SizedBox(width: 10),
                                            Text("답변 생성 중입니다...", style: TextStyle(color: Colors.grey)),
                                          ],
                                        ),
                                      );
                                    }

                                    // ✅ 기존 메시지 출력 그대로 유지
                                    return Row(
                                      mainAxisAlignment: sender == 'user' ? MainAxisAlignment.end : MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (sender == 'system') ...[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 30.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppColors.DarkBlue,
                                                  width: 0.5,
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                child: ClipOval(
                                                  child: Image.asset(
                                                    'assets/images/chatbot_icon.png',
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                radius: 20,
                                                backgroundColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                        ],
                                        Column(
                                          crossAxisAlignment: sender == 'user' ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context).size.width * 0.3,
                                              ),
                                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                              margin: EdgeInsets.symmetric(horizontal: 10),
                                              decoration: BoxDecoration(
                                                color: sender == 'user' ? Color(0xFF689ADB) : Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Color(0xFF627A98),
                                                ),
                                              ),
                                              child: Text(
                                                message,
                                                style: TextStyle(
                                                  color: sender == 'user' ? Colors.white : Color(0xFF1B2559),
                                                  fontSize: 16,
                                                ),
                                                softWrap: true,
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                          ],
                                        ),
                                        if (sender == 'user') SizedBox(width: 23),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            ChatInputBar(
                              onSend: _handleSendMessage,
                            ),
                          ],
                        ),
                      ),

                      //피드백 구간
                      Expanded(
                        flex: 5,
                        child: Container(
                          child: Column(
                            children: [
                              //1. 최종답변 입력 컨테이너
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(color: Color(0xFFF7F8FA), border: Border(bottom: BorderSide(color: Color(0xFF9C9C9C)))),
                                        child: Row(
                                          children: [
                                            Icon(Icons.sort),
                                            SizedBox(width: 10,),
                                            Text("당신의 최종 답변", style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _finalAnswerController,
                                          readOnly: _isFinalAnswerSubmitted,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: '답변을 입력하세요',
                                            hintStyle: TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(borderSide: BorderSide.none,),
                                          ),
                                          maxLines: null,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: _isFinalAnswerSubmitted
                                                  ? null // 🔹 제출되었으면 버튼 비활성화
                                                  : () {
                                                final finalAnswer = _finalAnswerController.text.trim();
                                                if (finalAnswer.isNotEmpty) {
                                                  _submitFinalAnswer(finalAnswer);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: _isFinalAnswerSubmitted ? Colors.grey : Color(0xFF1B2559),
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              ),
                                              child: Text('제출', style: TextStyle(fontSize: 16)),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              //2. 피드백 컨테이너
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(color: Color(0xFFF7F8FA), border: Border(top: BorderSide(color: Color(0xFF9C9C9C)),bottom: BorderSide(color: Color(0xFF9C9C9C)))),
                                        child: Row(
                                          children: [
                                            Icon(Icons.sort),
                                            SizedBox(width: 10,),
                                            Text("답변에 대한 피드백", style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFD5DDEC),
                                            border: Border(bottom: BorderSide(color: Color(0xFF9C9C9C))),
                                          ),
                                          child: _isLoadingFeedback
                                              ? Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(color: Color(0xFF1B2559)),
                                                SizedBox(height: 10),
                                                Text("피드백 생성 중입니다...", style: TextStyle(color: Colors.grey)),
                                              ],
                                            ),
                                          )
                                              : SingleChildScrollView( // ✅ 추가
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _feedbackText,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: _feedbackText == '최종 답변 작성 후 제출 버튼을 누르시면 피드백이 생성됩니다.'
                                                        ? Colors.grey
                                                        : Colors.black,
                                                  ),
                                                ),
                                                if (_qualityText != null) ...[
                                                  SizedBox(height: 10),
                                                  Text(
                                                    _qualityText!,
                                                    style: TextStyle(fontSize: 14, color: Colors.black87),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 15,),

                              //3. 보고서 & 다음버튼
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 400,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_questionIndex % 3 != 0) {
                                            // 질문 개수가 3의 배수가 아닐 때는 팝업만 띄움
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text("질문 부족"),
                                                content: Text("최종 보고서는 3개 단위로 생성할 수 있습니다."),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(),
                                                    child: Text("확인"),
                                                  ),
                                                ],
                                              ),
                                            );
                                            return;
                                          }
                                          _fetchFinalReport();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade100,
                                          foregroundColor: Color(0xFF1B2559),
                                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: Color(0xFF1B2559),
                                            ),
                                          ),
                                        ),
                                        child: Text('최종 보고서 보러가기', style: TextStyle(fontSize: 16, ),),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_questionIndex % 3 == 0 && !_showFinishedPopup) {
                                          setState(() {
                                            _showFinishedPopup = true;
                                          });

                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text("최종 보고서"),
                                              content: Text("질문이 모두 끝났습니다. 최종 보고서를 확인하세요."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("확인"),
                                                ),
                                              ],
                                            ),
                                          );

                                          return; // ❗ 팝업 띄우고 다음 질문 안 넘어가게 막기
                                        }

                                        // ✅ 최종 답변이 비어있으면 다음 질문 막기
                                        if (!_isFinalAnswerSubmitted) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text("답변 필요"),
                                              content: Text("최종 답변을 작성한 후 제출 버튼을 눌러주세요."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  child: Text("확인"),
                                                ),
                                              ],
                                            ),
                                          );
                                          return;
                                        }

                                        _generateQuestion(); // ✅ 질문 생성 실행
                                        if (_questionIndex % 3 == 1) {
                                          setState(() {
                                            _showFinishedPopup = false;
                                          });
                                        }

                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF1B2559),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.all(20),
                                        shape: CircleBorder(),
                                      ),
                                      child: Icon(Icons.arrow_forward),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
          if (_showOverlay) _buildOverlay(SW, SH),
        ],
      ),
    );
  }
}


class ChatInputBar extends StatefulWidget {
  final Function(String) onSend;

  const ChatInputBar({Key? key, required this.onSend}) : super(key: key);

  @override
  _ChatInputBarState createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF6A90B7), width: 1),
        borderRadius: BorderRadius.circular(40),
        color: Colors.white.withOpacity(0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode, //
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: '무엇이든 물어보세요',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Color(0xFF6A90B7)),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}