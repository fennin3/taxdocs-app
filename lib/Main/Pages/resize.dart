import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Main/Components/edit_item.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';


class Resize extends StatelessWidget {
  const Resize({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final app = Provider.of<appState>(context);
    final appbar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Resize", style: textStyle.copyWith(fontSize: 18),),
          TextButton(onPressed: (){}, child: const Text("Done", style: textStyle,))
        ],
      ),

      // automaticallyImplyLeading: true,
      leading: IconButton(onPressed: (){
        app.changeEditPage(MyPage.done);
      }, icon: const Icon(Icons.arrow_back_ios)),
      centerTitle: false,
    );
    return Scaffold(
      backgroundColor:  backgroundBlue,
      appBar: appbar,
      body: SafeArea(
          child: SizedBox(
            height: size.height - appbar.preferredSize.height -  size.height * 0.14,
            child: Center(
              child: Container(
                width: size.width * 0.85,
                height: (size.height - appbar.preferredSize.height -  size.height * 0.14) * 0.8,
                color: Colors.white,
              ),
            ),
          )
      ),
      bottomNavigationBar: Container(
        height: size.height * 0.14,
        color: const Color.fromRGBO(245, 248, 253, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            EditPageItem(size: size, image: "assets/img/auto2.png", title: "Auto",),
            EditPageItem(size: size, image: "assets/img/A5.png", title: "A5",),
            EditPageItem(size: size, image: "assets/img/A4.png", title: "A4",),
            EditPageItem(size: size, image: "assets/img/A4.png", title: "A3",),
          ],
        ),
      ),
    );
  }
}
