import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';

final aiWriterServiceProvider = Provider<AiWriteService>((ref) {
  return AiWriteService();
});

class AiWriteService {
  final _firestore = FirebaseFirestore.instance;
  final _functions = FirebaseFunctions.instanceFor(region: 'asia-northeast3');

  // Cold Start 보완: AI 탭 진입 시 미리 웜업
  Future<void> warmUp() async {
    try {
      // 짧은 더미 호출로 함수 웜업 (실패해도 무시)
      final callable = _functions.httpsCallable(
        'generateAI',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 3)),
      );
      await callable.call({'prompt': 'warmup'});
    } catch (_) {
      // 웜업 실패는 무시 (프롬프트 검증 에러 포함)
    }
  }

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
        .map((doc) => WriteModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  Future<WriteModel> generateStructuredText(String prompt) async {
    print('✍️ Cloud Function 요청: $prompt');

    try {
      final callable = _functions.httpsCallable(
        'generateAI',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 60)),
      );

      final result = await callable.call<Map<dynamic, dynamic>>({
        'prompt': prompt,
      });

      final data = Map<String, dynamic>.from(result.data);
      final text = data['text'] as String? ?? '응답이 비어 있습니다.';
      print('✅ Cloud Function 응답: $text');

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
    } on FirebaseFunctionsException catch (e) {
      print('❌ Cloud Function 에러: ${e.code} - ${e.message}');
      // 사용자 친화적 에러 메시지
      String message;
      switch (e.code) {
        case 'unauthenticated':
          message = '로그인이 필요합니다.';
          break;
        case 'invalid-argument':
          message = e.message ?? '입력값이 올바르지 않습니다.';
          break;
        case 'resource-exhausted':
          message = 'API 할당량이 초과되었습니다. 잠시 후 다시 시도해주세요.';
          break;
        default:
          message = e.message ?? 'AI 생성 중 오류가 발생했습니다.';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('AI 생성 중 오류가 발생했습니다: $e');
    }
  }
}
