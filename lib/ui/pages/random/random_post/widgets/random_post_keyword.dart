import 'package:flutter/material.dart';

class RandomPostKeyword extends StatelessWidget {
  final String keyword;

  const RandomPostKeyword({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print('[랜덤포스트 키워드] "$keyword"');
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFFFFF3C3),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black, width: 0.3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(keyword.trim(), style: const TextStyle(fontSize: 10)),
        ),
      ),
    );
  }
}
