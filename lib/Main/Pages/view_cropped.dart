import 'dart:io';

import 'package:flutter/material.dart';

class viewCropped extends StatelessWidget {
  final String path;
  const viewCropped({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.file(File(path))
      ),
    );
  }
}
