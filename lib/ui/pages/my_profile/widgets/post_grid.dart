import 'package:flutter/material.dart';

class PostGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const PostGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(5),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/detail',
              arguments: {
                'title': item['title'],
                'content': item['content'],
                'writer': item['writer'],
                'date': item['date'],
              },
            );
          },
          child: _PostCard(
            title: item['title'],
            writer: item['writer'],
            content: item['content'],
            date: item['date'],
          ),
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
          height: 160,
          width: 160,
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14, // 글씨 크기 줄임
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // 닉네임 한줄, 줄바꿈없이 ...
              Text(
                writer,
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                content,
                textAlign: TextAlign.center,
                maxLines: 4, // 최대 4줄까지
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13), // 글씨 크기 줄임
              ),
            ],
          ),
        ),
        // const SizedBox(height: 4),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: const [
        //     Icon(Icons.favorite_border, size: 22),
        //     SizedBox(width: 15),
        //     Icon(Icons.chat_outlined, size: 22),
        //     SizedBox(width: 15),
        //     Icon(Icons.share, size: 22),
        //   ],
        // ),
        // const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('작성 날짜', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 15),
              Text(date, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
