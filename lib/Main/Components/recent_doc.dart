import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Database/scan_model.dart';
import 'package:taxdocs/Main/Components/pdf_widget.dart';
import 'package:taxdocs/Main/Components/send_widget.dart';
import 'package:taxdocs/Main/Pages/pdf_page.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';

class RecentDocWidget extends StatefulWidget {
  final bool? send;
  final ScanModel? scan;
  final Function(bool, String) onSend;
  final BuildContext? cont;

  const RecentDocWidget(
      {Key? key, this.send, this.scan, required this.onSend, this.cont})
      : super(key: key);

  @override
  State<RecentDocWidget> createState() => _RecentDocWidgetState();
}

class _RecentDocWidgetState extends State<RecentDocWidget> {
  String _note = "";

  void _showNoteModal() {
    // final app = Provider.of<appState>(context, listen: false);
    // final size = MediaQuery.of(context).size;

    showDialog(
        context: widget.cont!,
        builder: (context) {
          return Dialog(
            child: GestureDetector(
              onTap: ()=>FocusScope.of(context).requestFocus(new FocusNode()),
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
                            onChanged: (value){
                              setState(() {
                                _note = value;
                              });
                            },
                            cursorColor: blue,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "You can add a note here..."),
                          )),
            
                      const SizedBox(height: 30,),
                      InkWell(
                        onTap: (){
                          widget.onSend(true, _note);
                          _note ="";
                        },
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
                        height: 20,
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
            ),
          );
        },
    barrierDismissible: false
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final app = Provider.of<appState>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                color: greyColor,
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                    image: AssetImage('assets/img/pdf.png'))),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PDFScreen(
                                path: widget.scan!.pdf,
                                title: widget.scan!.title,
                              ))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.scan?.title}",
                        style: blue14Style,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            DateFormat('yyyy-MM-dd')
                                .format(widget.scan?.createdAt ?? DateTime.now()),
                            style: grey12Style,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Image.asset(
                            "assets/img/dot.png",
                            width: 3,
                            height: 3,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            DateFormat.Hm()
                                .format(widget.scan?.createdAt ?? DateTime.now()),
                            style: grey12Style,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () => app.printing(path: widget.scan!.pdf),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/img/print.png",
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          const Text(
                            "Print",
                            style:
                                TextStyle(color: Color.fromRGBO(248, 148, 62, 1)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    InkWell(
                        onTap: () {
                          if (app.canUploadPDF()) {
                            _showNoteModal();
                          } else {
                            app.displayUploadDialog(context);
                          }
                        },
                        child: SendWidget(send: widget.send))
                  ],
                ),
                Row(
                  children: [Container()],
                )
              ],
            ),
          ),
          const SizedBox(width: 20,),
         InkWell(
          onTap: () => app.showMenu(widget.scan!.pdf, false, widget.cont, app.myScans.reversed.toList().indexOf(widget.scan!), null, null),
          child: const Icon(
            Icons.more_horiz,
            color:  Color.fromRGBO(82, 98, 134, 1),
          ),
         )
         
        ],
      ),
    );
  }
}


