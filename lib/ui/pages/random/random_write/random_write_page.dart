// lib/ui/pages/random/random_write/random_write_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';
import 'package:your_write/ui/pages/random/random_write/random_write_service.dart';
import 'package:your_write/ui/pages/random/random_write/random_write_viewmodel.dart';
import 'package:your_write/ui/pages/random/random_write/saved_random_writes_provider.dart';

class RandomWritePage extends ConsumerStatefulWidget {
  /// null이면 신규 글쓰기, 값이 있으면 수정 모드
  final WriteModel? editPost;

  const RandomWritePage({super.key, this.editPost});

  @override
  ConsumerState<RandomWritePage> createState() => _RandomWritePageState();
}

class _RandomWritePageState extends ConsumerState<RandomWritePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _contentController;

  int _keywordCount = 3;

  bool get _isEditMode => widget.editPost != null;

  @override
  void initState() {
    super.initState();
    final post = widget.editPost;
    _titleController = TextEditingController(text: post?.title ?? '');
    _authorController = TextEditingController(text: post?.nickname ?? '');
    _contentController = TextEditingController(text: post?.content ?? '');

    if (!_isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(randomWriteViewModelProvider.notifier)
            .generateKeywords(_keywordCount);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 본문은 필수입니다.')),
      );
      return;
    }

    if (_isEditMode) {
      // 수정 모드
      final updated = widget.editPost!.copyWith(
        title: title,
        nickname: author.isEmpty ? widget.editPost!.nickname : author,
        content: content,
      );
      await ref.read(randomWriteServiceProvider).updatePost(updated);
      // 로컬 상태 반영
      final posts = ref.read(savedRandomWritesProvider);
      ref.read(savedRandomWritesProvider.notifier).setPosts(
        posts.map((p) => p.id == updated.id ? updated : p).toList(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('수정되었습니다')),
        );
        Navigator.pop(context, updated);
      }
    } else {
      // 신규 모드: 키워드 포함 여부 검사
      final keywords = ref.read(randomWriteViewModelProvider).keywords;
      final allIncluded = keywords.every(
        (k) => content.toLowerCase().contains(k.toLowerCase().trim()),
      );
      if (!allIncluded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모든 키워드를 본문에 포함해주세요.')),
        );
        return;
      }

      final viewModel = ref.read(randomWriteViewModelProvider.notifier);
      viewModel.updateFields(title: title, author: author, content: content);
      final docId = await viewModel.saveRandomPostToFirestore();
      if (docId != null && mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 신규 모드: ViewModel 상태 동기화
    if (!_isEditMode) {
      final state = ref.watch(randomWriteViewModelProvider);
      if (_titleController.text != state.title && state.title.isNotEmpty) {
        _titleController.text = state.title;
      }
      if (_authorController.text != state.author && state.author.isNotEmpty) {
        _authorController.text = state.author;
      }
      if (_contentController.text != state.content && state.content.isNotEmpty) {
        _contentController.text = state.content;
      }
    }

    final keywords = _isEditMode
        ? (widget.editPost!.keyWord.split(',').map((k) => k.trim()).toList())
        : ref.watch(randomWriteViewModelProvider).keywords;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF4),
      appBar: AppBar(
        title: Text(_isEditMode ? '글 수정' : '랜덤 키워드 글쓰기'),
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
            // 키워드 섹션
            _buildSectionHeader('🎲 키워드', Icons.shuffle),
            const SizedBox(height: 12),
            _isEditMode
                ? _buildEditModeKeywords(keywords)
                : _buildRandomKeywordField(keywords),
            const SizedBox(height: 32),

            // 글 정보 섹션
            _buildSectionHeader('📝 글 정보', Icons.edit_note),
            const SizedBox(height: 12),
            _buildTextField(_titleController, '제목'),
            const SizedBox(height: 16),
            _buildTextField(_authorController, '작가명'),
            const SizedBox(height: 32),

            // 본문 섹션
            _buildSectionHeader('📖 본문', Icons.description),
            const SizedBox(height: 12),
            _buildTextField(_contentController, '본문 내용', maxLines: 10),
            const SizedBox(height: 32),

            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  /// 수정 모드: 기존 키워드를 읽기 전용으로 표시
  Widget _buildEditModeKeywords(List<String> keywords) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4B5A0).withOpacity(0.4)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: keywords.map((k) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0E6D2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD4B5A0).withOpacity(0.5)),
            ),
            child: Text(
              k,
              style: const TextStyle(
                color: Color(0xFF6B4E3D),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 신규 모드: 랜덤 키워드 생성 UI
  Widget _buildRandomKeywordField(List<String> keywords) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4B5A0).withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              keywords.join(', '),
              style: const TextStyle(
                color: Color(0xFF5D4E42),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          DropdownButton<int>(
            value: _keywordCount,
            underline: const SizedBox(),
            items: [1, 2, 3, 4, 5]
                .map((e) => DropdownMenuItem(value: e, child: Text('$e개')))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => _keywordCount = val);
                ref
                    .read(randomWriteViewModelProvider.notifier)
                    .generateKeywords(val);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF8B6F47)),
            onPressed: () => ref
                .read(randomWriteViewModelProvider.notifier)
                .generateKeywords(_keywordCount),
          ),
        ],
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
