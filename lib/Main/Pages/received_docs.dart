import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:merge_images/merge_images.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:taxdocs/Main/Components/bottom_nav_bar.dart';
import 'package:taxdocs/Main/Components/empty_docs.dart';
import 'package:taxdocs/Main/Components/my_appbar.dart';
import 'package:taxdocs/Main/Components/received_item.dart';
import 'package:taxdocs/Main/Components/sort_widget.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:io' show File, Platform;
// import 'package:merge_images/merge_images.dart';
import 'dart:ui' as ui; 
import 'package:http/http.dart' as http;


class ReceivedDocs extends StatefulWidget {
  const ReceivedDocs({Key? key}) : super(key: key);

  @override
  State<ReceivedDocs> createState() => _ReceivedDocsState();
}

class _ReceivedDocsState extends State<ReceivedDocs> {
  bool sign = false;
  String downloadLink = "";
  String docId = "";
  String fileSize = "0";
  // int receivedDownload = 0;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<void> _onRefresh()async{
    final app = Provider.of<appState>(context, listen: false);
    app.fetchReceivedDocs();
    _refreshController.refreshCompleted();
  }


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
                          Navigator.of(context).pop();
                          app.setDownloading();
                          app.setLoaderOn();
                          app.downloadFun(downloadLink, ctx, name);
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
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _refreshController.dispose();
  }





  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final app = Provider.of<appState>(context, listen: true);
    // print("File size = $fileSize || Downloaded = ${app.downloaded}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar("Received Documents"),
      body:  SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),
        onRefresh: _onRefresh,
        controller: _refreshController,
        child: ModalProgressHUD(
          inAsyncCall: app.loading,
          progressIndicator: app.downloading ? spinWidget2(fileSize, app.downloaded) : spinWidget,
          child: Stack(
            children: [
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Image.asset(
                                          "assets/img/search.png",
                                          height: 15,
                                          width: 15,
                                        )),
                                    Flexible(
                                        child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: TextFormField(
                                        initialValue: app.receivedSearch,
                                        onChanged: (e) {
                                          app.searchReceived(e);
                                        },
                                        cursorColor: blue,
                                        style: textStyle.copyWith(color: blue),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Search your files",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Color.fromRGBO(179, 188, 207, 1),
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
                            SortWidget(
                              size: size,
                              onTap: (filter) {
                                app.filterList(filter, 'received');
                              },
                            )
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
                          "${app.receivedDocs.length} ${app.receivedDocs.length > 1
                                  ? 'Total Documents'
                                  : 'Document'}",
                          style: textStyle.copyWith(fontSize: 16, color: blue),
                        )),
                    SizedBox(
                      height: size.height < 900 ? 12 : size.height * 0.015,
                    ),
                    Expanded(
                      child: app.receivedDocs.isNotEmpty
                          ? GridView.builder(
                              // physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 450,
                                      mainAxisExtent: 100,
                                      crossAxisSpacing: 20),
                              itemCount: app.receivedDocs.length,
                              itemBuilder: (context2, index) {
                                return ReceivedItem(
                                  doc: app.receivedDocs[index],
                                  context: context,
                                  onSign: (downlink, mydocId) {
                                    setState(() {
                                      Navigator.pop(context);
                                      downloadLink = downlink;
                                      docId = mydocId;
                                      sign = true;
                                    });
                                  },
                                  onDownload: (String link, size){
                                    print("Total Size == $size");
                                    setState(() {
                                      fileSize = size;
                                    });
                                    // app.setLoaderOn();
                                    _showDownloadOptions(context, link, app.receivedDocs[index].fileName);
                                  },
                                );
                              },
                            )
                          : Center(
                              child: EmptyDocs(
                                size: size,
                              ),
                            ),
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
        size: size,
        cont: context,
      ),
    );
  }
}

class SignaturePage extends StatefulWidget {
  final Function(Uint8List) onDone;
  final Function(bool) onCancel;

  const SignaturePage({Key? key, required this.onDone, required this.onCancel})
      : super(key: key);

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  SignatureController? _signatureController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _signatureController = SignatureController(
        penStrokeWidth: 5,
        penColor: Colors.black,
        exportBackgroundColor: Colors.white,
        exportPenColor: Colors.black);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _signatureController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var _signatureCanvas = Signature(
      controller: _signatureController!,
      width: double.infinity,
      height: size.height * 0.5,
      backgroundColor: orangeColor2,
    );
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.5,
          width: double.infinity,
          child: Stack(
            children: [
              _signatureCanvas,
              Positioned(
                  right: 0,
                  child: InkWell(
                    onTap: () => _signatureController!.clear(),
                    child: const Card(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(Icons.undo),
                      ),
                    ),
                  ))
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    _signatureController!.clear();
                    widget.onCancel(true);
                  },
                  child: Text(
                    "Cancel",
                    style: textStyle.copyWith(color: orangeColor2),
                  )),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                  onPressed: () async {
                    await _signatureController!.toPngBytes().then((imageFile) => widget.onDone(imageFile!));
                    _signatureController!.clear();
                  },
                  child: Text(
                    "Done",
                    style: textStyle.copyWith(color: orangeColor2),
                  )),
            ],
          ),
        )
      ],
    );
  }
}
