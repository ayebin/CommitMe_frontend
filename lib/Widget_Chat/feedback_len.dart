import 'package:flutter/material.dart';
import 'package:commit_me/color_system.dart';


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
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("피드백 답변 길이", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
          SizedBox(height: 15,),


          Row(
            children: [
              // "기본" 버튼
              ElevatedButton(
                onPressed: () => selectButton("len_default"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(80,80),
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
              ElevatedButton(
                onPressed: () => selectButton("simple"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSimple ? Colors.transparent : AppColors.backBlue,
                      width: 1,
                    ),
                  ),
                  backgroundColor: isSimple ? AppColors.DarkBlue : Colors.white,
                ),
                child: Column(
                  children: [
                    Text(
                      '간결한 답변',
                      style: TextStyle(
                          color: isSimple ? Colors.white : Colors.black,
                          fontWeight: isSimple ? FontWeight.bold : FontWeight.w500
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text(
                      '짧고 핵심적인 답변',
                      style: TextStyle(fontSize:12, color: isSimple ? Colors.white: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10,),

              // "상세답변" 버튼
              ElevatedButton(
                onPressed: () => selectButton("detail"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isDetail ? Colors.transparent : AppColors.backBlue,
                      width: 1,
                    ),
                  ),
                  backgroundColor: isDetail ? AppColors.DarkBlue : Colors.white,
                ),
                child: Column(
                  children: [
                    Text(
                      '상세한 답변',
                      style: TextStyle(
                          color: isDetail ? Colors.white : Colors.black,
                          fontWeight: isDetail ? FontWeight.bold : FontWeight.w500
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text(
                      '구체적인 사례나 설명을 덧붙여서 답변',
                      style: TextStyle(fontSize:12, color: isDetail ? Colors.white: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
