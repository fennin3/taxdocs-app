import 'package:flutter/material.dart';

class SendWidget extends StatelessWidget {
  const SendWidget({
    Key? key,
    required this.send,
  }) : super(key: key);

  final bool? send;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(send != null)
          Image.asset("assets/img/share.png", width: 20, height: 20,),
        if(send != null)
          const SizedBox(width: 8,),
        if(send != null)
          const Text("Send", style: TextStyle(color: Color.fromRGBO(248, 148, 62, 1)),),
      ],
    );
  }
}