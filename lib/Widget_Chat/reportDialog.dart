import 'package:commit_me/Widget_Chat/feedback_len.dart';
import 'package:flutter/material.dart';
import 'package:commit_me/color_system.dart';
import 'package:commit_me/Widget_Chat/role_type.dart';
import 'package:commit_me/Widget_Chat/feedback_type.dart';

class ReportDialog extends StatefulWidget {
  const ReportDialog({super.key});

  @override
  State<ReportDialog> createState() => _ComprehensiveReportDialogState();
}

class _ComprehensiveReportDialogState extends State<ReportDialog> {
  late String languageExpression;
  late String weakPoints;
  late String improvement;
  late String progress;

  @override
  void initState() {
    super.initState();
    languageExpression = '당신은 주로 부드럽고 공감적인 언어를 사용하고 있어요. 감정 표현이 솔직하고 풍부합니다.';
    weakPoints = '슬픔이나 외로움과 같은 부정적인 감정을 자주 표현하고 있어요. 반복되는 단어 사용도 확인되었습니다.';
    improvement = '긍정적인 경험을 회상하거나 감사한 점을 기록하는 습관을 가져보세요. 문장을 다양하게 바꾸는 연습도 도움이 됩니다.';
    progress = '최근 감정 표현의 폭이 넓어지고 있으며, 점점 더 구체적인 언어를 사용하는 경향이 나타나고 있어요.';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          '전체 종합 레포트',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle('언어적 표현'),
            sectionText(languageExpression),
            sectionTitle('취약 부분'),
            sectionText(weakPoints),
            sectionTitle('개선 방향'),
            sectionText(improvement),
            sectionTitle('학습 추이'),
            sectionText(progress),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center, // 버튼 가운데 정렬
      actions: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 35),
          decoration: BoxDecoration(
            color: AppColors.DarkBlue, // 파란색 배경
            borderRadius: BorderRadius.circular(30), // 둥근 모서리
          ),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                '닫기',
                style: TextStyle(color: Colors.white), // 텍스트 흰색
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget sectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0, bottom: 6.0),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Color(0xFFF4EEC2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }


  Widget sectionText(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(content),
    );
  }
}
