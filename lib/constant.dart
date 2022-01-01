import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';

 final orangeColor = HexColor('#F8943E');
 const orangeColor2 = Color.fromRGBO(248, 148, 62, 1);

 const greyColor = Color.fromRGBO(169, 169, 169, 0.4);

 const greyColor2 = Color.fromRGBO(245, 248, 253, 1);

 const backArrowColor = Color.fromRGBO(156, 165, 186, 1);

 const Color blue = Color.fromRGBO(19, 34, 57, 1);

 const Color backgroundBlue = Color.fromRGBO(19, 34, 57, 1);

 const Color chatGrey = Color.fromRGBO(245, 246, 250, 1);

 const Color textBlue = Color.fromRGBO(5, 30, 86, 1);

 const blue14Style = TextStyle(fontSize: 14, color: textBlue, fontWeight: FontWeight.w500);

 const grey12Style = TextStyle(fontSize: 12, color: Color.fromRGBO(156, 165, 186, 1), fontWeight: FontWeight.w400);

 const textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);

 const spinWidget = SpinKitDoubleBounce(
  color: blue,
  size: 40,
 );

 Widget spinWidget2(String? total, String? downloaded){
  // print("Downloaded --- $downloaded");
  double downloadProgress = 0;
  if(total != '0') {
    downloadProgress = (int.parse(downloaded!)/ int.parse(total!)) * 100;
    if (downloadProgress > 100){
      downloadProgress = 100.0;
    }
  }
  return downloaded == null ? const SpinKitDoubleBounce(
  color: blue,
  size: 40,
  ): Align(
    alignment: Alignment.center,
    child: Container(
      width: 150,
      height: 150,
      color: Colors.white,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          const SpinKitPouringHourGlassRefined(color: blue, size: 40,),
          const SizedBox(height: 4,),
          Text("Downloading ${downloadProgress.toStringAsFixed(0)}%", style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)
      ],
      ),
    ),
  );
 }
const stripePublishableKey = "pk_test_QfiXIJ9KHc8qsJL4h2NySQWr008LUCCkQN";
const stripeSecretKey = "sk_test_51FG1qtJKmoYMQAqcuFHcGv7aoBgIhYUBgmb9sBD35SJZCQypOEFQ4BbiU5aYVu9GnvgjqgVDF71SsWVxXSrSfelV00sFFCKeKe";

 const apiTokenKey = "x-tax-token";

 const String scannedImagesFolder = "scannedImages";
 const String savedDocsFolder = "savedDocs";

 // Variables
 const baseUrl = "https://taxbackend.herokuapp.com/";
 final FirebaseAuth auth = FirebaseAuth.instance;



 // Other Constants
const kSendButtonTextStyle = TextStyle(
 color: Colors.lightBlueAccent,
 fontWeight: FontWeight.bold,
 fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
 contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
 hintText: 'Type your message here...',
 border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
 border: Border(
  top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
 ),
);

const kTextFieldDecoration = InputDecoration(
 hintText: 'Enter a value',
 contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
 border: OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(32.0)),
 ),
 enabledBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
  borderRadius: BorderRadius.all(Radius.circular(32.0)),
 ),
 focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
  borderRadius: BorderRadius.all(Radius.circular(32.0)),
 ),
);


