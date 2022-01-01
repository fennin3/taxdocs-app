import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merge_images/merge_images.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:taxdocs/Main/Components/archive_item.dart';
import 'package:taxdocs/Main/Components/bottom_nav_bar.dart';
import 'package:taxdocs/Main/Components/calendar_widget.dart';
import 'package:taxdocs/Main/Components/empty_docs.dart';
import 'package:taxdocs/Main/Components/received_item.dart';
import 'package:taxdocs/Main/Components/recent_doc.dart';
import 'package:taxdocs/Main/Components/sort_widget.dart';
import 'package:taxdocs/Main/Pages/received_docs.dart';
import 'package:taxdocs/Models/debouncer.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';
import 'dart:io' show Platform;
import 'dart:ui' as ui; 
import 'package:http/http.dart' as http;


const List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  final _calen = TextEditingController();
  final _query = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  bool sign = false;
  String downloadLink = "";
  String docId = "";
  String fileSize = "0";
  final RefreshController _refreshController = RefreshController(initialRefresh: false);


void _showDownloadOptions(ctx, downloadLink,name){
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight:  Radius.circular(20), topLeft: Radius.circular(20))),
      context: context, builder: (context){
        return Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: ()async{
                        Navigator.of(context).pop();
                        final app = Provider.of<appState>(context, listen: false);
                        app.setLoaderOn();

                        
                        List<ui.Image> images = [];
                        List<int> img_width = [];
                        double img_height = 0;
                        // Download PDF from server and convert pages to images
                         try{
                           await Dio().get(downloadLink, options: Options(responseType: ResponseType.bytes), onReceiveProgress: (received, total){
                            app.setDownloading();
                              app.setDownloaded(received);
                          }).then((res)async{
                            if(res.statusCode! < 206){
                              // Convert PDF pages to images
                              await for (var page in Printing.raster(res.data, pages: [0, 1], dpi: 72)) {
                                final image = await page.toImage(); // ...or page.toPng()
                                images.add(image);
                                img_width.add(image.width);
                                img_height += image.height;
                                
                              }
                            
                              
                              ui.Image image = await ImagesMergeHelper.margeImages( images,
                                fit: false,
                                direction: Axis.vertical,
                                backgroundColor: Colors.white);


                                Uint8List? bytes = await ImagesMergeHelper.imageToUint8List(image);
                                
                                
                                app.setLoaderOff(); 
                                                             
                                app.showSnackBar(ctx, "Saving Image File", null);
                                app.saveImageFile(ctx, bytes, name);
                            }else{
                              app.setLoaderOff();
                              app.showSnackBar(ctx, "Please check your internet connection and try again", Colors.red);
                            }
                          });
                         } catch (e){
                          print("**********11");
                          print(e);
                            app.setLoaderOff();
                            app.showSnackBar(ctx, "Please check your internet connection and try again", Colors.red);
                         }

                        
                        
                      },
                      child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children:  [
                                const Icon(Icons.image, color: orangeColor2, size: 25,),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Download JPEG",
                                  style: textStyle.copyWith(color: orangeColor2, fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ),
                    ),
                      const SizedBox(height: 10,),

                      InkWell(
                        onTap: (){ 
                          final app = Provider.of<appState>(context, listen: false);
                          app.setDownloading();
                          app.downloadFun(downloadLink, ctx, name);
                          Navigator.of(context).pop();
                          },
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children:  [
                                const Icon(Icons.picture_as_pdf, color: orangeColor2, size: 25,),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Download PDF",
                                  style: textStyle.copyWith(color: orangeColor2, fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),


                  ],
                ),
              ),
            ),
        );
    });
  }


  Future<void> _onRefresh()async{
    final app = Provider.of<appState>(context, listen: false);
    app.fetchArchivedDocs();
    _refreshController.refreshCompleted();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _calen.dispose();
    _query.dispose();
    _refreshController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final app = Provider.of<appState>(context,listen: false);
    _calen.text = "${months[int.parse(app.archiveMonth)-1]} ${app.archiveYear}";
    _query.text = app.archiveSearch;
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final app = Provider.of<appState>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: backArrowColor,
              )),
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: false,
          title: Text(
            "My Archives",
            style: textStyle.copyWith(color: blue, fontSize: 18),
          ),
        ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),
        onRefresh: _onRefresh,
        controller: _refreshController,
        child: ModalProgressHUD(
          inAsyncCall: app.downloading? app.downloading : app.loading,
          progressIndicator: app.downloading ? spinWidget2(fileSize, app.downloaded) : spinWidget,
          child:Stack(
            children: 
                [
                  SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.024,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width * 0.78,
                                height: size.height < 900 ? 55 : size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: greyColor2,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.symmetric(horizontal: 16),
                                          child: Image.asset(
                                            "assets/img/calen.png",
                                            height: 20,
                                            width: 20,
                                          )),
                                      Flexible(
                                          child: Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: TextFormField(
                                          controller: _calen,
                                          cursorColor: blue,
                                          style: textStyle.copyWith(color: blue),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "September 2020",
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromRGBO(179, 188, 207, 1),
                                            ),
                                          ),
                                          onChanged: (value){
                                            _debouncer.run(() async{
                                              try{
                                                final format = DateFormat("MMMM yyyy");
                                                final date = format.parse(value);
                                                app.setArchiveMY(date);
                                                app.fetchArchivedDocs();
                                              }
                                              catch(e){}
                                            });
                                          },
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                              // const SizedBox(
                              //   width: 20,
                              // ),
                              CalendarWidget(size: size, onSelected: (date){
                                app.setArchiveMY(date);
                                setState(() {
                                  _calen.text =  months[int.parse(app.archiveMonth)-1] + " ${app.archiveYear}";
                                });
                                app.fetchArchivedDocs();
                              },)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width * 0.78,
                                height: size.height < 900 ? 55 : size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: greyColor2,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.symmetric(horizontal: 16),
                                          child: Image.asset(
                                            "assets/img/search.png",
                                            height: 15,
                                            width: 15,
                                          )),
                                      Flexible(
                                          child: Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: TextFormField(
                                          controller: _query,
                                          onChanged: (value){
                                            _debouncer.run(() {
                                              app.setArchiveSearch(value);
                                              app.fetchArchivedDocs();
                                            });
                                          },
                                          cursorColor: blue,
                                          style: textStyle.copyWith(color: blue),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Search your files",
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromRGBO(179, 188, 207, 1),
                                            ),
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                              // const SizedBox(
                              //   width: 20,
                              // ),
                              SortWidget(size: size, onTap: (int ) {},)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height < 900 ? 32 : size.height * 0.04,
                      ),
                      SizedBox(
                          width: size.width * 0.9,
                          child: Text(
                            _calen.text,
                            style: textStyle.copyWith(fontSize: 16, color: blue),
                          )),
                      SizedBox(
                        height: size.height < 900 ? 12 : size.height * 0.015,
                      ),
                      Expanded(
                        child: app.loading ? const Center(child: spinWidget,): app.myArchives.isNotEmpty ? GridView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 450,
                              mainAxisExtent: 100,
                              crossAxisSpacing: 20),
                          itemCount: app.myArchives.length,
                          itemBuilder: (context, index) {
                            return ArchiveItem(doc: app.myArchives[index], context: context,
                            onDownload: (link, downloadSize){
                              setState(() {
                                fileSize = downloadSize;
                              });
                              _showDownloadOptions(context, link, app.receivedDocs[index].fileName);
                            },
                            onSign: (downlink,docId){
                              setState(() {
                                Navigator.pop(context);
                                downloadLink = downlink;
                                docId = docId;
                                sign = true;
                              });
                            },);
                          },
                        ) : Center(child: EmptyDocs(size: size,),),
                      ),
                    ],
                  ),
                ),

                if (sign)
                Positioned(
                    child: SignaturePage(
                  onDone: (byteList) {
                    setState(() {
                      sign = false;
                    });
                    app.setLoaderOn();
                    app.signingDocuments(downloadLink, byteList, context, docId);
                  },
                  onCancel: (value) {
                    setState(() {
                      sign = false;
                    });
                  },
                )),

              if(app.downloading)
                Positioned(child: 
                Container(
                  color: backgroundBlue,
                  height: 50,
                  width: double.infinity,
                  child: const Center(child:  Text("File is downloading, please wait...", style: TextStyle(color: Colors.white),)),
                ))
              ],
                
          ),
            
          
        ),
      ),
      bottomNavigationBar: BottomNavBar(
          size: size, cont: context,
        ),
    );
  }

}




