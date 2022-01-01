import 'package:flutter/material.dart';
import 'package:taxdocs/Main/Pages/scan_page.dart';

class EmptyDocs extends StatelessWidget {
  const EmptyDocs({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> const ScanPage())),
        child: Image.asset('assets/img/empty.png', height: size.height * 0.25,));
  }
}