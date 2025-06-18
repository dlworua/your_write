import 'package:flutter/material.dart';

class RandomPostMiddle extends StatelessWidget {
  final String title;
  final String content;

  const RandomPostMiddle({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.lightGreen[200],
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(top: 10)),
          Text(title, style: TextStyle(fontSize: 40)),
          SizedBox(height: 30),
          Text(
            content,
            style: TextStyle(fontSize: 20),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
