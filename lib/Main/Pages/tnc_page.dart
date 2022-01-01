import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';
import 'dart:io' show Platform;
import 'package:flutter_html/flutter_html.dart';


class TnCPage extends StatelessWidget {
  const TnCPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<appState>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon( Platform.isIOS ? Icons.arrow_back_ios:Icons.arrow_back, color: backArrowColor,)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: false,
        title: Text("Terms & Conditions", style: textStyle.copyWith(color: blue, fontSize: 18),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Html(data:app.settings.terms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
