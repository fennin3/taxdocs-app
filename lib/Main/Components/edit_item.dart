import 'package:flutter/material.dart';

class EditPageItem extends StatelessWidget {
  const EditPageItem({
    Key? key,
    required this.size,
    required this.image,
    required this.title
  }) : super(key: key);

  final Size size;
  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: size.height > 900 ? 24 : 20, width: size.height > 900 ? 24 : 20,),
        const SizedBox(height: 4,),
        Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),)
      ],
    );
  }
}