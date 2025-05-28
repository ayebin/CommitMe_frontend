import 'package:flutter/material.dart';
import 'package:commit_me/design/color_system.dart';


class FeedbackLength extends StatefulWidget {
  @override
  State<FeedbackLength> createState() => _FeedbackLengthState();
}

class _FeedbackLengthState extends State<FeedbackLength> {
  bool isDefault = true; // "선택안함" 초기 선택
  bool isSimple = false; // "간결한 답변"
  bool isDetail = false; // "상세한 답변"

  void selectButton(String buttonType) {
    setState(() {
      if (buttonType == "len_default") {
        isDefault = true;
        isSimple = false;
        isDetail = false;
      } else if (buttonType == "simple") {
        isDefault = false;
        isSimple = true;
        isDetail = false;
      } else if (buttonType == "detail") {
        isDefault = false;
        isSimple = false;
        isDetail = true;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("피드백 답변 길이", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10,),


        Row(
          children: [
            // "기본" 버튼
            ElevatedButton(
              onPressed: () => selectButton("len_default"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(40, 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isDefault ? Colors.transparent : AppColors.backBlue,
                    width: 1,
                  ),
                ),
                backgroundColor: isDefault ? AppColors.DarkBlue : Colors.white,
              ),
              child: Text(
                '기본',
                style: TextStyle(
                    color: isDefault ? Colors.white : Colors.black,
                    fontWeight: isDefault ? FontWeight.bold : FontWeight.w500
                ),
              ),
            ),
            SizedBox(width: 10,),

            // "심플답변" 버튼
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => selectButton("simple"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSimple ? Colors.transparent : AppColors.backBlue,
                            width: 1,
                          ),
                        ),
                        backgroundColor: isSimple ? AppColors.DarkBlue : Colors.white,
                      ),
                      child: Text(
                        '간결',
                        style: TextStyle(
                            color: isSimple ? Colors.white : Colors.black,
                            fontWeight: isSimple ? FontWeight.bold : FontWeight.w500
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(
                      '짧고 핵심적인 답변',
                      style: TextStyle(fontSize:12, color: isSimple ? AppColors.DarkBlue: Colors.grey),
                    ),
                  ],
                ),

                SizedBox(height: 10,),

                // "상세답변" 버튼
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => selectButton("detail"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isDetail ? Colors.transparent : AppColors.backBlue,
                            width: 1,
                          ),
                        ),
                        backgroundColor: isDetail ? AppColors.DarkBlue : Colors.white,
                      ),
                      child: Text(
                        '상세',
                        style: TextStyle(
                            color: isDetail ? Colors.white : Colors.black,
                            fontWeight: isDetail ? FontWeight.bold : FontWeight.w500
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(
                      '구체적인 사례나 설명을 붙여 답변',
                      style: TextStyle(fontSize:12, color: isDetail ? AppColors.DarkBlue: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}