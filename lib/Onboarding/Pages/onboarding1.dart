import 'package:flutter/material.dart';
import '../constant.dart';



class OnBoarding1 extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  final String btnText;
  const OnBoarding1({Key? key, required this.btnText, required this.image, required this.text, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
          SizedBox(height: size.height * 0.04,),
        Align(
            alignment: Alignment.center,
            child: Container(
                width: 300,
                padding: const EdgeInsets.only(left: 20),
                child: Image.asset(image, width: 280, height: size.height * 0.36,))),

        SizedBox(height: size.height * 0.06,),

         Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 284,
            child: Text(title, style: onBoardTitle,),
          ),
        ),
        const SizedBox(height: 14,),
         Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 284,
            child: Text(text, style: onBoardText,),
          ),
        ),

        const Expanded(child: SizedBox()),
      ],
    );
  }
}
