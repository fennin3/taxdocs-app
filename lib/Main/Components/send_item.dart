import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Main/Pages/pdf_page.dart';
import 'package:taxdocs/Models/doc_model.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';
import 'package:http/http.dart' as http;

class SentItem extends StatefulWidget {
  final SentDoc doc;
  final BuildContext context;
  const SentItem({Key? key, required this.doc, required this.context}) : super(key: key);

  @override
  State<SentItem> createState() => _SentItemState();
}

class _SentItemState extends State<SentItem> {
  FirebaseStorage storage = FirebaseStorage.instance;
  String downloadLink = "";

  Future<void> downloadFirebaseFiles(String name) async {
    String downloadURL = await FirebaseStorage.instance
        .ref(name)
        .getDownloadURL();
  if(mounted){
     setState(() {
     downloadLink = downloadURL;
   });
  }
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewPDF(doc)));  //Notice the Push Route once this is done.
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downloadFirebaseFiles(widget.doc.fileData!.name!);
  }
  @override
  Widget build(BuildContext context) {
    final app  = Provider.of<appState>(context,listen: true);
    print(widget.doc.id);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(color: greyColor, borderRadius: BorderRadius.circular(10), image: const DecorationImage(image: AssetImage('assets/img/pdf.png'))),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFScreen(path: downloadLink, title: widget.doc.fileName!, online: true,)));
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
                const SizedBox(height: 17,),
          
                Row(
                  children: [
                    InkWell(
                      onTap: ()async{
                        // print(downloadLink);
                        // app.setLoaderOn();
                        // final doc = await http.get(Uri.parse(downloadLink));
                        // app.setLoaderOff();
                        // print(doc.body.runtimeType);
          
          
                        app.printing(path: downloadLink, online: true);
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
          
                  ],
                ),
              ],
            ),
          ),
          // const Expanded(child: SizedBox()),
          const SizedBox(width: 20,),
         InkWell(
          onTap: ()=>app.showMenu(downloadLink, true, widget.context, 0, null, null),
            child:const Icon(Icons.more_horiz, color: Color.fromRGBO(82, 98, 134, 1),),
          )
        ],
      ),
    );
  }
}
