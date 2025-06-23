import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class AgreementPage extends StatefulWidget {
  const AgreementPage({super.key});

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  bool agreeAll = false;
  bool agreeTerms = false; // (필수)
  bool agreePrivacy = false; // (필수)
  bool agreeMarketing = false; // (선택)

  void _updateAll(bool value) {
    setState(() {
      agreeAll = value;
      agreeTerms = value;
      agreePrivacy = value;
      agreeMarketing = value;
    });
  }

  void _updateIndividual() {
    setState(() {
      agreeAll = agreeTerms && agreePrivacy && agreeMarketing;
    });
  }

  void _showWebview(String title, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => Scaffold(
              appBar: AppBar(
                title: Text(title),
                backgroundColor: const Color(0xFFFF8A65),
                foregroundColor: Colors.white,
              ),
              // body: WebView(
              //   initialUrl: url,
              //   javascriptMode: JavascriptMode.unrestricted,
              // ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNextEnabled = agreeTerms && agreePrivacy;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text("약관 동의"),
        backgroundColor: const Color(0xFFFF8A65),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '서비스 이용을 위해\n약관에 동의해주세요',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 30),

            // 전체 동의
            CheckboxListTile(
              value: agreeAll,
              onChanged: (val) => _updateAll(val!),
              title: const Text(
                '전체 동의',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const Divider(),

            // 개별 약관
            _buildCheckTile(
              value: agreeTerms,
              title: '이용약관 동의 (필수)',
              onChanged: (val) {
                setState(() => agreeTerms = val!);
                _updateIndividual();
              },
              onViewPressed:
                  () => _showWebview('이용약관', 'https://yourdomain.com/terms'),
            ),
            _buildCheckTile(
              value: agreePrivacy,
              title: '개인정보처리방침 (필수)',
              onChanged: (val) {
                setState(() => agreePrivacy = val!);
                _updateIndividual();
              },
              onViewPressed:
                  () => _showWebview(
                    '개인정보처리방침',
                    'https://yourdomain.com/privacy',
                  ),
            ),
            _buildCheckTile(
              value: agreeMarketing,
              title: '마케팅 정보 수신 동의 (선택)',
              onChanged: (val) {
                setState(() => agreeMarketing = val!);
                _updateIndividual();
              },
              onViewPressed:
                  () => _showWebview(
                    '마케팅 동의',
                    'https://yourdomain.com/marketing',
                  ),
            ),
            const Spacer(),

            // 다음 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isNextEnabled
                        ? () {
                          // 다음 회원가입 단계로 이동
                          Navigator.pushNamed(context, '/signup');
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isNextEnabled ? const Color(0xFFFF8A65) : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('다음'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckTile({
    required bool value,
    required String title,
    required ValueChanged<bool?> onChanged,
    required VoidCallback onViewPressed,
  }) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
        TextButton(onPressed: onViewPressed, child: const Text('보기')),
      ],
    );
  }
}
