import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 제목
class AiDetailTitle extends StatelessWidget {
  final String title;

  const AiDetailTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
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
      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
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
      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
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
      style: TextStyle(fontSize: 18.sp, height: 1.5),
      textAlign: TextAlign.center,
    );
  }
}
