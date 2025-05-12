import 'package:commit_me/Widget_Chat/feedback_len.dart';
import 'package:flutter/material.dart';
import 'package:commit_me/color_system.dart';
import 'package:commit_me/Widget_Chat/role_type.dart';
import 'package:commit_me/Widget_Chat/feedback_type.dart';

class ChatSetting extends StatefulWidget {

  @override
  State<ChatSetting> createState() => _ChatSettingState();
}

class _ChatSettingState extends State<ChatSetting> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backBlue,
      child: Padding(
        padding: const EdgeInsets.only(left: 100, top: 40, bottom: 60, right: 60),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: 230,
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
                child: RoleType(),
              ),
            ),
            SizedBox(height: 30,),
            Container(
                height: 210,
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
            SizedBox(height: 30,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 170,
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
                SizedBox(width: 22,),
                ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150,50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
