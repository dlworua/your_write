import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:your_write/data/models/write.dart';

/// Provider로 AiWriterService를 앱 전체에서 사용할 수 있게 등록
final aiWriterServiceProvider = Provider<AiWriterService>((ref) {
  return AiWriterService();
});

/// 실제 Gemini API를 통해 글 생성 작업을 처리하는 서비스 클래스
class AiWriterService {
  // Gemini 모델 인스턴스 생성 (Flash 모델 사용)
  final _model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
  );

  /// 사용자로부터 전달받은 프롬프트로부터 AiWrite 객체 생성
  Future<Write> generateStructuredText(String prompt) async {
    print('✍️ Gemini 요청: $prompt');

    try {
      // emini API에 텍스트 프롬프트 전송
      final response = await _model.generateContent([Content.text(prompt)]);
      // 응답 본문 (텍스트) 가져오기
      final text = response.text ?? '응답이 비어 있습니다.';
      print('✅ Gemini 응답: $text');

      // 응답 텍스트를 줄 단위로 분리하고, 공백 제거
      final lines =
          text
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

      // 제목과 키워드 추출을 위한 변수 초기화
      String title = '';
      String keyword = '';
      int startIndex = 0; // 본문 시작 위치를 추적

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.toLowerCase().startsWith('제목:')) {
          // '제목:' 형식일 경우 추출
          title =
              line
                  .replaceFirst(RegExp(r'제목:\s*', caseSensitive: false), '')
                  .trim();
          startIndex = i + 1;
        } else if (line.toLowerCase().startsWith('키워드:')) {
          // '키워드:' 형식일 경우 추출
          keyword =
              line
                  .replaceFirst(RegExp(r'키워드:\s*', caseSensitive: false), '')
                  .trim();
          startIndex = i + 1;
        } else if (line.startsWith('## ') || line.startsWith('# ')) {
          // 제목이 Markdown 스타일로 왔을 경우
          title = line.replaceFirst(RegExp(r'^#+\s*'), '').trim();
          startIndex = i + 1;
        } else {
          // 위 조건에 해당하지 않을 시 루프 종료
          break;
        }
      }

      // 본문 줄 추출 (제목/키워드 이후)
      final contentLines = lines.sublist(startIndex);
      final content = contentLines.join('\n').trim();

      // AiWrite 모델로 묶어서 반환
      return Write(
        title: title,
        keyWord: keyword,
        nickname: '', // 작성자는 ViewModel에서 따로 설정함
        content: content,
        date: DateTime.now(),
        type: PostType.ai,
      );
    } catch (e) {
      // 예외 발생 시 에러 던지기
      throw Exception('Gemini API 에러: $e');
    }
  }
}
