import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/ui/pages/main_page.dart';

void main() {
  print(const String.fromEnvironment('GEMINI_API_KEY'));
  runApp(ProviderScope(child: MyApp()));
}

// 뷰모델에 ai로직 하나 만들어서 확인해보기 완
// 로직 작성 완
// 테스트 완
// 뷰모델 작성 완
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainPage());
  }
}
