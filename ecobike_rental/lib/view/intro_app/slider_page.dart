import 'package:flutter/material.dart';

/// trả về màn hình slide
class SliderPage extends StatelessWidget {
  // Constructor chứa ảnh và miêu tả từng slide
  const SliderPage({this.description, this.image});
  final String description;
  final String image;

  // Trả về widget màn hình slide
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              height: height/4,child: Image.asset(image,fit: BoxFit.fill,)),
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Text(
              description,
              style: const TextStyle(
                height: 1.5,
                fontWeight: FontWeight.normal,
                fontSize: 14,
                letterSpacing: 0.7,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}