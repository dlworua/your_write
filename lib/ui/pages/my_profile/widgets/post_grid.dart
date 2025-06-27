import 'package:auto_size_text/auto_size_text.dart';
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
    return Expanded(
      child: Column(
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
                    fontSize: 12, // 글씨 크기 줄임
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // 닉네임 한줄, 줄바꿈없이 ...
                Text(
                  writer,
                  style: const TextStyle(fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                AutoSizeText(
                  content,
                  textAlign: TextAlign.center,
                  maxLines: 4, // 최대 4줄까지
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10), // 글씨 크기 줄임
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('작성 날짜', style: TextStyle(fontSize: 10)),
                const SizedBox(width: 10),
                Text(date, style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
