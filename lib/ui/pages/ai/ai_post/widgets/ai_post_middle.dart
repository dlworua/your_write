import 'package:flutter/material.dart';

class AiPostMiddle extends StatelessWidget {
  final String title;
  final String content;

  const AiPostMiddle({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.cyan[100],
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
