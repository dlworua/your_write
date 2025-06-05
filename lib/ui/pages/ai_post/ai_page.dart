import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/ai_post/widgets/ai_post_list.dart';

class AiPage extends StatelessWidget {
  const AiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFFDF4),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/appbar_logo.png'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [AiPostList()],
            ),
          ),
        ],
      ),
    );
  }
}
