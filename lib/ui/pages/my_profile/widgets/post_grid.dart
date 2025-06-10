import 'package:flutter/material.dart';

class PostGrid extends StatelessWidget {
  const PostGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': '사진',
        'writer': '수줍은',
        'content': '나의 손이 닿는 대로\n나의 눈이 닿는 대로',
        'date': '2024년 9월 8일',
      },
      {
        'title': '노을',
        'writer': '수줍은',
        'content': '해외 경전철...\n순수한 빛깔',
        'date': '2024년 9월 8일',
      },
      {
        'title': '겨울',
        'writer': '수줍은',
        'content': '겨울 햇살 아래...',
        'date': '2024년 9월 8일',
      },
      {
        'title': '가로등',
        'writer': '수줍은',
        'content': '밤거리를 함께 비추다',
        'date': '2024년 9월 8일',
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        // mainAxisSpacing: 40,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _PostCard(
          title: item['title']!,
          writer: item['writer']!,
          content: item['content']!,
          date: item['date']!,
        );
      },
    );
  }
}

class _PostCard extends StatelessWidget {
  final String title;
  final String writer;
  final String content;
  final String date;

  const _PostCard({
    required this.title,
    required this.writer,
    required this.content,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 170,
          width: 170,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(50),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 95),
                child: Text(writer, style: const TextStyle(fontSize: 12)),
              ),
              const SizedBox(height: 8),
              Text(content, textAlign: TextAlign.center),
            ],
          ),
        ),
        SizedBox(height: 10),
        // 아이콘
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.favorite_border),
            Icon(Icons.chat_outlined),
            Icon(Icons.share),
          ],
        ),
        const SizedBox(height: 4),
        //  작성날짜
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('작성 날짜', style: TextStyle(fontSize: 12)),
              SizedBox(width: 15),
              Text(date, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
