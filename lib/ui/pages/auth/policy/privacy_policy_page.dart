// 개인정보 보호정책
import 'package:flutter/material.dart';
import 'markdown_viewer.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MarkdownViewer(
      title: '개인정보 보호정책',
      assetPath: 'assets/policies/privacy_policy.md',
    );
  }
}
