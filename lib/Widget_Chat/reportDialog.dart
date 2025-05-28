import 'package:commit_me/Widget_Chat/feedback_len.dart';
import 'package:flutter/material.dart';
import 'package:commit_me/design/color_system.dart';
import 'package:commit_me/Widget_Chat/role_type.dart';
import 'package:commit_me/Widget_Chat/feedback_type.dart';

class ReportDialog extends StatelessWidget {
  final String report; // ✅ 최종 보고서 전체 문자열

  const ReportDialog({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    // 보고서 문자열을 파싱
    final sections = _parseReport(report);

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(
        child: Text('전체 종합 레포트', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      content: SizedBox(
        width: 500,
        height: MediaQuery.of(context).size.height * 0.6, // ✅ 다이얼로그 높이 제한 (스크롤 가능)
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle('언어적 표현'),
              sectionText(sections['언어적 표현'] ?? ''),
              sectionTitle('취약 부분'),
              sectionText(sections['취약 부분'] ?? ''),
              sectionTitle('개선 방향'),
              sectionText(sections['개선해야 할 점'] ?? ''),
              sectionTitle('학습 추이'),
              sectionText(sections['답변의 종합적인 퀄리티로 보는 면접 대비 정도 추이'] ?? ''),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 35),
          decoration: BoxDecoration(
            color: AppColors.DarkBlue,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text('닫기', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  Map<String, String> _parseReport(String report) {
    final sections = <String, String>{};
    final regex = RegExp(r'(\d+\.\s*)([^\n]+)');
    final matches = regex.allMatches(report);

    for (int i = 0; i < matches.length; i++) {
      final title = matches.elementAt(i).group(2)?.trim() ?? '';
      final start = matches.elementAt(i).end;
      final end = i + 1 < matches.length ? matches.elementAt(i + 1).start : report.length;
      final content = report.substring(start, end).trim();
      sections[title] = content;
    }

    return sections;
  }

  Widget sectionTitle(String title) => Container(
    margin: const EdgeInsets.only(top: 12.0, bottom: 6.0),
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
    decoration: BoxDecoration(color: Color(0xFFF4EEC2), borderRadius: BorderRadius.circular(12.0)),
    child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  );

  Widget sectionText(String content) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(content),
  );
}
