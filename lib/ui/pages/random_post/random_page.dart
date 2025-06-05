import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/random_post/widgets/random_post_list.dart';

class RandomPage extends StatelessWidget {
  const RandomPage({super.key});

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
              children: [RandomPostList()],
            ),
          ),
        ],
      ),
    );
  }
}
