// 공통 마크다운 뷰어 위젯
import 'package:flutter/material.dart'; // Flutter UI 라이브러리 임포트
import 'package:flutter/services.dart'; // rootBundle 등 파일 시스템 접근용 임포트
import 'package:flutter_markdown/flutter_markdown.dart'; // 마크다운 렌더링 라이브러리 임포트

// MarkdownViewer 위젯 정의 (StatelessWidget)
class MarkdownViewer extends StatelessWidget {
  final String title; // 앱바에 표시할 제목
  final String assetPath; // 마크다운 파일 경로

  const MarkdownViewer({
    super.key,
    required this.title,
    required this.assetPath,
  });

  // 비동기 함수: 주어진 경로의 마크다운 파일을 로드
  Future<String> _loadMarkdown(String path) async {
    try {
      return await rootBundle.loadString(path); // 파일 문자열로 읽기
    } catch (e) {
      debugPrint('❌ Markdown 파일 불러오기 실패: $e'); // 에러 로그 출력
      return '문서를 불러올 수 없습니다.'; // 실패 시 표시할 텍스트
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)), // 앱바에 제목 표시
      body: FutureBuilder<String>(
        future: _loadMarkdown(assetPath), // 마크다운 파일 읽기 미래
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // 로딩 인디케이터
          }
          if (snapshot.hasError) {
            return const Center(child: Text('문서를 불러오는 데 실패했습니다.')); // 에러 텍스트
          }
          return Markdown(
            data: snapshot.data ?? '', // 마크다운 데이터
            styleSheet: MarkdownStyleSheet.fromTheme(
              Theme.of(context), // 현재 테마를 기반으로 스타일 시트 생성
            ).copyWith(
              p: const TextStyle(fontSize: 16, height: 1.5),
            ), // 단락 텍스트 스타일 수정
          );
        },
      ),
    );
  }
}
