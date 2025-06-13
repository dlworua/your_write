import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/ai_write.dart';
import 'package:your_write/ui/pages/ai/ai_write/ai_write_service.dart';

// ViewModel을 상태로 관리하는 Riverpod Provider
// 상태 타입은 [AsyncValue<AiWrite>], 비동기 작업 처리와 에러 핸들링을 위해 사용
final aiWriteViewModelProvider =
    StateNotifierProvider<AiWriteViewModel, AsyncValue<AiWrite>>(
      (ref) => AiWriteViewModel(ref),
    );

// AI 글쓰기 기능을 담당하는 ViewModel
// 상태는 AiWrite 모델을 감싸는 AsyncValue
class AiWriteViewModel extends StateNotifier<AsyncValue<AiWrite>> {
  final Ref ref;

  AiWriteViewModel(this.ref)
    : super(
        AsyncValue.data(
          AiWrite(
            title: '',
            keyWord: '',
            nickname: '',
            content: '',
            date: DateTime.now(),
          ),
        ),
      );

  // 사용자가 입력한 프롬프트를 기반으로 AI 글 생성을 요청
  /// 결과로 생성된 제목, 키워드, 본문을 state에 저장
  /// 기존에 입력된 작가명(author)은 유지
  Future<void> generateContentFromPrompt(String prompt) async {
    state = const AsyncValue.loading();

    try {
      // 서비스에서 실제 AI 결과 받아오기
      final aiWrite = await ref
          .read(aiWriterServiceProvider)
          .generateStructuredText(prompt);

      // 현재 상태에서 author(작가명)는 유지
      final current =
          state.value ??
          AiWrite(
            title: '',
            keyWord: '',
            nickname: '',
            content: '',
            date: DateTime.now(),
          );

      // AI가 생성한 데이터에 기존 author를 유지한 새 객체 생성
      final updated = aiWrite.copyWith(author: current.nickname);

      // 새로운 상태를 반영
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // 개별 필드 값(title, keyWord, author, content)을 업데이트
  // null이 아닌 값만 업데이트되고 나머지는 기존 값 유지
  void updateFields({
    String? title,
    String? keyWord,
    String? author,
    String? content,
  }) {
    final current =
        state.value ??
        AiWrite(
          title: '',
          keyWord: '',
          nickname: '',
          content: '',
          date: DateTime.now(),
        );

    // 전달된 필드 값만 변경하여 새로운 AiWrite 객체 생성
    state = AsyncValue.data(
      current.copyWith(
        title: title,
        keyWord: keyWord,
        author: author,
        content: content,
      ),
    );
  }
}
