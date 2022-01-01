import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerItem extends StatelessWidget {

  final String icon;
  final String text;
  final bool? last;
  final Widget? screen;
  final bool? logout;
  final bool? help;
  const DrawerItem({Key? key, required this.icon, required this.text, this.last, this.screen, this.logout, this.help}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<appState>(context, listen: false);
    void _launchUrl() async {
      final url = Uri.parse("mailto:${app.settings.contactEmail!}?subject=Client%20Support");
      if (!await launchUrl(url)) throw 'Could not launch $url';
    }
    return Column(
      children: [
        const SizedBox(height: 3,),
        ListTile(
          onTap: (){
            if(screen != null && logout == null){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> screen!));
            }else if(logout != null){
                app.logout(context);
            }
            else if(help != null){
              _launchUrl();
            }
          },
          leading: Image.asset(icon, width: 30, height: 30,),
          title:  Text(text, style: textStyle.copyWith(color: blue),),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0.0),
        ),
        const SizedBox(height: 3,),

        if(last == null)
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset("assets/img/line.png"),
        )
      ],
    );
  }
}
