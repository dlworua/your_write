import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/auth/policy/markdown_viewer.dart';

class MarketingAgreementPage extends StatelessWidget {
  const MarketingAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MarkdownViewer(
      title: '마케팅 동의',
      assetPath: 'assets/policies/marketing_agreement.md',
    );
  }
}
