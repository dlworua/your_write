import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/home/widgets/home_post_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              children: [
                Column(
                  children: [
                    HomePostWidget(),
                    SizedBox(height: 30),
                    HomePostWidget(),
                    SizedBox(height: 30),
                    HomePostWidget(),
                    SizedBox(height: 30),
                    HomePostWidget(),
                    SizedBox(height: 30),
                    HomePostWidget(),
                    SizedBox(height: 30),
                    HomePostWidget(),
                    SizedBox(height: 30),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
