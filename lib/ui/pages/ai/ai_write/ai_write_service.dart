import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:your_write/data/models/write_model.dart';

/// Provider로 AiWriterService를 앱 전체에서 사용할 수 있게 등록
final aiWriterServiceProvider = Provider<AiWriteService>((ref) {
  return AiWriteService();
});

/// 실제 Gemini API를 통해 글 생성 작업을 처리하는 서비스 클래스
class AiWriteService {
  final _firestore = FirebaseFirestore.instance;

  /// 🔄 Firestore에서 ai 타입 게시글을 가져오는 메서드
  Future<List<WriteModel>> fetchAiPosts() async {
    final snapshot =
        await _firestore
            .collection('ai_writes')
            .where('type', isEqualTo: 'ai')
            .orderBy('date', descending: true)
            .get();

    return snapshot.docs
        // ignore: unnecessary_null_comparison
        .where((doc) => doc.data() != null)
        .map(
          (doc) => WriteModel.fromMap(doc.data(), docId: doc.id), // ✅ 문서 ID 추가
        )
        .toList();
  }

  /// 🤖 Gemini 모델 인스턴스 (Flash 모델 사용)
  final _model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
  );

  /// 📝 프롬프트로부터 제목, 키워드, 본문을 생성하고 Write 객체로 반환
  Future<WriteModel> generateStructuredText(String prompt) async {
    print('✍️ Gemini 요청: $prompt');

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '응답이 비어 있습니다.';
      print('✅ Gemini 응답: $text');

      final lines =
          text
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

      String title = '';
      String keyword = '';
      final contentBuffer = <String>[];

      for (final line in lines) {
        final lower = line.toLowerCase();

        if (lower.startsWith('제목:') || lower.startsWith('title:')) {
          title = line.split(':').sublist(1).join(':').trim();
        } else if (lower.startsWith('제목 -')) {
          title = line.split('-').sublist(1).join('-').trim();
        } else if (RegExp(r'^#{1,3}\s*').hasMatch(line)) {
          // Markdown 형식 제목: # 제목, ## 제목
          title = line.replaceFirst(RegExp(r'^#{1,3}\s*'), '').trim();
        } else if (lower.startsWith('키워드:') || lower.startsWith('keywords:')) {
          keyword = line.split(':').sublist(1).join(':').trim();
        } else {
          contentBuffer.add(line);
        }
      }

      final content = contentBuffer.join('\n').trim();

      // 키워드 자동 생성
      if (keyword.isEmpty && content.isNotEmpty) {
        final words =
            content
                .replaceAll(RegExp(r'[^\uAC00-\uD7A3a-zA-Z\s]'), '')
                .split(' ')
                .where((w) => w.length > 1)
                .toList();

        final wordFrequency = <String, int>{};
        for (var word in words) {
          wordFrequency[word] = (wordFrequency[word] ?? 0) + 1;
        }

        final sorted =
            wordFrequency.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

        final topKeywords = sorted.take(3).map((e) => e.key).toList();
        keyword = topKeywords.join(', ');
      }

      // 제목 없을 경우 첫 줄로 대체
      if (title.isEmpty && contentBuffer.isNotEmpty) {
        title = contentBuffer.first.split(' ').take(5).join(' ').trim();
      }

      print('📄 제목: $title');
      print('🔑 키워드: $keyword');
      print('📝 본문:\n$content');

      return WriteModel(
        id: '',
        title: title,
        keyWord: keyword,
        nickname: '',
        content: content,
        date: DateTime.now(),
        type: PostType.ai,
      );
    } catch (e) {
      throw Exception('Gemini API 에러: $e');
    }
  }
}
