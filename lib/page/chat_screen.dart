import 'package:commit_me/Widget_Chat/reportDialog.dart';
import 'package:flutter/material.dart';
import 'package:commit_me/design/color_system.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
        _messages.add({'message': message, 'sender': 'me'});
      });

      // 5초 뒤에 자동으로 상대방 메시지를 추가
      Future.delayed(Duration(seconds: 3), () {
        _handleTestMessage();
      });
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
      _messages.add({'message': otherMessage, 'sender': 'other'});
      otherMessageCount++; // 메시지 카운트 증가
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(right: 65, bottom: 20),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 55,),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _messages.map((messageData) {
                    final message = messageData['message']!;
                    final sender = messageData['sender']!;


                    return Row(
                      mainAxisAlignment: sender == 'me' ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (sender == 'other') ...[
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
                                  child: Icon(Icons.token_outlined, color: AppColors.highBlue),
                                  radius: 20,
                                  backgroundColor: Colors.white
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                        Column(
                          crossAxisAlignment: sender == 'me' ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 500,
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: sender == 'me' ? Color(0xFF689ADB) : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Color(0xFF627A98),
                                ),
                              ),
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: sender == 'me' ? Colors.white : Color(0xFF1B2559),
                                  fontSize: 16,
                                ),
                                softWrap: true,
                              ),
                            ),
                            SizedBox(height: 30,)   //채팅간격
                          ],
                        ),
                        if (sender == 'me') ...[
                          SizedBox(width: 23),
                        ],
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _messages.add({
                          'message': '다음 질문을 받고 싶어요',
                          'sender': 'me',
                        });
                      });

                      // 자동 응답도 받고 싶다면 이 부분도 추가
                      Future.delayed(Duration(seconds: 2), () {
                        _handleTestMessage(); // 다음 응답 추가
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      margin: EdgeInsets.only(right: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFC9DDED),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text('다음 질문을 받고 싶어요'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ReportDialog(),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      margin: EdgeInsets.only(right: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFC9DDED),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text('전체적인 종합 레포트를 받고 싶어요'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            ChatInputBar(
              onSend: _handleSendMessage,
            ),
            // ChatInputBar(
            //   onSend: _handleTestMessage,
            // ),
            SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }
}



class ChatInputBar extends StatelessWidget {
  final Function(String) onSend;

  const ChatInputBar({Key? key, required this.onSend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF6A90B7), width: 1),
          borderRadius: BorderRadius.circular(40),
          color: Colors.white.withOpacity(0.5)
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: '무엇이든 물어보세요', border: InputBorder.none),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Color(0xFF6A90B7),),
            onPressed: () {
              onSend(_controller.text);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}