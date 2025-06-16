import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/home_post.dart';
import 'package:your_write/ui/pages/home/home_post/home_view_model.dart';

class HomeWritePage extends ConsumerStatefulWidget {
  const HomeWritePage({super.key});

  @override
  ConsumerState<HomeWritePage> createState() => _HomeWritePageState();
}

class _HomeWritePageState extends ConsumerState<HomeWritePage> {
  final _titleController = TextEditingController();
  final _keywordController = TextEditingController();
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();

  void _submitPost() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final keyword = _keywordController.text.trim();
    final author =
        _authorController.text.trim().isEmpty ? '익명' : _authorController.text;

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('제목과 본문은 필수입니다.')));
      return;
    }

    ref
        .read(homePostListProvider.notifier)
        .addPost(
          HomePost(
            title: title,
            content: content,
            keyword: keyword,
            author: author,
          ),
        );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _keywordController.dispose();
    _authorController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF4),
      appBar: AppBar(
        title: const Text('자유 글쓰기'),
        backgroundColor: Color(0xFFFFFDF4),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: '제목'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _keywordController,
              decoration: InputDecoration(hintText: '키워드 (예: 자연, 사랑 등)'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(hintText: '작가명'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(hintText: '작가님의 이야기를 들려주세요:)'),
              keyboardType: TextInputType.multiline,
              maxLines: 12,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen[200],
                foregroundColor: Colors.blueGrey[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                '출간 하기',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
