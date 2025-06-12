import 'package:flutter/material.dart';

// 제목
class AiDetailTitle extends StatelessWidget {
  const AiDetailTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '나의 여름',
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
  const AiDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n ',
      style: const TextStyle(fontSize: 18, height: 1.5),
      textAlign: TextAlign.center,
    );
  }
}
