import 'package:flutter/material.dart';

// 제목
class DetailTitle extends StatelessWidget {
  final String title;
  const DetailTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}

// 작성자
class DetailWriter extends StatelessWidget {
  const DetailWriter({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'by 수줍은',
      style: const TextStyle(fontSize: 16, color: Colors.grey),
    );
  }
}

// 키워드
class DetailKeyword extends StatelessWidget {
  const DetailKeyword({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '#계절 #봄',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }
}

// 본문
class DetailContent extends StatelessWidget {
  final String content;

  const DetailContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(fontSize: 18, height: 1.5),
      textAlign: TextAlign.center,
    );
  }
}
