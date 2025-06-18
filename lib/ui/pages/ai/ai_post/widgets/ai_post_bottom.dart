import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/ai/ai_post/widgets/ai_post_keyword.dart';

class AiPostBottom extends StatelessWidget {
  final List<String> keywords;

  const AiPostBottom({super.key, required this.keywords});

  @override
  Widget build(BuildContext context) {
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
              SizedBox(width: 12),

              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: const Text('AI 인용구 : ', style: TextStyle(fontSize: 12)),
              ),
              Expanded(
                child: Wrap(
                  spacing: 5,
                  children:
                      keywords.map((k) => AiPostKeyword(keyword: k)).toList(),
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
