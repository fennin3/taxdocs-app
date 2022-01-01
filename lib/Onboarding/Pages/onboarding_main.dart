import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxdocs/Components/logo_widget.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';

import '../constant.dart';
import 'onboarding1.dart';


class OnBoardingMain extends StatefulWidget {
  const OnBoardingMain({Key? key}) : super(key: key);

  @override
  State<OnBoardingMain> createState() => _OnBoardingMainState();
}

class _OnBoardingMainState extends State<OnBoardingMain> {
  int index = 0;
  final PageController _controller = PageController();

  void onNextTap()async{
    if(index<2){
      _controller.animateToPage(index + 1, duration:  const Duration(seconds: 2), curve: Curves.fastLinearToSlowEaseIn);
      index +=1;
    }else{
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool('installed', true);
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final app = Provider.of<appState>(context,listen: false);
    app.createFolder(scannedImagesFolder);
    app.createFolder(savedDocsFolder);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.018,),
            Hero(tag: "logo", child: LogoWidget(size: size),),
            Expanded(
              child: PageView(
                onPageChanged: (cIndex){
                  setState(() {
                    index = cIndex;
                  });
                },
                controller: _controller,
                children: const [

                  OnBoarding1(image: "assets/img/onboard1.png", title: "Simple way to scan", text: "Tax management just got easier. Scan and send your documents instantly.", btnText: "Next"),
                  OnBoarding1(image: "assets/img/onboard2.png", title: "Simple way to scan", text: "Tax management just got easier. Scan and send your documents instantly.", btnText: "Next"),
                  OnBoarding1(image: "assets/img/onboard3.png", title: "Simple way to scan", text: "Tax management just got easier. Scan and send your documents instantly.", btnText: "Next"),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0, right: 25, left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PageIndication(index: index),
                  InkWell(
                    onTap: ()=> onNextTap(),
                    child: Container(
                      width: 204,
                      height: 57,
                      decoration: BoxDecoration(color: orangeColor, borderRadius: BorderRadius.circular(29)),
                      child:  Center(child: Text( index == 2 ? "Get Started" :"Next", style: onBoardNext,),),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class PageIndication extends StatelessWidget {
  const PageIndication({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(children: [


      Container(height: 9, width: index == 0 ? 28 :9,
        decoration: BoxDecoration(color: index == 0 ? orangeColor : greyColor, borderRadius: BorderRadius.circular(9)),
      ),

      Padding(
        padding: const EdgeInsets.only(left:15.0),
        child: Container(height: 9, width: index == 1 ? 28 :9,
          decoration: BoxDecoration(color: index == 1 ? orangeColor : greyColor, borderRadius: BorderRadius.circular(9)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left:15.0),
        child: Container(height: 9, width: index == 2 ? 28 :9,
          decoration: BoxDecoration(color: index == 2 ? orangeColor : greyColor, borderRadius: BorderRadius.circular(9)),
        ),
      ),

    ],);
  }
}




