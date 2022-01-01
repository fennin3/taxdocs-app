import 'package:flutter/material.dart';
import 'package:taxdocs/constant.dart';


class NavCircleWidget extends StatelessWidget {
  final double outerheight;
  final double innerheight;
  final double middleheight;
  final String icon;
  final Widget? screen;

  const NavCircleWidget({required this.innerheight, required this.outerheight, required this.middleheight, required this.icon, this.screen});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: const Color.fromRGBO(169, 169, 169, 0.1),
      radius: outerheight,
      child: CircleAvatar(radius: middleheight,
        backgroundColor: Colors.white,
        child: Container(
          child: CircleAvatar(
            radius: innerheight,
            backgroundColor: orangeColor2,
            child: Image.asset(icon, height: icon =="assets/img/Scan.png" ? 20: 14.5, width: icon =="assets/img/Scan.png" ? 20: 14.5,),
          ),
          decoration: const BoxDecoration(boxShadow: [BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 50,
            color: Color.fromRGBO(248, 148, 62, 0.5),
          )]),
        ),
      ),
    );
  }
}