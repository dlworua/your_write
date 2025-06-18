import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write.dart';
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

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    keywordController = TextEditingController();
    authorController = TextEditingController();
    contentController = TextEditingController();
    promptController = TextEditingController();
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

    // ViewModel의 상태가 변경될 때, 텍스트 필드에 값을 자동으로 업데이트
    ref.listen<AsyncValue<Write>>(aiWriteViewModelProvider, (previous, next) {
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
          // 작가명은 유저가 직접 입력하기 때문에 자동 설정 X
        },
        loading: () {}, // 로딩 중일 때는 별도 처리 없음
        error: (e, st) {
          print('❌ 에러: $e'); // 에러 발생 시 콘솔에 메세지 출력
        },
      );
    });

    // 글 출간 버튼 클릭 시 호출되는 함수
    void submitPost() async {
      if (titleController.text.isEmpty || contentController.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('제목과 본문은 필수입니다.')));
        return;
      }

      final newPost = Write(
        title: titleController.text.trim(),
        keyWord: keywordController.text.trim(),
        nickname: authorController.text.trim(),
        content: contentController.text.trim(),
        date: DateTime.now(),
        type: PostType.ai,
      );

      // 로컬 상태 추가
      await ref.read(savedAiWritesProvider.notifier).publish(newPost);

      // Firestore 저장
      await viewModel.publishWrite();

      // 이전 화면으로 이동
      if (context.mounted) {
        Navigator.pop(context);
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF4),
      appBar: AppBar(
        title: const Text('AI 글쓰기'),
        backgroundColor: const Color(0xFFFFFDF4),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body:
          asyncValue.isLoading
              // 로딩 중에 로딩 인디케이터 표시
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    // 사용자가 AI에게 요청을 입력하는 프롬프트 필드
                    TextField(
                      controller: promptController,
                      decoration: const InputDecoration(
                        labelText: '프롬프트',
                        hintText:
                            'AI에게 글쓰기 요청을 해보세요!\n(예: “자연과 사랑에 대한 시 한 편 써줘”)',
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    // 프롬프트를 기반으로 AI 글을 생성하는 버튼
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.lightGreen[100],
                        ),
                        foregroundColor: WidgetStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        if (promptController.text.trim().isEmpty) {
                          // 프롬프트가 비어있으면 알림
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('프롬프트를 입력하세요')),
                          );
                          return;
                        }
                        // 프롬프트를 넘겨주어 AI 글 생성
                        viewModel.generateContentFromPrompt(
                          promptController.text,
                        );
                      },
                      child: const Text('AI 글 생성'),
                    ),
                    const SizedBox(height: 24),
                    // 제목 필드 (AI가 생성, 수정 가능)
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: '제목'),
                      onChanged:
                          (value) => viewModel.updateFields(title: value),
                    ),
                    const SizedBox(height: 12),
                    // 키워드 필드 (직접 입력, ai생성 가능하나 아직 구현 못함..)
                    TextField(
                      controller: keywordController,
                      decoration: const InputDecoration(
                        hintText: '키워드 (예: 자연, 사랑 등)',
                      ),
                      onChanged:
                          (value) => viewModel.updateFields(keyWord: value),
                    ),
                    const SizedBox(height: 12),
                    // 작가명은 사용자가 직접 입력
                    TextField(
                      controller: authorController,
                      decoration: const InputDecoration(hintText: '작가명'),
                      onChanged:
                          (value) => viewModel.updateFields(author: value),
                    ),
                    const SizedBox(height: 12),
                    // 본문 내용 표시 필드 (AI가 생성, 수정 불가)
                    TextField(
                      controller: contentController,
                      readOnly: true,
                      maxLines: 8,
                      decoration: const InputDecoration(hintText: '본문 내용'),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        // ignore: await_only_futures
                        await ref.read(savedAiWritesProvider.notifier);
                        submitPost();
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen[200],
                        foregroundColor: Colors.blueGrey[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        '출간 하기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
