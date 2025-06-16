import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/random/random_post/widgets/random_post_keyword.dart';

class RandomPostBottom extends StatelessWidget {
  final List<String> keywords;

  const RandomPostBottom({super.key, required this.keywords});

  @override
  Widget build(BuildContext context) {
    // 쉼표로 나눈 리스트로 변환
    return Container(
      height: 80,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 10),

              const Text('랜덤 인용구 : ', style: TextStyle(fontSize: 12)),
              Expanded(
                child: Wrap(
                  spacing: 6,
                  children:
                      keywords.map((k) {
                        // ignore: avoid_print
                        print('[랜덤포스트 키워드 리스트] "$k"');
                        return RandomPostKeyword(keyword: k);
                      }).toList(),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only()),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite_border_rounded),
              ),
              Text('37'),
              IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
              Text('326'),
              IconButton(onPressed: () {}, icon: Icon(Icons.share)),

              IconButton(
                onPressed: () {},
                icon: Icon(Icons.bookmark_outline_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
