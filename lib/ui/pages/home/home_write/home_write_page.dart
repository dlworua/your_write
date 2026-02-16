import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/home_post_model.dart';
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

  void _submitPost() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final keyword = _keywordController.text.trim();
    final author =
        _authorController.text.trim().isEmpty
            ? '익명'
            : _authorController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('제목과 본문은 필수입니다.')));
      return;
    }

    final newPost = HomePostModel(
      id: '', // id는 Firestore에서 자동 생성됨
      title: title,
      content: content,
      keyword: keyword,
      author: author,
      date: DateTime.now(),
      uid: FirebaseAuth.instance.currentUser?.uid ?? '',
    );

    await ref.read(homePostListProvider.notifier).addPost(newPost);
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
        backgroundColor: const Color(0xFFFFFDF4),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _buildSectionHeader('📝 글 정보', Icons.edit_note),
            const SizedBox(height: 12),
            _buildTextField(_titleController, '제목'),
            const SizedBox(height: 16),
            _buildTextField(_keywordController, '키워드 (예: 사랑, 자유 등)'),
            const SizedBox(height: 16),
            _buildTextField(_authorController, '작가명'),
            const SizedBox(height: 32),
            _buildSectionHeader('📖 본문', Icons.article),
            const SizedBox(height: 12),
            _buildTextField(
              _contentController,
              '작가님의 이야기를 들려주세요 :)',
              maxLines: 10,
            ),
            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.lightGreen[50]!,
            Colors.lightGreen[100]!.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.lightGreen[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.lightGreen[600], size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      onPressed: _submitPost,
      icon: const Icon(Icons.publish),
      label: const Text(
        '출간 하기',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightGreen[300],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
