import 'package:flutter/material.dart';

class AiWritePage extends StatefulWidget {
  const AiWritePage({super.key});

  @override
  State<AiWritePage> createState() => _WritePageState();
}

class _WritePageState extends State<AiWritePage> {
  final _titleController = TextEditingController();
  final _keywordController = TextEditingController();
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _keywordController.dispose();
    _authorController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitPost() {
    final title = _titleController.text;
    final keyword = _keywordController.text;
    final author = _authorController.text;
    final content = _contentController.text;

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('제목과 본문은 필수입니다.')));
      return;
    }

    // TODO: 저장 또는 게시 처리 (MVVM 연결 가능)

    Navigator.pop(context); // 저장 후 이전 화면으로
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF4),
      appBar: AppBar(
        title: const Text('AI 글쓰기'),
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
              decoration: InputDecoration(
                hintText: 'AI에게 글쓰기 요청을 해보세요!\n(예: “자연과 사랑에 대한 시 한 편 써줘”)',
              ),
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
