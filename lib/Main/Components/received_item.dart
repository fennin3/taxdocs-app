import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Main/Pages/pdf_page.dart';
import 'package:taxdocs/Models/reeceived_doc.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';


class ReceivedItem extends StatefulWidget {
  final ReceivedDoc doc;
  final BuildContext context;
  final Function(String,String) onSign;
  final Function(String, String) onDownload;
  const ReceivedItem({Key? key, required this.doc, required this.context, required this.onSign, required this.onDownload}) : super(key: key);

  @override
  State<ReceivedItem> createState() => _ReceivedItemState();
}

class _ReceivedItemState extends State<ReceivedItem> {
  FirebaseStorage storage = FirebaseStorage.instance;
  String downloadLink = "";
  final ImagePicker _picker = ImagePicker();
  final ReceivePort _port = ReceivePort();
  String? filesize = '0';

  Future<void> downloadFirebaseFiles(String name) async {
    String downloadURL = await FirebaseStorage.instance
        .ref(name)
        .getDownloadURL();
    if(mounted){
      setState(() {
      downloadLink = downloadURL;
    });
    }
  }



  void _signingModalSheet() {
    final app = Provider.of<appState>(context, listen: false);
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: ()async{
                        final XFile? file = await _pickImage(true);

                        if(file != null && downloadLink.isNotEmpty){
                          app.setLoaderOn();
                          app.signingDocuments(downloadLink, File(file.path).readAsBytesSync(), widget.context, widget.doc.docId!);
                        }
                      },
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children:  [
                              Image.asset("assets/img/Scan.png", color: orangeColor2, height: 20,),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Capture Image",
                                style: textStyle.copyWith(color: orangeColor2),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: ()async{
                        final XFile? file = await _pickImage(false);

                        if(file != null && downloadLink.isNotEmpty){
                          app.setLoaderOn();
                          app.signingDocuments(downloadLink, File(file.path).readAsBytesSync(), widget.context, widget.doc.docId!);
                        }
                      },
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children:  [
                              Image.asset("assets/img/import.png", color: orangeColor2, height: 20,),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Import Image",
                                style: textStyle.copyWith(color: orangeColor2),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    InkWell(
                      onTap: ()async{
                        widget.onSign(downloadLink, widget.doc.docId!);
                      },
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children:  [
                              Image.asset("assets/img/signature.png", color: orangeColor2, height: 20,),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Use The Pad",
                                style: textStyle.copyWith(color: orangeColor2),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  Future<XFile?> _pickImage(bool cam) async {
    final XFile? file = await _picker.pickImage(
        source: cam ? ImageSource.camera : ImageSource.gallery);

    if(file != null) {
      Navigator.pop(context);
    }

    return file;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downloadFirebaseFiles(widget.doc.fileData!.name!);
    //   IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    // _port.listen((dynamic data) {
    //   String id = data[0];
    //   DownloadTaskStatus status = data[1];
    //   int progress = data[2];
    //   setState((){ });
    // });

    // FlutterDownloader.registerCallback(downloadCallback);
  }

  // @pragma('vm:entry-point')
  // static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  //   final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
  //   send!.send([id, status, progress]);
  // }


  // @override
  // void dispose() {
  //   // IsolateNameServer.removePortNameMapping('downloader_send_port');
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {
    final app  = Provider.of<appState>(context,listen: true);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(color: greyColor, borderRadius: BorderRadius.circular(10), image: const DecorationImage(image: AssetImage("assets/img/pdf.png"))),
          ),
          const SizedBox(width: 20,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                InkWell(
                  onTap: (){
                    if(downloadLink.isNotEmpty){
                      // if(!widget.doc.paid!){
                      //     _showPaymentDialog(widget.doc.docId);
                      // }
                      // else if(!widget.doc.signed!){
                      //   _signingModalSheet();
                      // }
                      // else{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFScreen(path: downloadLink, title: widget.doc.fileName!, online: true, signed: widget.doc.paid!, docId: widget.doc.docId,)));
                      // }
          
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.doc.fileName!, style: blue14Style, maxLines: 1, overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 8,),
                      Row(
                        children:  [
                          Text(DateFormat('yyyy-MM-dd').format(DateTime.fromMicrosecondsSinceEpoch(widget.doc.createdOn!*1000)), style: grey12Style,),
                          const SizedBox(width: 6,),
                          Image.asset("assets/img/dot.png", width: 3, height: 3,),
                          const SizedBox(width: 6,),
                          Text(DateFormat.Hm().format(DateTime.fromMicrosecondsSinceEpoch(widget.doc.createdOn!*1000)), style: grey12Style,)
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16,),
          
                Row(
                  children: [
                    if(widget.doc.paid! && widget.doc.signed!)
                    InkWell(
                      onTap: (){

                        if(!widget.doc.paid!){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFScreen(path: downloadLink, title: widget.doc.fileName!, online: true, signed: widget.doc.paid!, docId: widget.doc.docId,)));
                        }
                        else{
                        if(!widget.doc.signed!){
                          _signingModalSheet();
                        }
                        else{
                          app.printing(path: downloadLink, online: true);
                        }
                        }
                      },
                      child: Row(
                        children: [
                          Image.asset("assets/img/print.png", width: 20, height: 20,),
                          const SizedBox(width: 6,),
                          const Text("Print", style: TextStyle(color: Color.fromRGBO(248, 148, 62, 1)),),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30,),
                    if(widget.doc.paid! && !widget.doc.signed!)
                    InkWell(
                      onTap: ()=>_signingModalSheet(),
                      child: Text("Click here to sign", style: textStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 13, color: widget.doc.paid! ? orangeColor2 : Colors.black),)),
          
                    if(widget.doc.signed!)
                    InkWell(
                      onTap: (){ 
                        // app.downloadFun(downloadLink, widget.context);
                        widget.onDownload(downloadLink, widget.doc.fileData!.size!);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.download, color: orangeColor2,),
                           SizedBox(width: 6,),
                           Text("Download", style: TextStyle(color: Color.fromRGBO(248, 148, 62, 1)),),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // const Expanded(child: SizedBox()),
          const SizedBox(width: 20,),
           InkWell(
            onTap: ()=> app.showMenu(downloadLink, true, widget.context, 0, widget.doc.paid, widget.doc.signed),
            child:const Icon(Icons.more_horiz, color: Color.fromRGBO(82, 98, 134, 1),),
          )
        ],
      ),
    );
  }
}

