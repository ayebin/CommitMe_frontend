import 'package:flutter/material.dart';
import 'package:commit_me/design/color_system.dart';

class FeedbackType extends StatefulWidget {

  @override
  State<FeedbackType> createState() => _FeedbackTypeState();
}

class _FeedbackTypeState extends State<FeedbackType> {
  bool isSelectedDefault = true; // "선택안함" 초기 선택
  bool isSelectedEmpathy = false; // "공감"
  bool isSelectedSolution = false; // "해결"

  void selectButton(String buttonType) {
    setState(() {
      if (buttonType == "default") {
        isSelectedDefault = true;
        isSelectedEmpathy = false;
        isSelectedSolution = false;
      } else if (buttonType == "empathy") {
        isSelectedDefault = false;
        isSelectedEmpathy = true;
        isSelectedSolution = false;
      } else if (buttonType == "solution") {
        isSelectedDefault = false;
        isSelectedEmpathy = false;
        isSelectedSolution = true;
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
          Text("피드백 답변 유형", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
          SizedBox(height: 15,),

          // "선택안함" 버튼
          Row(
            children: [
              ElevatedButton(
                onPressed: () => selectButton("default"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(120,120),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelectedDefault ? Colors.transparent : AppColors.backBlue,
                      width: 1,
                    ),
                  ),
                  backgroundColor: isSelectedDefault ? AppColors.DarkBlue : Colors.white,
                ),
                child: Text(
                  '균현 잡힌\n   답변',
                  style: TextStyle(
                      color: isSelectedDefault ? Colors.white : Colors.black,
                      fontWeight: isSelectedDefault ? FontWeight.bold : FontWeight.w500
                  ),
                ),
              ),
              SizedBox(width: 10,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "공감" 버튼
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => selectButton("empathy"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelectedEmpathy ? Colors.transparent : AppColors.backBlue,
                              width: 1,
                            ),
                          ),
                          backgroundColor: isSelectedEmpathy ? AppColors.DarkBlue : Colors.white,
                        ),
                        child: Text(
                          '차분한 답변',
                          style: TextStyle(
                              color: isSelectedEmpathy ? Colors.white : Colors.black,
                              fontWeight: isSelectedEmpathy ? FontWeight.bold : FontWeight.w500
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Text("정형적이고 사실적인 답변, 신중하게 답변할 수 있는 스타일",
                        style: TextStyle(fontSize:13, color: isSelectedEmpathy ? AppColors.DarkBlue: Colors.grey),)
                    ],
                  ),
                  SizedBox(height: 15,),



                  // "해결" 버튼
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => selectButton("solution"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelectedSolution ? Colors.transparent : AppColors.backBlue,
                              width: 1,
                            ),
                          ),
                          backgroundColor: isSelectedSolution ? AppColors.DarkBlue : Colors.white,
                        ),
                        child: Text(
                          '적극적인 답변',
                          style: TextStyle(
                              color: isSelectedSolution ? Colors.white : Colors.black,
                              fontWeight: isSelectedSolution ? FontWeight.bold : FontWeight.w500
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Text("더 창의적이고 역동적인 답변, 자신감 있는 답변 스타일" ,
                        style: TextStyle(fontSize:13, color: isSelectedSolution ? AppColors.DarkBlue: Colors.grey),)
                    ],
                  ),
                ],
              ),
            ],
          ),



        ],
      ),
    );
  }
}