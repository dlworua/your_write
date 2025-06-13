import 'package:flutter/material.dart';

// 제목
class AiDetailTitle extends StatelessWidget {
  final String title;

  const AiDetailTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}

// 작성자
class AiDetailWriter extends StatelessWidget {
  const AiDetailWriter({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'by 수줍은',
      style: const TextStyle(fontSize: 16, color: Colors.grey),
    );
  }
}

// 키워드
class AiDetailKeyword extends StatelessWidget {
  const AiDetailKeyword({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '#계절 #봄',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }
}

// 본문
class AiDetailContent extends StatelessWidget {
  final String content;
  const AiDetailContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(fontSize: 18, height: 1.5),
      textAlign: TextAlign.center,
    );
  }
}
