import 'dart:io';

import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:taxdocs/Main/Components/nav_item.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';

class Reorder extends StatefulWidget {
  final size;
  const Reorder({Key? key, this.size}) : super(key: key);

  @override
  State<Reorder> createState() => _ReorderState();
}

class _ReorderState extends State<Reorder> {
  int variableSet = 0;
  final ScrollController _scrollController = ScrollController();
  double? width;
  double? height;


  @override
  Widget build(BuildContext context) {
    final app = Provider.of<appState>(context, listen: true);
    final appbar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Reorder", style: textStyle.copyWith(fontSize: 18),),
          TextButton(onPressed: (){
            app.changeEditPage(MyPage.done);
          }, child: const Text("Done", style: textStyle,))
        ],
      ),

      // automaticallyImplyLeading: true,
      leading: IconButton(onPressed: (){
        app.changeEditPage(MyPage.done);
      }, icon: const Icon(Icons.arrow_back_ios, color: Colors.white,)),
      centerTitle: false,
    );
    return Scaffold(
      backgroundColor:  backgroundBlue,
      appBar: appbar,
      body: SafeArea(
          child: SizedBox(
              height: widget.size.height - appbar.preferredSize.height -  widget.size.height * 0.14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(),
                  Expanded(
                    child: DragAndDropGridView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2/2.9,
                      ),
                      // padding: const EdgeInsets.all(5),
                      itemBuilder: (context, index) => Card(
                        elevation: 2,
                        child: LayoutBuilder(
                          builder: (context, costrains) {
                            if (variableSet == 0) {
                              height = costrains.maxHeight;
                              width = costrains.maxWidth;
                              variableSet++;
                            }
                            return GridTile(
                              child: Image.file(
                                File(app.scannedImages[index]),
                                fit: BoxFit.fill,
                                height: height,
                                width: width,
                              ),
                            );
                          },
                        ),
                      ),
                      itemCount: app.scannedImages.length,
                      onWillAccept: (oldIndex, newIndex) {
                        // Implement you own logic
                                  
                        // Example reject the reorder if the moving item's value is something specific
                                  
                        return true; // If you want to accept the child return true or else return false
                      },
                      onReorder: (oldIndex, newIndex) {
                        app.reorderImages(oldIndex: oldIndex, newIndex: newIndex);
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text("Long press to move page", style: textStyle,),
                  )
                ],
              )
          )
      ),
      bottomNavigationBar: Container(
        height: widget.size.height * 0.14,
        color: const Color.fromRGBO(245, 248, 253, 1),
        child: Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  onTap: ()=>app.changeEditPage(MyPage.done),
                  child: NavCircleWidget(outerheight:widget.size.height * 0.04, innerheight:widget.size.height * 0.028, middleheight:widget.size.height * 0.0355, icon: "assets/img/check.png", screen: null,)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(String url){
    return GridTile(
      child: Image.file(
        File(url),
        fit: BoxFit.fill,
        height: height,
        width: width,
      ),
    );
  }

}


// app.reorderImages(oldIndex: oldIndex, newIndex: newIndex);


// DragAndDropGridView(
//                         controller: _scrollController,
//                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           childAspectRatio: 2/2.9,
//                         ),
//                         // padding: const EdgeInsets.all(5),
//                         itemBuilder: (context, index) => Card(
//                           elevation: 2,
//                           child: LayoutBuilder(
//                             builder: (context, costrains) {
//                               if (variableSet == 0) {
//                                 height = costrains.maxHeight;
//                                 width = costrains.maxWidth;
//                                 variableSet++;
//                               }
//                               return GridTile(
//                                 child: Image.file(
//                                   File(app.scannedImages[index]),
//                                   fit: BoxFit.fill,
//                                   height: height,
//                                   width: width,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         itemCount: app.scannedImages.length,
//                         onWillAccept: (oldIndex, newIndex) {
//                           // Implement you own logic

//                           // Example reject the reorder if the moving item's value is something specific

//                           return true; // If you want to accept the child return true or else return false
//                         },
//                         onReorder: (oldIndex, newIndex) {
//                           app.reorderImages(oldIndex: oldIndex, newIndex: newIndex);
//                         },
//                       ),



