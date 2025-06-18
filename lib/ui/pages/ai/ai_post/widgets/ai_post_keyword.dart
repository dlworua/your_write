import 'package:flutter/material.dart';

class AiPostKeyword extends StatelessWidget {
  final String keyword;

  const AiPostKeyword({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7, left: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFFFFF3C3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 0.3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(keyword, style: const TextStyle(fontSize: 10)),
        ),
      ),
    );
  }
}
