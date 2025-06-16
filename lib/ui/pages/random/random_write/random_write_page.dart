// UI 화면: 사용자가 제목/작가명/본문 작성 및 키워드 확인
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write.dart';
import 'package:your_write/ui/pages/ai/ai_write/saved_ai_writes_provider.dart';
import 'package:your_write/ui/pages/random/random_write/random_write_state.dart';

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
    // 화면이 그려진 뒤 키워드를 자동 생성
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(randomWriteViewModelProvider.notifier)
          .generateKeywords(_keywordCount);
    });
  }

  // 출간하기 버튼 클릭 시 실행되는 함수
  void _submitPost() {
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();
    final content = _contentController.text.trim();
    final keywords = ref.read(randomWriteViewModelProvider).keywords;

    // 본문에 모든 키워드가 포함되었는지 확인
    final allIncluded = keywords.every(
      (k) => content.toLowerCase().contains(k.toLowerCase().trim()),
    );

    if (!allIncluded) {
      // 포함되지 않으면 경고 표시
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('모든 키워드를 본문에 포함해주세요.')));
      return;
    }

    // 저장 및 화면 닫기
    ref
        .read(savedAiWritesProvider.notifier)
        .publish(
          Write(
            title: title,
            keyWord: keywords.join(','), // 키워드는 콤마로 구분 필수!
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
    // 키워드 텍스트 필드 업데이트
    _keywordController.text = keywords.join(', ');

    return Scaffold(
      appBar: AppBar(title: Text('랜덤 키워드 글쓰기')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // 키워드 출력 및 재생성
            TextField(
              controller: _keywordController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: '랜덤 키워드',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _keywordCount,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _keywordCount = val);
                            ref
                                .read(randomWriteViewModelProvider.notifier)
                                .generateKeywords(val);
                          }
                        },
                        items:
                            [1, 2, 3, 4, 5]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text('$e개'),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        ref
                            .read(randomWriteViewModelProvider.notifier)
                            .generateKeywords(_keywordCount);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: '제목'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(hintText: '작가명'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: InputDecoration(hintText: '키워드를 모두 포함해 자유롭게 작성해주세요.'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen[200],
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('출간하기', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
