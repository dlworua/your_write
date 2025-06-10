import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/home/widgets/home_post_list.dart';
import 'package:your_write/ui/pages/write/main_write_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFFDF4),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Image.asset('assets/appbar_logo.png'),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MainWritePage();
                      },
                    ),
                  );
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 85, left: 325),
                      child: Icon(Icons.edit, size: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 315),
                      child: Text(
                        '글쓰기',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [HomePostList()],
            ),
          ),
        ],
      ),
    );
  }
}
