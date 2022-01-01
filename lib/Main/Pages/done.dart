import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Database/scan_model.dart';
import 'package:taxdocs/Main/Components/edit_item.dart';
import 'package:taxdocs/Main/Pages/saved_docs.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';
import 'package:toast/toast.dart';
import 'dart:io' show File, Platform;
// import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:syncfusion_flutter_pdf/pdf.dart' as pdfNew;
import 'dart:ui';


class Done extends StatefulWidget {
  final size;
  const Done({Key? key, this.size}) : super(key: key);

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  PageController controller=PageController();
  int _pageIndex=0;
  final pdf = pw.Document();
  bool _loading = false;
  // final pdfNew.PdfDocument document = pdfNew.PdfDocument();

  Future<bool> createPDF(List images) async {
    for (String img in images) {
      final image = pw.MemoryImage(File(img).readAsBytesSync());
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context contex) {
            return pw.Center(child: pw.Image(image));
          }));
    }
    return true;
  }

  savePDF(String name) async {
    final app = Provider.of<appState>(context, listen: false);
    try {
      final file = File(name);
      await file.writeAsBytes(await pdf.save());
      app.showSnackBar(context, "PDF has been saved", null);
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    // document.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<appState>(context, listen: true);
    ToastContext().init(context);
    final appbar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
          onPressed: (){
            if(app.editPage == MyPage.done){
              Navigator.pop(context);
            }
            else{
              app.changeEditPage(MyPage.done);
            }
          },
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Colors.white,
          )),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: TextFormField(
            initialValue: app.filename,
            autofocus: false,
            autocorrect: false,
            style: textStyle.copyWith(fontSize: 18),
            cursorColor: Colors.white,
            onChanged: (name){
              app.setFilename(name);
            },
            decoration: InputDecoration(
              // label: Text("File name", style: textStyle,),
                hintText: "File name ( eg. mydoc1 )",
                hintStyle: textStyle.copyWith(color: Colors.white24),
                // hintText: Text,
                border: InputBorder.none
            ),
          )),
          TextButton(
              onPressed: ()async{
            if(app.filename.isEmpty){
              Toast.show("Enter file name",gravity: Toast.top, duration: Toast.lengthLong, backgroundColor: Colors.white, textStyle: const TextStyle(color: blue));
            }
            else{
              setState(() {
                _loading=true;
              });
               await createPDF(app.scannedImages).then((value)async{
                 await app.getFilePath(type: 'pdf',name: app.filename.replaceAll(' ', '')).then((path)async{
                   await savePDF(path);
                   final scanned = ScanModel(createdAt: DateTime.now(), pdf: path, title: app.filename, userId: app.userId!);
                   app.savePdf(scanned);
                   app.clearScanData();

                   setState(() {
                     _loading =false;
                   });
                 });
               });
               
              Navigator.pop(context);
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const SavedDoc(),
                ),
              );
            }
          }, child: const Text("Save PDF", style: textStyle,))
        ],
      ),

      automaticallyImplyLeading: true,
      centerTitle: false,
    );
    return ModalProgressHUD(
      inAsyncCall: _loading,
      progressIndicator: spinWidget,
      child: Scaffold(
        backgroundColor:  backgroundBlue,
        appBar: appbar,
        body: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  height: widget.size.height - appbar.preferredSize.height -  widget.size.height * 0.14,
                  child: Center(
                    child: SizedBox(
                      width: widget.size.width * 0.85,
                      height: (widget.size.height - appbar.preferredSize.height -  widget.size.height * 0.14) * 0.8,
                      child: PageView(

                        children: [
                          for (String image in app.scannedImages)
                            Image.file(File(image),fit: BoxFit.contain,),

                        ],
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index){
                          setState(() {
                            _pageIndex = index;
                          });
                        },
                      ),
                    )
                  ),
                ),
                Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.black.withOpacity(0.4),
                  child: Text("Page ${_pageIndex + 1} of ${app.scannedImages.length}", style: textStyle.copyWith(fontWeight: FontWeight.normal, fontSize: 14),),
                ))
              ],
            )
        ),
        bottomNavigationBar: Container(
          height: widget.size.height * 0.14,
          color: const Color.fromRGBO(245, 248, 253, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  onTap: ()=> app.changeEditPage(MyPage.reorder),
                  child: EditPageItem(size: widget.size, image: "assets/img/reorder.png", title: "Reorder",)),
              // InkWell(
              //     onTap: ()=> app.changeEditPage(MyPage.resize),
              //     child: EditPageItem(size: widget.size, image: "assets/img/auto2.png", title: "Resize",)),
              InkWell(
                  onTap: ()=>Navigator.of(context).pop(),
                  child: EditPageItem(size: widget.size, image: "assets/img/addpage.png", title: "Add page",)),
              // EditPageItem(size: widget.size, image: "assets/img/rotate.png", title: "Rotate",),
              InkWell(
                  onTap: (){
                    app.clearScanData();
                    Navigator.pop(context);
                  },
                  child: EditPageItem(size: widget.size, image: "assets/img/retake.png", title: "Restart",)),
            ],
          ),
        ),
      ),
    );
  }
}