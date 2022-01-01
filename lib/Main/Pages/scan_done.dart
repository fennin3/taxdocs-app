import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Main/Pages/color_correction.dart';
import 'package:taxdocs/Main/Pages/done.dart';
import 'package:taxdocs/Main/Pages/reorder.dart';
import 'package:taxdocs/Main/Pages/resize.dart';
import 'package:taxdocs/Provider/app_state.dart';



class ScanComplete extends StatefulWidget {
  const ScanComplete({Key? key}) : super(key: key);

  @override
  _ScanCompleteState createState() => _ScanCompleteState();
}

class _ScanCompleteState extends State<ScanComplete> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final page = Provider.of<appState>(context).editPage;
    return page == MyPage.done ?

    Done(size: size) :

    page == MyPage.reorder ?  Reorder(size: size) :

    page == MyPage.resize ? const Resize() :

    page == MyPage.color ? const ColorCorrection() : Container();
  }
}







