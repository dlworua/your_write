import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';
import 'package:your_write/ui/pages/ai/ai_write/ai_write_service.dart';
import 'package:your_write/ui/pages/ai/ai_write/ai_write_viewmodel.dart';
import 'package:your_write/ui/pages/ai/ai_write/saved_ai_writes_provider.dart';

class AiWritePage extends ConsumerStatefulWidget {
  const AiWritePage({super.key});

  @override
  ConsumerState<AiWritePage> createState() => _AiWritePageState();
}

class _AiWritePageState extends ConsumerState<AiWritePage> {
  // 각 TextField에 연결되는 컨트롤러
  late final TextEditingController titleController;
  late final TextEditingController keywordController;
  late final TextEditingController authorController;
  late final TextEditingController contentController;
  late final TextEditingController promptController;

  // 로딩 메시지 (Cold Start 체감 개선)
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
    titleController = TextEditingController();
    keywordController = TextEditingController();
    authorController = TextEditingController();
    contentController = TextEditingController();
    promptController = TextEditingController();
    // Cold Start 보완: 페이지 진입 시 Cloud Function 미리 웜업
    AiWriteService().warmUp();
    // 로딩 메시지 주기적 변경 타이머
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

  @override
  void dispose() {
    // 메모리 누수를 방지하기 위한 컨트롤러 해제
    titleController.dispose();
    keywordController.dispose();
    authorController.dispose();
    contentController.dispose();
    promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(aiWriteViewModelProvider);
    final viewModel = ref.read(aiWriteViewModelProvider.notifier);

    ref.listen<AsyncValue<WriteModel>>(aiWriteViewModelProvider, (
      previous,
      next,
    ) {
      next.when(
        data: (data) {
          if (titleController.text != data.title) {
            titleController.text = data.title;
          }
          if (keywordController.text != data.keyWord) {
            keywordController.text = data.keyWord;
          }
          if (contentController.text != data.content) {
            contentController.text = data.content;
          }
        },
        loading: () {},
        error: (e, st) {
          print('❌ 에러: $e');
        },
      );
    });

    void submitPost() async {
      if (titleController.text.isEmpty || contentController.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('제목과 본문은 필수입니다.')));
        return;
      }

      final newPost = WriteModel(
        id: '',
        title: titleController.text.trim(),
        keyWord: keywordController.text.trim(),
        nickname: authorController.text.trim(),
        content: contentController.text.trim(),
        date: DateTime.now(),
        type: PostType.ai,
      );

      final postId = await ref
          .read(savedAiWritesProvider.notifier)
          .publish(newPost); // 여기서 Firestore 저장 + id 리턴

      if (postId != null && postId.isNotEmpty && context.mounted) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('출간에 실패했습니다')));
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF4), // 원래 밝은 배경
      appBar: AppBar(
        title: const Text(
          'AI 글쓰기',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: const Color(0xFFFFFDF4),
        foregroundColor: Colors.black,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withOpacity(0.1)),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body:
          asyncValue.isLoading
              ? Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.1),
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
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.lightGreen[300]!,
                              Colors.lightGreen[400]!,
                            ],
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
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFDF4), // 원래 배경색
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ListView(
                    children: [
                      // AI 프롬프트 섹션
                      _buildSectionHeader('✨ AI에게 요청하기', Icons.auto_awesome),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: promptController,
                        label: '프롬프트',
                        hint: 'AI에게 글쓰기 요청을 해보세요!\n(예: "자연과 사랑에 대한 시 한 편 써줘")',
                        maxLines: 3,
                        icon: Icons.chat_bubble_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildButton(
                        text: 'AI 글 생성',
                        onPressed: () {
                          if (promptController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('프롬프트를 입력하세요')),
                            );
                            return;
                          }
                          viewModel.generateContentFromPrompt(
                            promptController.text,
                          );
                        },
                        icon: Icons.auto_awesome,
                      ),

                      const SizedBox(height: 32),

                      // 글 정보 섹션
                      _buildSectionHeader('📝 글 정보', Icons.edit_note),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: titleController,
                        label: '제목',
                        onChanged: (v) => viewModel.updateFields(title: v),
                        icon: Icons.title,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: keywordController,
                        label: '키워드 (예: 자연, 사랑 등)',
                        onChanged: (v) => viewModel.updateFields(keyWord: v),
                        icon: Icons.tag,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: authorController,
                        label: '작가명',
                        onChanged: (v) => viewModel.updateFields(author: v),
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 32),

                      // 본문 섹션
                      _buildSectionHeader('📖 생성된 본문', Icons.article),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: contentController,
                        label: '본문 내용',
                        readOnly: true,
                        maxLines: 8,
                        icon: Icons.description,
                      ),

                      const SizedBox(height: 32),

                      _buildButton(
                        text: '출간 하기',
                        onPressed: () async {
                          await ref.read(savedAiWritesProvider.notifier);
                          submitPost();
                        },
                        isPrimary: true,
                        icon: Icons.publish,
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  // 섹션 헤더
  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
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
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  // 트렌디한 TextField
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
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
          color: readOnly ? Colors.grey[600] : Colors.grey[800],
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
            height: 1.4,
          ),
          prefixIcon:
              icon != null
                  ? Icon(icon, color: Colors.lightGreen[600], size: 20)
                  : null,
          filled: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.lightGreen[400]!, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: icon != null ? 16 : 20,
            vertical: maxLines > 1 ? 20 : 18,
          ),
        ),
      ),
    );
  }

  // 트렌디한 Button
  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = false,
    IconData? icon,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isPrimary
                  ? [Colors.lightGreen[300]!, Colors.lightGreen[400]!]
                  : [Colors.lightGreen[100]!, Colors.lightGreen[200]!],
        ),
        boxShadow: [
          if (isPrimary)
            BoxShadow(
              color: Colors.lightGreen[300]!.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
        ],
        border: isPrimary ? null : Border.all(color: Colors.lightGreen[300]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: isPrimary ? Colors.white : Colors.grey[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: isPrimary ? Colors.white : Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
