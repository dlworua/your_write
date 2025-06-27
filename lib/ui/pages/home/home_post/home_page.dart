import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/home/home_post/widgets/home_post_list.dart';
import 'package:your_write/ui/pages/home/home_write/home_write_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFDF4),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              const Color(0XFFFFFDF4),
              const Color(0xFFF5F1EB).withOpacity(0.6),
              const Color(0xFFFAF6F0).withOpacity(0.4),
            ],
          ),
        ),
        child: Column(
          children: [
            // 앱바 영역
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0XFFFFFDF4),
                    Colors.brown[50]!.withOpacity(0.8),
                    const Color(0xFFF5F1EB).withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Image.asset('assets/appbar_logo.png'),
                  Positioned(
                    top: 75,
                    right: 25,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeWritePage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 11,
                          right: 11,
                          top: 6,
                          bottom: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFD2B48C).withOpacity(0.9),
                              const Color(0xFFDDBEA9).withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.withOpacity(0.25),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.create_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '글쓰기',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 글 목록
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: HomePostList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
