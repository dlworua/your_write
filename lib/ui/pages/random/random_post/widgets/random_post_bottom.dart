import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/random/random_post/widgets/random_post_keyword.dart';

class RandomPostBottom extends StatelessWidget {
  final List<String> keywords;

  const RandomPostBottom({super.key, required this.keywords});

  @override
  Widget build(BuildContext context) {
    // 쉼표로 나눈 리스트로 변환
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFF5F1EB).withOpacity(0.3), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // 🍂 키워드 섹션
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD2B48C).withOpacity(0.8),
                      const Color(0xFFDDBEA9).withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  '🍂 랜덤 인용구',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 👉 가로 스크롤 키워드
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        keywords
                            .map(
                              (k) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: RandomPostKeyword(keyword: k),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          // 💬 아이콘 버튼들
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconOnlyButton(
                Icons.favorite_border_rounded,
                '37',
                const Color(0xFFD2691E),
              ),
              _buildIconOnlyButton(
                Icons.chat_bubble_outline_rounded,
                '326',
                const Color(0xFF4682B4),
              ),
              _buildIconOnlyButton(
                Icons.share_outlined,
                '',
                const Color(0xFF8FBC8F),
              ),
              _buildIconOnlyButton(
                Icons.bookmark_outline_rounded,
                '',
                const Color(0xFFDDA0DD),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconOnlyButton(IconData icon, String count, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        if (count.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text(
            count,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5D4037),
            ),
          ),
        ],
      ],
    );
  }
}
