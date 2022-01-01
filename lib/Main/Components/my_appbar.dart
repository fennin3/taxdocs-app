import 'package:flutter/material.dart';
import 'package:taxdocs/constant.dart';

PreferredSizeWidget myAppBar(String text){
  return AppBar(
    // automaticallyImplyLeading: false,
    // leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon( Platform.isIOS ? Icons.arrow_back_ios:Icons.arrow_back, color: backArrowColor,)),
    backgroundColor: Colors.white,
    iconTheme: const IconThemeData(color: backArrowColor),
    elevation: 0.0,
    centerTitle: false,
    title: Text(text, style: textStyle.copyWith(color: blue, fontSize: 18),),
  );
}