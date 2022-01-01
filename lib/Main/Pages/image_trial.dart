

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ImageTrial extends StatelessWidget {
  final Uint8List image;
  const ImageTrial({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.memory(image, fit: BoxFit.fill,),
    );
  }
}