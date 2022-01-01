import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taxdocs/constant.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final messageTextController = TextEditingController();
  final FirebaseAuth? _auth = FirebaseAuth.instance;
  String? messageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageTextController.dispose();
  }

  void getCurrentUser() async {
    try {
      final User? user = await _auth!.currentUser!;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: blue,
            ),
            const SizedBox(
              width: 14,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Administrator",
                    style: textStyle.copyWith(
                        color: orangeColor2,
                        fontSize: 24,
                        fontWeight: FontWeight.w700)),
                Text("Support",
                    style: textStyle.copyWith(
                        color: const Color.fromRGBO(145, 143, 183, 1),
                        fontSize: 14)),
              ],
            )
          ],
        ),
        centerTitle: false,
        actions: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back, color: blue,),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: chatGrey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    MessagesStream(),
                    Container(
                      color: Colors.transparent,
                      width: size.width * 0.9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    right: 10, left: 10, top: 5),
                                constraints: const BoxConstraints(
                                    minHeight: 0, maxHeight: 160),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: TextField(
                                  controller: messageTextController,
                                  onChanged: (value) {
                                    messageText = value;
                                  },
                                  maxLines: null,
                                  cursorColor: blue,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Write now...",
                                      hintStyle: textStyle.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: blue)),
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   width: 5,
                            // ),
                            InkWell(
                                onTap: () {
                                  messageTextController.clear();
                                  _firestore.collection('messages').add({
                                    'text': messageText,
                                    'sender': loggedInUser!.uid,
                                    'createdAt': DateTime.now(),
                                    'receiver': 'admin'
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.send,
                                    color: blue,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 26,)
                  ],
                ),
              ),

              //   Container(
              //     decoration: const BoxDecoration(
              //       color: chatGrey,
              //       borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(32),
              //         topRight: Radius.circular(32),
              //       ),
              //     ),
              //     child: Column(
              //       children: [
              //         Expanded(
              //           child: ListView.builder(
              //               padding: const EdgeInsets.only(
              //                   right: 20, left: 20, top: 20, bottom: 15),
              //               itemCount: 100,
              //               itemBuilder: (context, index) {
              //                 return index % 2 == 0
              //                     ? const SenderMessage()
              //                     : const ReceiverMessage();
              //               }),
              //         ),
              //         Container(
              //   color: Colors.transparent,
              //   width: size.width * 0.9,
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Container(
              //           padding: const EdgeInsets.only(right: 10, left: 10, top: 5),
              //           constraints:
              //               const BoxConstraints(minHeight: 0, maxHeight: 160),
              //           // width: size.width * 0.9,
              //           decoration: BoxDecoration(
              //               color: Colors.white, borderRadius: BorderRadius.circular(15)),
              //           child:  TextField(
              //             maxLines: null,
              //             decoration: InputDecoration(border: InputBorder.none, hintText: "Write now...", hintStyle: textStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: blue)),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(width: 20,),
              //       const Icon(Icons.send, color: blue,)
              //     ],
              //   ),
              // ), SizedBox(
              //   height: size.height * 0.03,
              // )
              //       ],
              //     ),
              //   ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('createdAt').snapshots(),
      builder: (context, snapshot) {
        // List<Map<String, dynamic>> a = snapshot.data!.docs.map((e) => e.data() as Map<String, dynamic>).toList();
        if (!snapshot.hasData) {
          print("Done Loading");
          return  Expanded(child: Center(child: Text("Start a chat", style: textStyle.copyWith(color: blue),)));
        }
        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        List<Map<String, dynamic>> messagesMaps = messages
            .map((message) => message.data() as Map<String, dynamic>)
            .toList()
            .where((element) =>
                element['sender'] == loggedInUser!.uid ||
                element['receiver'] == loggedInUser!.uid)
            .toList();

        for (var message in messagesMaps) {
          final currentUser = loggedInUser!.uid;
          final messageBubble = MessageBubble(
            sender: message['sender'],
            text: message['text'],
            isMe: currentUser == message['sender'],
            createdAt: message['createdAt'].toDate(),
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.sender,
      required this.text,
      required this.isMe,
      required this.createdAt});

  final String sender;
  final String text;
  final bool isMe;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(
                bottom: 12.0,
                right: size.width * 0.02,
                left: size.width * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(
                      minHeight: 20, minWidth: 80, maxWidth: size.width * 0.7),
                  decoration: BoxDecoration(
                      color: isMe ? orangeColor2 : Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    text,
                    style: isMe
                        ? textStyle.copyWith(fontWeight: FontWeight.w500)
                        : textStyle.copyWith(
                            fontWeight: FontWeight.w500, color: blue),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: isMe
                      ? const EdgeInsets.only(right: 5.0)
                      : const EdgeInsets.only(left: 5),
                  child: Text(
                    // DateFormat('yyyy-MM-dd').format(createdAt) + ":",
                    DateFormat.Hm().format(createdAt),
                    style: textStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: const Color.fromRGBO(145, 143, 183, 1)),
                  ),
                )
              ],
            )),
      ],
    );
  }
}
