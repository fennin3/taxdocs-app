import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_edge_detection/edge_detection.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:taxdocs/Main/Components/edit_item.dart';
import 'package:taxdocs/Main/Components/nav_item.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';
import 'package:image/image.dart' as img;
import 'cropping_preview.dart';

class ScanEdit extends StatefulWidget {
  final File image;
  final EdgeDetectionResult edgeDetectionResult;

  const ScanEdit(
      {Key? key, required this.edgeDetectionResult, required this.image})
      : super(key: key);

  @override
  _ScanEditState createState() => _ScanEditState();
}

class _ScanEditState extends State<ScanEdit> {
  bool _cropped = false;
  int _rotate = 0;
  Uint8List? image2;
  List<Offset> pointsList = [];
  int touched = -1;
  ui.Image? image;
  bool isImageLoaded = false;
  int rotation = 0;
  List<Offset> points = [];


  void rotate() {
    setState(() {
      _rotate += 1;
    });
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {

      return completer.complete(img);
    });
    return completer.future;
  }


  void initData(){
    setState(() {
      points.add(widget.edgeDetectionResult.topLeft);
      points.add(widget.edgeDetectionResult.topRight);
      points.add(widget.edgeDetectionResult.bottomRight);
      points.add(widget.edgeDetectionResult.bottomLeft);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width * 0.87;
    imageCache.clear();
    imageCache.clearLiveImages();
    final app = Provider.of<appState>(context, listen: false);
    // print(app.points);
    final appbar = AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Crop", style: textStyle.copyWith(fontSize: 18),),
          TextButton(onPressed: ()async{

            final EdgeDetectionResult _result = EdgeDetectionResult(topLeft: points[0], topRight: points[1], bottomLeft: points[3], bottomRight: points[2]);
            await EdgeDetector().processImage(widget.image.path, _result, _rotate * 90).then((value)async{
              final newPath = await app.getFilePath(type: "image");
              final newImage = await File(widget.image.path).copy(newPath);
              app.addScannedImage(newImage.path);
              Navigator.of(context).pop();
            });

          }, child: const Text("Done", style: textStyle,))
        ],
      ),

      automaticallyImplyLeading: true,
      centerTitle: false,
    );
    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: appbar,
      body: SafeArea(
          child: SizedBox(
            height: size.height - appbar.preferredSize.height -  size.height * 0.14,
            child: Center(
                child: !_cropped ? Container(
                    width: width,
                    height: (size.height - appbar.preferredSize.height -  size.height * 0.14) * 0.82,
                    color: Colors.white,
                    child: RotatedBox(
                        quarterTurns: _rotate,
                        child: ImagePreview(edgeDetectionResult: widget.edgeDetectionResult, imagePath: widget.image.path,
                        onPoints: (offset, int){
                            points[int] = offset;
                        },
                        ))
                ): Center(

                    child: SizedBox(
                        width: width,
                        child: Image.file(File(widget.image.path), key: UniqueKey(),)))
            ),
          )
      ),
      bottomNavigationBar: Container(
        height: size.height * 0.14,
        color: const Color.fromRGBO(245, 248, 253, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(!_cropped)
            InkWell(
                onTap: ()=>rotate(),
                child: EditPageItem(size: size, image: "assets/img/rotate.png", title: "Rotate",)),
            InkWell(
                onTap: ()=> Navigator.pop(context),
                child: EditPageItem(size: size, image: "assets/img/retake.png", title: "Retake",)),
            InkWell(
                onTap: ()=>Navigator.pop(context),
                child: EditPageItem(size: size, image: "assets/img/delete.png", title: "Delete",)),
            InkWell(
                onTap: ()async{
                  if(!_cropped){
                    final EdgeDetectionResult _result = EdgeDetectionResult(topLeft: points[0], topRight: points[1], bottomLeft: points[3], bottomRight: points[2]);
                    await EdgeDetector().processImage(widget.image.path, _result, _rotate * 90).then((value){
                      setState(() {
                        _cropped=true;
                      });
                    });
                  }
                  else{
                    final newPath = await app.getFilePath(type: "image");
                    final newImage = await File(widget.image.path).copy(newPath);
                    app.addScannedImage(newImage.path);
                    Navigator.of(context).pop();
                  }
                },
                child: NavCircleWidget(outerheight:size.height * 0.04, innerheight:size.height * 0.028, middleheight:size.height * 0.0355, icon: "assets/img/check.png", screen: null,)),
          ],
        ),
      ),
    );
  }
}


