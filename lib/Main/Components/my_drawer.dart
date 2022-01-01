import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Components/logo_widget.dart';
import 'package:taxdocs/Main/Components/drawer_item.dart';
import 'package:taxdocs/Main/Pages/archive.dart';
import 'package:taxdocs/Main/Pages/profile.dart';
import 'package:taxdocs/Main/Pages/received_docs.dart';
import 'package:taxdocs/Main/Pages/saved_docs.dart';
import 'package:taxdocs/Main/Pages/sent_docs.dart';
import 'package:taxdocs/Main/Pages/tnc_page.dart';
import 'package:taxdocs/constant.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(children: [
        const SizedBox(height: 60,),
        LogoWidget(size: size,),
        const SizedBox(height: 10,),
        Expanded(child: SingleChildScrollView(
          child: Column(
            children:  [
              const DrawerItem(text: "Profile", icon: "assets/img/profile.png",screen: Profile(),),
              const DrawerItem(text: "My Scans", icon: "assets/img/scans.png", screen: SavedDoc(),),
              const DrawerItem(text: "Sent Documents", icon: "assets/img/sent.png",screen: SentDocs(),),
              const DrawerItem(text: "Received Documents", icon: "assets/img/received.png",screen: ReceivedDocs(),),
              const DrawerItem(text: "My Archives", icon: "assets/img/archive.png",last: true,screen: ArchivePage(),),

              SizedBox(height: size.height > 900 ? 39: size.height * 0.043,),

              Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("More", style: textStyle.copyWith(color: blue),)),
              ),
              const SizedBox(height: 16),

              const DrawerItem(text: "Help", icon: "assets/img/help.png", help: true,),
              const DrawerItem(text: "Terms & Conditions", icon: "assets/img/tnc.png", screen: TnCPage(),),
              const DrawerItem(text: "Logout", icon: "assets/img/logout.png",logout: true,),

            ],
          ),
        ))
      ],),
    );
  }
}
