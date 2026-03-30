import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';
import 'package:your_write/ui/pages/ai/ai_write/ai_write_service.dart';
import 'package:your_write/ui/pages/ai/ai_write/ai_write_viewmodel.dart';
import 'package:your_write/ui/pages/ai/ai_write/saved_ai_writes_provider.dart';

class AiWritePage extends ConsumerStatefulWidget {
  /// null이면 신규 글쓰기, 값이 있으면 수정 모드
  final WriteModel? editPost;

  const AiWritePage({super.key, this.editPost});

  @override
  ConsumerState<AiWritePage> createState() => _AiWritePageState();
}

class _AiWritePageState extends ConsumerState<AiWritePage> {
  late final TextEditingController titleController;
  late final TextEditingController keywordController;
  late final TextEditingController authorController;
  late final TextEditingController contentController;
  late final TextEditingController promptController;

  bool get _isEditMode => widget.editPost != null;

  final List<String> _loadingMessages = [
    'AI가 생각을 시작하고 있어요...',
    '아이디어를 정리하는 중...',
    '글을 써 내려가는 중...',
    '마무리 손질 중...',
  ];
  int _loadingMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    final post = widget.editPost;
    titleController = TextEditingController(text: post?.title ?? '');
    keywordController = TextEditingController(text: post?.keyWord ?? '');
    authorController = TextEditingController(text: post?.nickname ?? '');
    contentController = TextEditingController(text: post?.content ?? '');
    promptController = TextEditingController();

    if (!_isEditMode) {
      AiWriteService().warmUp();
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 3));
        if (!mounted) return false;
        setState(() {
          _loadingMessageIndex =
              (_loadingMessageIndex + 1) % _loadingMessages.length;
        });
        return true;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    keywordController.dispose();
    authorController.dispose();
    contentController.dispose();
    promptController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 본문은 필수입니다.')),
      );
      return;
    }

    if (_isEditMode) {
      // 수정 모드
      final updated = widget.editPost!.copyWith(
        title: titleController.text.trim(),
        keyWord: keywordController.text.trim(),
        nickname: authorController.text.trim(),
        content: contentController.text.trim(),
      );
      await ref.read(aiWriterServiceProvider).updatePost(updated);
      // 로컬 상태 반영
      final posts = ref.read(savedAiWritesProvider);
      ref.read(savedAiWritesProvider.notifier).setPosts(
        posts.map((p) => p.id == updated.id ? updated : p).toList(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('수정되었습니다')),
        );
        Navigator.pop(context, updated);
      }
    } else {
      // 신규 모드
      final newPost = WriteModel(
        id: '',
        title: titleController.text.trim(),
        keyWord: keywordController.text.trim(),
        nickname: authorController.text.trim(),
        content: contentController.text.trim(),
        date: DateTime.now(),
        type: PostType.ai,
        uid: FirebaseAuth.instance.currentUser?.uid ?? '',
      );
      final postId = await ref.read(savedAiWritesProvider.notifier).publish(newPost);
      if (postId != null && postId.isNotEmpty && mounted) {
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('출간에 실패했습니다')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(aiWriteViewModelProvider);
    final viewModel = ref.read(aiWriteViewModelProvider.notifier);

    // AI 생성 결과를 필드에 반영 (신규 모드만)
    if (!_isEditMode) {
      ref.listen<AsyncValue<WriteModel>>(aiWriteViewModelProvider, (prev, next) {
        next.whenOrNull(
          data: (data) {
            if (titleController.text != data.title) titleController.text = data.title;
            if (keywordController.text != data.keyWord) keywordController.text = data.keyWord;
            if (contentController.text != data.content) contentController.text = data.content;
          },
          error: (e, _) {
            if (context.mounted) {
              final message = e.toString().replaceFirst('Exception: ', '');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: Colors.red[400],
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          },
        );
      });
    }

    final isLoading = !_isEditMode && asyncValue.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF4),
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'AI 글 수정' : 'AI 글쓰기',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
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
      body: isLoading
          ? Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFD4B5A0).withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE8D5C4).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD4A574), Color(0xFFB8860B)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _loadingMessages[_loadingMessageIndex],
                      style: const TextStyle(
                        color: Color(0xFF6B4E3D),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  // AI 생성 섹션 (신규 모드만 표시)
                  if (!_isEditMode) ...[
                    _buildSectionHeader('✨ AI에게 요청하기', Icons.auto_awesome),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: promptController,
                      label: '프롬프트',
                      hint: 'AI에게 글쓰기 요청을 해보세요! (10자 이상)\n(예: "자연과 사랑에 대한 시 한 편 써줘")',
                      maxLines: 3,
                      icon: Icons.chat_bubble_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildActionButton(
                      text: 'AI 글 생성',
                      icon: Icons.auto_awesome,
                      onPressed: () {
                        final prompt = promptController.text.trim();
                        if (prompt.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('프롬프트를 입력하세요')),
                          );
                          return;
                        }
                        if (prompt.length < 10) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('프롬프트는 10자 이상 입력해주세요'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }
                        viewModel.generateContentFromPrompt(prompt);
                      },
                    ),
                    const SizedBox(height: 32),
                  ],

                  // 글 정보 섹션
                  _buildSectionHeader('📝 글 정보', Icons.edit_note),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: titleController,
                    label: '제목',
                    icon: Icons.title,
                    onChanged: _isEditMode ? null : (v) => viewModel.updateFields(title: v),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: keywordController,
                    label: '키워드 (예: 자연, 사랑 등)',
                    icon: Icons.tag,
                    onChanged: _isEditMode ? null : (v) => viewModel.updateFields(keyWord: v),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: authorController,
                    label: '작가명',
                    icon: Icons.person_outline,
                    onChanged: _isEditMode ? null : (v) => viewModel.updateFields(author: v),
                  ),
                  const SizedBox(height: 32),

                  // 본문 섹션
                  _buildSectionHeader('📖 본문', Icons.article),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: contentController,
                    label: '본문 내용',
                    maxLines: 8,
                    icon: Icons.description,
                    // 수정 모드에서는 본문도 편집 가능
                    readOnly: false,
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
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    bool readOnly = false,
    void Function(String)? onChanged,
    IconData? icon,
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
        readOnly: readOnly,
        onChanged: onChanged,
        maxLines: maxLines,
        style: TextStyle(
          color: readOnly ? const Color(0xFF8B6F47) : const Color(0xFF5D4E42),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            color: const Color(0xFF8B6F47).withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: const Color(0xFF8B6F47).withOpacity(0.4),
            fontSize: 14,
            height: 1.4,
          ),
          prefixIcon: icon != null
              ? Icon(icon, color: const Color(0xFF8B6F47), size: 20)
              : null,
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
            horizontal: icon != null ? 16 : 20,
            vertical: maxLines > 1 ? 20 : 18,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF0E6D2),
        border: Border.all(color: const Color(0xFFD4B5A0).withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF8B6F47), size: 20),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF6B4E3D),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
