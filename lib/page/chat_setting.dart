import 'package:commit_me/Widget_Chat/feedback_len.dart';
import 'package:flutter/material.dart';
import 'package:commit_me/design/color_system.dart';
import 'package:commit_me/Widget_Chat/role_type.dart';
import 'package:commit_me/Widget_Chat/feedback_type.dart';
import 'package:provider/provider.dart';
import 'package:commit_me/chatwidgetProvider.dart';

class ChatSetting extends StatefulWidget {

  @override
  State<ChatSetting> createState() => _ChatSettingState();
}

class _ChatSettingState extends State<ChatSetting> {

  final TextEditingController roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backBlue,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: RoleType(controller: roleController),
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: FeedbackType()
            ),
            SizedBox(height: 20,),
            Container(
                padding: EdgeInsets.only(left: 15, bottom: 15, top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: FeedbackLength()
            ),

            Expanded(child: Container()),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final feedbackProvider = Provider.of<ChatWidgetProvider>(context, listen: false);
                  feedbackProvider.setRole(roleController.text);  // ✅ 여기서 roleController 바로 사용
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('설정이 적용되었습니다')),
                  );
                },

                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                      color: AppColors.DarkBlue,
                      width: 1,
                    ),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  '적용하기',
                  style: TextStyle(color: AppColors.DarkBlue, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}