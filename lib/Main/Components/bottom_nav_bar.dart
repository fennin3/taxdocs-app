import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Database/scan_model.dart';
import 'package:taxdocs/Main/Pages/landing_page.dart';
import 'package:taxdocs/Main/Pages/messages.dart';
import 'package:taxdocs/Main/Pages/saved_docs.dart';
import 'package:taxdocs/Main/Pages/scan_page.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'nav_item.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    Key? key,
    required this.size,
    this.home,
    required this.cont
  }) : super(key: key);

  final Size size;
  final bool? home;
  final BuildContext cont;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // final ImagePicker _picker = ImagePicker();
  final TextEditingController _note = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _note.text = "";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final app = Provider.of<appState>(context,listen: false);
    return Container(
      height: widget.size.height * 0.134,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: (){
              if(widget.home == null){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                const HomePage()), (Route<dynamic> route) => false);
              }
            },
            child: NavCircleWidget(
              outerheight: widget.size.height * 0.04,
              innerheight: widget.size.height * 0.028,
              middleheight: widget.size.height * 0.0355,
              icon: "assets/img/navhome.png",
              screen: null,
            ),
          ),
          InkWell(
            onTap: ()=> _imageModalSheet(),
            child: NavCircleWidget(
              outerheight: widget.size.height * 0.056,
              innerheight: widget.size.height * 0.043,
              middleheight: widget.size.height * 0.0517,
              icon: "assets/img/Scan.png",
              screen: const ScanPage(),
            ),
          ),
          InkWell(
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> const Message())),
            child: NavCircleWidget(
              outerheight: widget.size.height * 0.04,
              innerheight: widget.size.height * 0.028,
              middleheight: widget.size.height * 0.0355,
              icon: "assets/img/message.png",
              screen: null,
            ),
          ),
        ],
      ),
    );
  }

  // Future<XFile?> _pickImage(bool cam) async {
  //   final XFile? file = await _picker.pickImage(
  //       source: cam ? ImageSource.camera : ImageSource.gallery);
  //   Navigator.pop(context);
  //
  //   return file;
  // }

  void _imageModalSheet() {
    final app = Provider.of<appState>(context, listen: false);
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        // Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ScanPage()));
                      },
                      child: FittedBox(
                        child: Card(
                          color: orangeColor2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children:  [
                                Image.asset("assets/img/Scan.png", color: Colors.white, height: 20,),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  "Scan Document",
                                  style: textStyle,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   width: 5,
                    // ),
                    InkWell(
                      onTap: ()async{
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf']);
                        if(result != null) {
                          final path = result.files.single.path;
                          final filename = path!.split('/').last;
                          // print(filename);
                          Navigator.pop(context);
                          app.setLoaderOn();
                          final newPath = await app.getFilePath(type: 'pdf', name: filename);
                          app.resetFilename();

                          File(newPath).writeAsBytes(await File(path).readAsBytes());
                          app.savePdf(ScanModel(createdAt: DateTime.now(), pdf: newPath, title:filename,userId: app.userId!));
                          app.setLoaderOff();
                          app.showSnackBar(widget.cont, "Document has been saved", null);
                          Navigator.push(widget.cont, MaterialPageRoute(builder: (context)=> const SavedDoc()));
                          // _showNoteModal(result.files.single.path!);
                        }
                      },
                      child: FittedBox(
                        child: Card(
                          color: orangeColor2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children:  [
                                Image.asset("assets/img/import.png", color: Colors.white, height: 20,),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  "Import Document",
                                  style: textStyle,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  void _showNoteModal(String path) {
    final app = Provider.of<appState>(context, listen: false);

    showDialog(
        context: widget.cont,
        builder: (context) {
          return Dialog(
            child: Container(
              // height: 450,
              width: 327,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: Image.asset(
                                "assets/img/send_icon.png",
                                width: 280,
                                height: 280,
                              ),
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 230.0),
                            child: Text(
                              "Do you want to send this document?",
                              style: textStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: blue),
                            ),
                          ),
                        )
                      ],
                    ),
                    Text("Optional", style: textStyle.copyWith(color: blue, fontSize: 13),),
                    Container(
                        padding: const EdgeInsets.only(right: 10,left: 10, bottom: 10),
                        height: 170,
                        width: 260,
                        decoration: BoxDecoration(
                            border: Border.all(color: blue),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          maxLines: null,
                          controller: _note,
                          cursorColor: blue,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "You can add a note here..."),
                        )),

                    const SizedBox(height: 30,),
                    InkWell(
                      onTap: () => app.uploadPDF(path, _note.text, widget.cont),
                      child: Container(
                        height: 50,
                        width: 251,
                        decoration: BoxDecoration(
                            color: orangeColor2,
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Text(
                            "Send Now",
                            style:
                            textStyle.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: ()=>Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: textStyle.copyWith(color: orangeColor2),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

}
