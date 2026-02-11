import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Cloud Functions 테스트 페이지
/// 목적: generateAI 함수가 정상적으로 작동하는지 확인
class TestCloudFunctionPage extends StatefulWidget {
  const TestCloudFunctionPage({super.key});

  @override
  State<TestCloudFunctionPage> createState() => _TestCloudFunctionPageState();
}

class _TestCloudFunctionPageState extends State<TestCloudFunctionPage> {
  final TextEditingController _promptController = TextEditingController();
  String _result = '';
  bool _isLoading = false;
  String _error = '';

  // Cloud Functions 인스턴스
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'asia-northeast3', // 서울 리전
  );

  @override
  void initState() {
    super.initState();
    // 테스트용 기본 프롬프트
    _promptController.text = '안녕하세요! 간단한 자기소개를 작성해주세요.';
  }

  /// Cloud Function 호출 테스트
  Future<void> _testCloudFunction() async {
    setState(() {
      _isLoading = true;
      _error = '';
      _result = '';
    });

    try {
      // 1. 인증 확인
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다. 먼저 로그인해주세요.');
      }

      print('🔐 현재 사용자: ${user.uid}');
      print('✍️ 프롬프트: ${_promptController.text}');

      // 2. Cloud Function 호출
      final callable = _functions.httpsCallable('generateAI');
      final result = await callable.call<Map<String, dynamic>>({
        'prompt': _promptController.text,
      });

      // 3. 결과 처리
      final data = result.data;
      print('✅ 응답 데이터: $data');

      if (data['success'] == true) {
        setState(() {
          _result = data['text'] ?? '결과가 없습니다.';
          _isLoading = false;
        });
      } else {
        throw Exception('AI 생성 실패');
      }
    } on FirebaseFunctionsException catch (e) {
      // Firebase Functions 에러
      print('❌ Functions 에러: ${e.code} - ${e.message}');
      setState(() {
        _error = '에러 코드: ${e.code}\n메시지: ${e.message}';
        _isLoading = false;
      });
    } catch (e) {
      // 기타 에러
      print('❌ 에러: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Function 테스트'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 현재 사용자 정보
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '현재 사용자: ${FirebaseAuth.instance.currentUser?.email ?? "로그인 필요"}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),

            // 프롬프트 입력
            TextField(
              controller: _promptController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: '프롬프트 (10-5000자)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'AI에게 요청할 내용을 입력하세요...',
              ),
            ),
            const SizedBox(height: 16),

            // 테스트 버튼
            ElevatedButton(
              onPressed: _isLoading ? null : _testCloudFunction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Cloud Function 호출',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
            const SizedBox(height: 24),

            // 결과 표시
            if (_error.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '❌ 에러 발생',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),

            if (_result.isNotEmpty)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '✅ AI 생성 결과',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _result,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
