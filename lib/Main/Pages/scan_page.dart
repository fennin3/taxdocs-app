import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:simple_edge_detection/edge_detection.dart';
import 'package:taxdocs/Main/Components/edit_item.dart';
import 'package:taxdocs/Main/Components/nav_item.dart';
import 'package:taxdocs/Main/Pages/scan_done.dart';
import 'package:taxdocs/Main/Pages/scan_edit_page.dart';
import 'package:taxdocs/Models/edge_painter.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';
import 'dart:async';
import 'dart:ui' as ui;

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  bool _detecting = false;
  EdgeDetectionResult? _detectedImage;
  GlobalKey imageWidgetKey = GlobalKey();
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool flashOn = false;

  void _importImage() async {
    final app = Provider.of<appState>(context, listen: false);

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // final newPath = await app.getFilePath("image");

    // await image!.saveTo(newPath);
    setState(() {
      // _image = File(im);
      _image = image;
    });
    if(_image != null) {
      detectNavigate();
    }
  }

  Future<bool> detectImage(image) async {
    setState(() {
      _detecting=true;
    });
    _detectedImage = await EdgeDetector().detectEdges(image.path);
    setState(() {
      _detecting=false;
    });
    return true;
  }

  void detectNavigate(){
    detectImage(_image).then((value) => Future.delayed(const Duration(milliseconds:   10)).then(
          (value){
            try{
                offFlash();
            }catch(e){
              
            }
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  ScanEdit(edgeDetectionResult: _detectedImage!, image: File(_image!.path)),
          ),
        ).then((value){
          setState(() {
            _image=null;
            _detectedImage = null;
          });
        });
      },
    ),);
  }


  Future<bool> availCams()async{
    _cameras = await availableCameras();
    return true;
  }

  void offFlash(){
    setState(() {
      flashOn =false;
      _controller!.dispose();
      initCamera();

    });
  }


    void offFlash2(){
    setState(() {
      flashOn =false;
      _controller!.dispose();
      initCamera();
    });
  }

  void onFlash(){
    setState(() {
      flashOn =true;
      _controller!.setFlashMode(FlashMode.always);
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('If you proceed your scanned images will ble lost'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: orangeColor2),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Proceed', style: TextStyle(color: orangeColor2),),
              onPressed: () {
                final app = Provider.of<appState>(context, listen: false);
                app.clearScanData();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void initCamera(){
     availCams().then((value){
      _controller = CameraController(_cameras![0], ResolutionPreset.max);
      _controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        _controller!.setFlashMode(FlashMode.off);
        setState(() {
        });
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              print('User denied camera access.');
              break;
            default:
              print('Handle other errors.');
              break;
          }
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  initCamera();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final app = Provider.of<appState>(context, listen: true);
    final appbar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: const Text(
        "Position photo within the frame",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      automaticallyImplyLeading: false,
      leading: InkWell(
          onTap: ()=> Navigator.pop(context),
          child: const Icon(Icons.close, color: Colors.white,)),
      centerTitle: true,
    );
    return WillPopScope(
      onWillPop: ()async{
        if(app.scannedImages.isNotEmpty){
         _showMyDialog();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundBlue,
        appBar: appbar,
        body: SafeArea(
            child: ModalProgressHUD(
              inAsyncCall: _detecting,
              progressIndicator: spinWidget,
              child: SizedBox(
          height: size.height - appbar.preferredSize.height - size.height * 0.14,
          child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                      width: size.width * 0.87,
                      height: (size.height -
                              appbar.preferredSize.height -
                              size.height * 0.14) *
                          0.83,
                      color: Colors.white,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (_image == null)
                            _controller != null ? CameraPreview(_controller!) : const Center(child: spinWidget,)
                          else
                            Image.file(
                              File(_image!.path),
                              fit: BoxFit.contain,
                              key: imageWidgetKey,
                            ),
                          if (_image != null)
                            FutureBuilder<ui.Image>(
                                future: loadUiImage(_image!.path),
                                builder: (BuildContext context,
                                    AsyncSnapshot<ui.Image> snapshot) {
                                  return _getEdgePaint(snapshot, context);
                                }),
                        ],
                      )),
                  Positioned(
                      top: -9,
                      left: -9,
                      child: Image.asset(
                        "assets/img/topleft.png",
                        width: 9,
                        height: 9,
                      )),
                  Positioned(
                      top: -9,
                      right: -9,
                      child: Image.asset(
                        "assets/img/topright.png",
                        width: 9,
                        height: 9,
                      )),
                  Positioned(
                      bottom: -9,
                      right: -9,
                      child: Image.asset(
                        "assets/img/bright.png",
                        width: 9,
                        height: 9,
                      )),
                  Positioned(
                      bottom: -9,
                      left: -9,
                      child: Image.asset(
                        "assets/img/bleft.png",
                        width: 9,
                        height: 9,
                      )),
                ],
              ),
          ),
        ),
            )),
        bottomNavigationBar: Container(
          height: size.height * 0.14,
          color: const Color.fromRGBO(245, 248, 253, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () => _importImage(),
                  child: EditPageItem(
                    size: size,
                    image: "assets/img/import.png",
                    title: "Import",
                  )),
              EditPageItem(
                size: size,
                image: "assets/img/auto.png",
                title: "Auto",
              ),
              InkWell(
                  onTap: () async{
                    final XFile image = await _controller!.takePicture();
                    setState(() {
                      _image = image;
                    });

                    detectNavigate();
                  },
                  child: NavCircleWidget(
                    outerheight: size.height * 0.058,
                    innerheight: size.height * 0.04,
                    middleheight: size.height * 0.052,
                    icon: "assets/img/Scan.png",
                  )),
              InkWell(
                onTap: ()=> onFlash(),
                child: !flashOn ? EditPageItem(
                  size: size,
                  image: "assets/img/flash.png",
                  title: "Flash",
                ) : InkWell(
                  onTap: ()=> offFlash(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                    Icon(Icons.flash_on, color: orangeColor2, size: 25,),
                      Text("Flash", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),)
                  ],),
                ),
              ),
              InkWell(
                  onTap: (){
                    if(app.scannedImages.isNotEmpty){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ScanComplete())).then((value){
                                setState(() {
                                });
                      });
                    }
                  },
                  child: DocCounterWidget(
                    docs: app.scannedImages.length,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _getEdgePaint(
      AsyncSnapshot<ui.Image> imageSnapshot, BuildContext context) {
    if (imageSnapshot.connectionState == ConnectionState.waiting) {
      return Container();
    }

    if (imageSnapshot.hasError) return Text('Error: ${imageSnapshot.error}');

    if (_detectedImage == null) {
      return Container();
    }

    final keyContext = imageWidgetKey.currentContext;

    if (keyContext == null) {
      return Container();
    }

    final box = keyContext.findRenderObject() as RenderBox;

    return _detectedImage == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : CustomPaint(
            size: Size(box.size.width, box.size.height),
            painter: EdgePainter(
                topLeft: _detectedImage!.topLeft,
                topRight: _detectedImage!.topRight,
                bottomLeft: _detectedImage!.bottomLeft,
                bottomRight: _detectedImage!.bottomRight,
                image: imageSnapshot.data!,
                color: Theme.of(context).accentColor));
  }

  Future<ui.Image> loadUiImage(String imageAssetPath) async {
    final Uint8List data = await File(imageAssetPath).readAsBytes();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image image) {
      return completer.complete(image);
    });
    return completer.future;
  }
}

class DocCounterWidget extends StatelessWidget {
  final int docs;

  const DocCounterWidget({required this.docs});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<appState>(context,listen: true);
    return Stack(
      clipBehavior: Clip.none,
      children: [
         app.scannedImages.isEmpty ? const CircleAvatar(
          radius: 24,
          backgroundColor: Color.fromRGBO(255, 203, 93, 1),
        ) : CircleAvatar(
           radius: 24,
           backgroundColor:const Color.fromRGBO(255, 203, 93, 1),
           backgroundImage: MemoryImage(File(app.scannedImages[0]).readAsBytesSync()),
         ),
        Positioned(
            right: 3,
            top: -8,
            child: CircleAvatar(
              radius: 11,
              backgroundColor: orangeColor2,
              child: Center(
                child: Text(
                  "$docs",
                  style: textStyle.copyWith(fontSize: 15),
                ),
              ),
            ))
      ],
    );
  }
}
