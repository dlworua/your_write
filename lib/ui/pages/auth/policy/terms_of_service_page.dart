// 이용약관 페이지
import 'package:flutter/material.dart';
import 'markdown_viewer.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MarkdownViewer(
      title: '이용약관',
      assetPath: 'assets/policies/terms_of_service.md',
    );
  }
}
