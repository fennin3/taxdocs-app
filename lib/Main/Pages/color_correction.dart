import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';


class ColorCorrection extends StatelessWidget {
  const ColorCorrection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final app = Provider.of<appState>(context);
    final appbar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Color correction", style: textStyle.copyWith(fontSize: 18),),
          TextButton(onPressed: (){}, child: const Text("Done", style: textStyle,))
        ],
      ),

      // automaticallyImplyLeading: true,
      leading: IconButton(onPressed: (){
        app.changeEditPage(MyPage.done);
      }, icon: const Icon(Icons.arrow_back_ios)),
      centerTitle: false,
    );
    return Scaffold(
      backgroundColor:  backgroundBlue,
      appBar: appbar,
      body: SafeArea(
          child: SizedBox(
            height: size.height - appbar.preferredSize.height -  size.height * 0.14,
            child: Center(
              child: Container(
                width: size.width * 0.85,
                height: (size.height - appbar.preferredSize.height -  size.height * 0.14) * 0.8,
                // color: Colors.white,
                child: Image.file(File(app.scannedImages[0]),fit: BoxFit.contain,),
              ),
            ),
          )
      ),
      bottomNavigationBar: Container(
        height: size.height * 0.14,
        color: const Color.fromRGBO(245, 248, 253, 1),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 30,),
                for(var i in [1,2,3,4,5,6,7])
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Container(
                      height: size.height * 0.07,
                      width: size.height * 0.064,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color.fromRGBO(225, 232, 246, 1))
                      ),
                    ),
                  ),

                const SizedBox(width: 30,),

              ],
            ),
          ),
        )
      ),
    );
  }
}


