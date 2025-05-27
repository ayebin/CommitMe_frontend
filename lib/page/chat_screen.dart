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
          _messages.add({'message': botMessage, 'sender': 'system'}); // ✅ sender = 챗봇
        });
      } else {
        print("백엔드 오류: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("에러 발생: $e");
    }
  }


  void _handleTestMessage() {
    String otherMessage;

    // 상대방 메시지를 카운트에 따라 다르게 설정
    if (otherMessageCount == 0) {
      otherMessage =
      "당신이 슬픔을 느끼고 있다는 것을 인지했습니다. 때로는 이런 감정이 우리가 직면한 문제들이 너무 커서 압도될 때 찾아오곤 합니다. 먼저, 당신의 감정을 인정하고 받아들이는 것이 중요합니다. 이제, 조금씩 문제를 해결해 나가기 위한 몇 가지 단계들을 제안드립니다:\n\n1. **문제 구체화**: 어떤 부분이 특히 당신을 슬프게 만드는지 구체적으로 생각해보세요. 감정이 아닌 문제를 명확히 하는 것이 중요합니다.\n\n2. **작은 목표 설정**: 한 번에 모든 문제를 해결하려고 하지 마세요. 작은 목표를 설정하고 하나씩 해결해 나가다 보면 차차 나아질 것입니다.\n\n3. **지원 요청**: 주변에 믿을 수 있는 친구나 가족, 혹은 전문가에게 도움을 요청하세요. 혼자서 모든 것을 감당하려고 하지 않아도 됩니다.\n\n4. **자기 돌봄**: 충분한 휴식과 잠, 그리고 건강한 식사가 중요합니다. 자신을 돌보는 것이 문제 해결의 첫걸음입니다.\n\n5. **긍정적인 활동**: 당신이 좋아하는 활동이나 취미를 찾고, 그것을 통해 잠시나마 마음의 안정을 찾아보세요.\n\n힘든 시간을 겪고 있는 당신에게 작은 도움이 되었길 바랍니다. 모든 문제는 해결할 수 있는 방법이 있습니다. 당신은 혼자가 아닙니다.";
    } else if (otherMessageCount == 1) {
      otherMessage =
      "지금 네 마음이 슬픔이라는 어두운 숲 속을 걷고 있는 것 같아 보여. 마치 마법의 숲에서 길을 잃은 용사처럼 말이야. 하지만 기억해, 그 숲 속에서도 언제나 빛나는 별이 있고, 네가 찾지 못했을 뿐인 마법의 힘이 숨어 있어. 네 마음 속 깊은 곳에는 강력한 마법이 깃들어 있고, 그 마법은 네가 다시 밝은 길을 찾도록 도와줄 거야. 네가 해낼 수 있어. 네 안의 용사와 마법을 믿어줘. 이 어두운 숲도 언젠가는 끝나고, 너는 더 강해져서 빛나는 들판으로 나아갈 거야.🌟";
    } else {
      otherMessage = "마음이 슬프고 무거운 날들이 마치 어두운 숲 속을 걷는 것처럼 느껴질 때가 있어. 그 숲에는 길을 잃고 헤매는 듯한 두려움과 외로움이 가득하지만, 그 안에는 반짝이는 작은 요정들이 숨어 있어. 이 요정들은 바로 네가 가진 강인한 용기와 희망이야.\n어두운 숲을 지나면 반드시 밝은 빛이 너를 기다리고 있어. 네가 지금 느끼는 슬픔은 마치 마법의 주문처럼 너를 더 강하게 만들고, 더 아름다운 세계로 이끌어 줄 거야. 네가 해낼 수 있어. 힘들 때마다 그 작은 요정들이 네 곁에서 빛나고 있다는 것을 기억해. 네 안에는 그 어떤 어둠도 이겨낼 수 있는 힘이 있다는 걸 잊지 마. \n\n혹시 도움이 필요하시면 [자살 예방 상담 전화(1393)], [정신 건강 상담 전화(1577-0199)]를 이용하실 수 있습니다. 전문가와의 상담은 큰 힘이 될 수 있습니다.";
    }


    setState(() {
      _messages.add({'message': otherMessage, 'sender': 'system'});
      otherMessageCount++; // 메시지 카운트 증가
    });
  }

  @override
  Widget build(BuildContext context) {
    double SW = MediaQuery.of(context).size.width;
    double SH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(left: 20, top: 25, bottom: 25, right: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          //border: Border.all(color: Colors.black),
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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF9C9C9C)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Q. Linked list가 무엇입니까?", style: TextStyle(fontSize: SH*0.025)),
                  Text("2/10", style: TextStyle(fontSize: SH*0.018, fontWeight: FontWeight.bold))
                ],
              ),
            ),


            Expanded(
              child: Row(
                children: [
                  //질의응답 챗구간
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: _messages.map((messageData) {
                                final message = messageData['message']!;
                                final sender = messageData['sender']!;


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
                                              backgroundColor: Colors.white
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
                                            maxWidth: MediaQuery.of(context).size.width * 0.6, // 최대 너비를 화면의 60%로 제한
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
                                        SizedBox(height: 15,)   //채팅간격
                                      ],
                                    ),
                                    if (sender == 'user') ...[
                                      SizedBox(width: 23),
                                    ],
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        ChatInputBar(
                          onSend: _handleSendMessage,
                        ),
                        // ChatInputBar(
                        //   onSend: _handleTestMessage,
                        // ),
                      ],
                    ),
                  ),

                  //피드백 구간
                  Expanded(
                    flex: 2,
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
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: '답변을 입력하세요',
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(borderSide: BorderSide.none,),
                                        //contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 100), // ← 높이 조절 포인트
                                      ),
                                      maxLines: null, // 여러 줄 입력 가능
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF1B2559),
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                          ),
                                          child: Text('제출', style: TextStyle(fontSize: 16),),
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
                                      decoration: BoxDecoration(color: Color(0xFFD5DDEC), border: Border(bottom: BorderSide(color: Color(0xFF9C9C9C)))),
                                      child: Text(
                                        '제출 버튼을 누르시면 피드백이 생성됩니다.',
                                        style: TextStyle(fontSize: 16, color: Colors.white,),
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
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 410,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade100,
                                      foregroundColor: Color(0xFF1B2559),
                                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: Color(0xFF1B2559), // 테두리 색상
                                        ),
                                      ),
                                    ),
                                    child: Text('최종 보고서 보러가기', style: TextStyle(fontSize: 16, ),),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF1B2559),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.all(20),
                                    shape: CircleBorder()
                                  ),
                                  child: Icon(Icons.arrow_forward)
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
