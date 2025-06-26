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
        crossAxisSpacing: 16,
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
        const SizedBox(height: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.favorite_border, size: 25),
            SizedBox(width: 15),
            Icon(Icons.chat_outlined, size: 25),
            SizedBox(width: 15),
            Icon(Icons.share, size: 25),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 20),
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
