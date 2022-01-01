import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:taxdocs/Main/Components/expandable.dart';
import 'package:taxdocs/Main/Components/my_appbar.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class PDFScreen extends StatefulWidget {
  final String title;
  final String path;
  final bool? online;
  final bool? signed;
  final String? docId;

  const PDFScreen(
      {Key? key,
      required this.title,
      required this.path,
      this.online,
      this.signed,
      this.docId})
      : super(key: key);

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  final TextEditingController _note = TextEditingController();
  PDFDocument? doc;

  void getDocument() async {
    try {
      doc = widget.online == true
          ? await PDFDocument.fromURL(widget.path)
          : await PDFDocument.fromFile(File(widget.path));
      setState(() {});
    } catch (e) {
      final app = Provider.of<appState>(context, listen: false);
      app.showSnackBar(
          context,
          "Please check your internet connection. If you have no internet issues, kindly contact an admin via message",
          Colors.red);
    }
  }

  _showDeclineDialog(docId, ctx) {
    final app = Provider.of<appState>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Document Decline'),
          content: const Text(
              'You are about to decline this document. This operation will delete this received and sent documents'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                app.declineDocs(docId, ctx);
              },
              child: const Text(
                'Proceed',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  _showPaymentDialog(docId, ctx) {
    final app = Provider.of<appState>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Document Signing'),
          content: const Text(
              'To get access to the document, you will need to add your signature. Make payment to add your signature'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                app.makePayment(amount: '10', context: ctx, docId: docId);
              },
              child: const Text(
                'Proceed',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNoteModal(String path, ctx) {
    final app = Provider.of<appState>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: InkWell(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
              },
              child: Container(
                // height: 450,
                width: 327,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14)),
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
                      Text(
                        "Optional",
                        style: textStyle.copyWith(color: blue, fontSize: 13),
                      ),
                      Container(
                          padding: const EdgeInsets.only(
                              right: 10, left: 10, bottom: 10),
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
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () => app.uploadPDF(path, _note.text, ctx),
                        child: Container(
                          height: 50,
                          width: 251,
                          decoration: BoxDecoration(
                              color: orangeColor2,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              "Send Now",
                              style: textStyle.copyWith(
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
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
            ),
          );
        },
        barrierDismissible: false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _note.text = "";
    if (Platform.isIOS) {
      getDocument();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final app = Provider.of<appState>(context, listen: true);
    return Scaffold(
      appBar: myAppBar(widget.title),
      body: ModalProgressHUD(
        inAsyncCall: app.loading,
        progressIndicator: spinWidget,
        child: SafeArea(
            child: Platform.isIOS
                ? Center(
                    child: doc == null
                        ? const Center(
                            child: CircularProgressIndicator.adaptive())
                        : PDFViewer(document: doc!))
                : widget.online != null
                    ? GestureDetector(
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                        },
                        child: SfPdfViewer.network(
                          widget.path,
                          enableDoubleTapZooming: true,
                          enableDocumentLinkAnnotation: true,
                          canShowPaginationDialog: true,
                          enableTextSelection: true,
                          pageSpacing: 0.0,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                        },
                        child: SfPdfViewer.memory(
                          File(widget.path).readAsBytesSync(),
                          enableDoubleTapZooming: true,
                          enableDocumentLinkAnnotation: true,
                          canShowPaginationDialog: true,
                          enableTextSelection: true,
                          pageSpacing: 0.0,
                        ),
                      )),
      ),
      floatingActionButton: widget.online != null
          ? widget.signed == false
              ? ExpandableFab(
                  distance: 80.0,
                  children: [
                    ActionButton(
                      onPressed: () =>
                          _showPaymentDialog(widget.docId, context),
                      icon: const Text(
                        "Sign Document",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ActionButton(
                      onPressed: () =>
                          _showDeclineDialog(widget.docId, context),
                      icon: const Text(
                        "Decline Document",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // ActionButton(
                    //   onPressed: () =>print("HELLOO"),
                    //   icon: const Icon(Icons.insert_photo, color: Colors.white,),
                    // ),
                    // ActionButton(
                    //   onPressed: () => print("HELLOO"),
                    //   icon: const Icon(Icons.videocam, color: Colors.white,),
                    // ),
                  ],
                )
              : Container()
          : FloatingActionButton(
              onPressed: () {
                if (app.canUploadPDF()) {
                  _showNoteModal(widget.path, context);
                } else {
                  app.displayUploadDialog(context);
                }
              },
              backgroundColor: blue,
              elevation: 10,
              child: Image.asset(
                'assets/img/share.png',
                color: Colors.white,
                height: size.height * 0.03,
              ),
            ),
    );
  }
}

//PdfView(path: url);
