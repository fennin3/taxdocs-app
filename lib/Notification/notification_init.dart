import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Main/Pages/messages.dart';
import 'package:taxdocs/Main/Pages/notifications.dart';
import 'package:taxdocs/Main/Pages/received_docs.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';
import 'package:taxdocs/main.dart';
import 'dart:io' show Platform;

import 'package:toast/toast.dart';

class MyNotification{
  final BuildContext context;
  final GlobalKey<NavigatorState> globalKey;

  MyNotification({required this.context, required this.globalKey});

  init(User? userCredential)async{
    await requestPermission(userCredential);
    initNotification();
  }

  static requestPermission(User? userCredential)async{
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    if (Platform.isIOS){
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      print('User granted permission: ${settings.authorizationStatus}');
    };

    firebaseMessaging.getToken().then((token)async{
      // print("Device Token ====  $token");
      final CollectionReference users =
      firebaseFirestore.collection("users");
      final data = {
        "registrationToken":token
      };
      if(userCredential != null ) {
        users.doc(userCredential.uid).update(data);
      }
    });
  }


  initNotification(){
    // FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onBackgroundMessage(_onMyBackground);
    FirebaseMessaging.onMessageOpenedApp.listen(_onResume);
    FirebaseMessaging.instance.getInitialMessage().then(_onLaunch);
    initMessaging();
  }

   Future<void> _onLaunch(RemoteMessage? message) async {
    if(message != null){
      final type = message.data['type'];
     if(type == 'documents'){
       navigatorKey.currentState!.pushNamed('/receivedDocs');
     }
     else if(type == "message"){
       navigatorKey.currentState!.pushNamed('/message');
     }else if(type == "notification"){
       navigatorKey.currentState!.pushNamed('/notification');
     }
    }
     
  }

  Future<void> _onResume(RemoteMessage message) async {
    print("************** On Resume 1");
    final app = Provider.of<appState>(context, listen: false);
    final type = message.data['type'];

      if(type == 'documents'){
        navigatorKey.currentState!.pushNamed('/receivedDocs');
      }
      else if (type == 'message'){
        navigatorKey.currentState!.pushNamed('/message');
      }
      else if (type == 'notification'){
        navigatorKey.currentState!.pushNamed('/notification');
      }else{
        print("************** On Resume 3");
      }
  }

  Future<void> _onMessage(RemoteMessage message) async {
    print("**********************Message");
    final String type = message.data['type'];
      showSimpleNotification(
          Text(message.notification!.title!, style: const TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.center,),
          background: orangeColor2,
          duration: const Duration(seconds: 5),
          elevation: 5,
        slideDismiss: true,
      );
  }

  Future<void> _onMyBackground(RemoteMessage message) async {
    print("**********************Background");
    final app = Provider.of<appState>(context, listen: false);
    // final type = message.data['type'];
    // if(type == 'documents'){
    //   app.fetchReceivedDocs();
    //   Navigator.push(context, MaterialPageRoute(builder: (context)=> const ReceivedDocs()));
    // }
    // else if (type == 'message'){
    //   Navigator.push(context, MaterialPageRoute(builder: (context)=> const Message()));
    // }
    // else if (type == 'notification'){
    //   app.fetchNotication();
    //   Navigator.push(context, MaterialPageRoute(builder: (context)=> const NotificationPage()));
    // }
  }


  void initMessaging() {
    var androiInit = const AndroidInitializationSettings('@mipmap/ic_launcher');//for logo
    var iosInit = const IOSInitializationSettings();
    var initSetting=InitializationSettings(android: androiInit,iOS:
    iosInit);
    FlutterLocalNotificationsPlugin fltNotification = FlutterLocalNotificationsPlugin();
//fltNotification.initialize(initSetting);
    fltNotification.initialize(initSetting,onSelectNotification: (String? type)async{
      if(type == 'documents'){
        navigatorKey.currentState!.pushNamed('/receivedDocs');
      }
      else if (type == 'message'){
        navigatorKey.currentState!.pushNamed('/message');
      }
      else if (type == 'notification'){
        navigatorKey.currentState!.pushNamed('/notification');
      }
      else{
        print("************** On Resume 3");
      }
    });
    var androidDetails =
    const AndroidNotificationDetails('1', 'channelName', importance: Importance.high);
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {     RemoteNotification? notification=message.notification;
    AndroidNotification? android=message.notification?.android;
    if(notification!=null && android!=null){
      fltNotification.show(
          notification.hashCode, notification.title, notification.body, generalNotificationDetails,payload: message.data['type']);
    }
    });
  }
}
//message.data["gcm.notification.chat_message"]

