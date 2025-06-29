import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PostGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  // items에 각 글의 타입을 'home', 'ai', 'random'으로 명시해주세요.
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

        // 날짜가 DateTime일 수도, String일 수도 있으니 DateTime으로 파싱
        DateTime parsedDate;
        if (item['sortDate'] is DateTime) {
          parsedDate = item['sortDate'];
        } else if (item['sortDate'] is String) {
          parsedDate = DateTime.tryParse(item['sortDate']) ?? DateTime.now();
        } else {
          parsedDate = DateTime.now();
        }

        return GestureDetector(
          onTap: () {
            final type = item['type'] ?? 'home';

            if (type == 'ai') {
              Navigator.pushNamed(
                context,
                '/ai-detail',
                arguments: {
                  'postId': item['id'] ?? '',
                  'title': item['title'] ?? '',
                  'content': item['content'] ?? '',
                  'author': item['writer'] ?? '',
                  'keywords': item['keywords']?.cast<String>() ?? [],
                  'date': parsedDate,
                  'scrollToCommentOnLoad': false,
                },
              );
            } else if (type == 'random') {
              Navigator.pushNamed(
                context,
                '/random-detail',
                arguments: {
                  'postId': item['id'] ?? '',
                  'title': item['title'] ?? '',
                  'content': item['content'] ?? '',
                  'author': item['writer'] ?? '',
                  'keyword': item['keywords'] ?? '',
                  'date': parsedDate,
                  'focusOnComment': false,
                },
              );
            } else {
              // 기본값 home
              Navigator.pushNamed(
                context,
                '/home-detail',
                arguments: {
                  'postId': item['id'] ?? '',
                  'title': item['title'] ?? '',
                  'content': item['content'] ?? '',
                  'author': item['writer'] ?? '',
                  'keyword': item['keywords'] ?? '',
                  'date': parsedDate,
                  'scrollToCommentInput': false,
                },
              );
            }
          },
          child: _PostCard(
            title: item['title'] ?? '',
            writer: item['writer'] ?? '',
            content: item['content'] ?? '',
            date: parsedDate,
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
  final DateTime date;

  const _PostCard({
    required this.title,
    required this.writer,
    required this.content,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";

    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.brown,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  writer,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                AutoSizeText(
                  content,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.brown),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, size: 12, color: Colors.brown),
                const SizedBox(width: 6),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 11, color: Colors.brown),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
