import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/home_post_model.dart';
import 'package:your_write/ui/pages/home/home_post/home_view_model.dart';

class HomeWritePage extends ConsumerStatefulWidget {
  /// null이면 신규 글쓰기, 값이 있으면 수정 모드
  final HomePostModel? editPost;

  const HomeWritePage({super.key, this.editPost});

  @override
  ConsumerState<HomeWritePage> createState() => _HomeWritePageState();
}

class _HomeWritePageState extends ConsumerState<HomeWritePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _keywordController;
  late final TextEditingController _authorController;
  late final TextEditingController _contentController;

  bool get _isEditMode => widget.editPost != null;

  @override
  void initState() {
    super.initState();
    final post = widget.editPost;
    _titleController = TextEditingController(text: post?.title ?? '');
    _keywordController = TextEditingController(text: post?.keyword ?? '');
    _authorController = TextEditingController(text: post?.author ?? '');
    _contentController = TextEditingController(text: post?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _keywordController.dispose();
    _authorController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final keyword = _keywordController.text.trim();
    final author =
        _authorController.text.trim().isEmpty
            ? '익명'
            : _authorController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 본문은 필수입니다.')),
      );
      return;
    }

    if (_isEditMode) {
      // 수정 모드: 기존 글 업데이트
      final updated = widget.editPost!.copyWith(
        title: title,
        content: content,
        keyword: keyword,
        author: author,
      );
      await ref.read(homePostListProvider.notifier).updatePost(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('수정되었습니다')),
        );
        Navigator.pop(context, updated); // 수정된 글 반환
      }
    } else {
      // 신규 모드: 새 글 추가
      final newPost = HomePostModel(
        id: '',
        title: title,
        content: content,
        keyword: keyword,
        author: author,
        date: DateTime.now(),
        uid: FirebaseAuth.instance.currentUser?.uid ?? '',
      );
      await ref.read(homePostListProvider.notifier).addPost(newPost);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF4),
      appBar: AppBar(
        title: Text(_isEditMode ? '글 수정' : '자유 글쓰기'),
        backgroundColor: const Color(0xFFFFFDF4),
        foregroundColor: const Color(0xFF6B4E3D),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0E6D2).withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
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
            const Color(0xFFF5EFE7),
            const Color(0xFFE8D5C4).withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4B5A0).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF8B6F47), size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF6B4E3D),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFD4B5A0).withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8D5C4).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          color: Color(0xFF5D4E42),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: const Color(0xFF8B6F47).withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          filled: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFD4B5A0), width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: maxLines > 1 ? 20 : 18,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD4A574), Color(0xFFB8860B)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4A574).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _submit,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isEditMode ? Icons.check_rounded : Icons.publish,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _isEditMode ? '수정 완료' : '출간 하기',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
