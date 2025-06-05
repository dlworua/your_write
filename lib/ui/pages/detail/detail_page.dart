import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});
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
                Text(
                  '나의 여름',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'by 수줍은',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Text(
                  '#계절 #봄',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(height: 32, thickness: 2),
                Text(
                  '나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n나의 여름은 어디에 갔나\n 나의 여름은 떠나고\n 가을의 쓸쓸함이 날 기다리네\n ',
                  style: const TextStyle(fontSize: 18, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                Divider(height: 32, thickness: 2),
                const SizedBox(height: 24),
                TextField(
                  decoration: InputDecoration(
                    hintText: '댓글을 입력하세요',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🔽 댓글 리스트
                const Text(
                  '댓글',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '익명 $index',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text('정말 좋은 글이에요. 마음이 따뜻해졌어요 :)'),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
