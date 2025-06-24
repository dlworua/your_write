// ui/pages/random/random_write/random_write_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';
import 'package:your_write/ui/pages/ai/ai_write/saved_ai_writes_provider.dart';
import 'package:your_write/ui/pages/random/random_write/random_write_viewmodel.dart';

class RandomWritePage extends ConsumerStatefulWidget {
  const RandomWritePage({super.key});

  @override
  ConsumerState<RandomWritePage> createState() => _RandomWritePageState();
}

class _RandomWritePageState extends ConsumerState<RandomWritePage> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();
  final _keywordController = TextEditingController();

  int _keywordCount = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(randomWriteViewModelProvider.notifier)
          .generateKeywords(_keywordCount);
    });
  }

  void _submitPost() async {
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();
    final content = _contentController.text.trim();
    final keywords = ref.read(randomWriteViewModelProvider).keywords;

    final allIncluded = keywords.every(
      (k) => content.toLowerCase().contains(k.toLowerCase().trim()),
    );

    if (!allIncluded) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('모든 키워드를 본문에 포함해주세요.')));
      return;
    }

    final viewModel = ref.read(randomWriteViewModelProvider.notifier);
    viewModel.updateFields(title: title, author: author, content: content);

    await viewModel.saveRandomPostToFirestore();

    ref
        .read(savedAiWritesProvider.notifier)
        .publish(
          WriteModel(
            id: '',
            title: title,
            keyWord: keywords.join(','),
            nickname: author,
            content: content,
            date: DateTime.now(),
            type: PostType.random,
          ),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(randomWriteViewModelProvider);
    final keywords = state.keywords;
    _keywordController.text = keywords.join(', ');

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF4),
      appBar: AppBar(
        title: const Text('랜덤 키워드 글쓰기'),
        backgroundColor: const Color(0xFFFFFDF4),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _buildSectionHeader('🎲 랜덤 키워드', Icons.shuffle),
            const SizedBox(height: 12),
            _buildKeywordField(keywords),
            const SizedBox(height: 32),
            _buildSectionHeader('📝 글 정보', Icons.edit_note),
            const SizedBox(height: 12),
            _buildTextField(_titleController, '제목'),
            const SizedBox(height: 16),
            _buildTextField(_authorController, '작가명'),
            const SizedBox(height: 32),
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

  Widget _buildKeywordField(List<String> keywords) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.lightGreen.shade200),
      ),
      child: Row(
        children: [
          Expanded(child: Text(keywords.join(', '))),
          DropdownButton<int>(
            value: _keywordCount,
            items:
                [1, 2, 3, 4, 5]
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
            icon: const Icon(Icons.refresh),
            onPressed:
                () => ref
                    .read(randomWriteViewModelProvider.notifier)
                    .generateKeywords(_keywordCount),
          ),
        ],
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
