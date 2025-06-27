import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/auth/policy/marketing_agreement_page.dart';
import 'package:your_write/ui/pages/auth/policy/privacy_policy_page.dart';
import 'package:your_write/ui/pages/auth/policy/terms_of_service_page.dart';

class AgreementPage extends StatefulWidget {
  const AgreementPage({super.key});

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  // 동의 상태 변수들
  bool agreeAll = false; // 전체 동의 여부
  bool agreeTerms = false; // 이용약관 동의 (필수)
  bool agreePrivacy = false; // 개인정보처리방침 동의 (필수)
  bool agreeMarketing = false; // 마케팅 정보 수신 동의 (선택)

  // 전체 동의 상태 변경 시 모든 개별 약관 동의 상태 업데이트
  void _updateAll(bool value) {
    setState(() {
      agreeAll = value;
      agreeTerms = value;
      agreePrivacy = value;
      agreeMarketing = value;
    });
  }

  // 개별 약관 상태 변경 시 전체 동의 상태 재계산
  void _updateIndividual() {
    setState(() {
      // 전체 동의는 개별 약관 모두 동의해야 true
      agreeAll = agreeTerms && agreePrivacy && agreeMarketing;
    });
  }

  // 각 약관 '보기' 버튼 클릭 시 해당 약관 페이지로 이동
  void _showPolicyPage(String title) {
    Widget page;
    switch (title) {
      case '이용약관':
        page = const TermsOfServicePage();
        break;
      case '개인정보처리방침':
        page = const PrivacyPolicyPage();
        break;
      case '마케팅 동의':
        page = const MarketingAgreementPage();
        break;
      default:
        return; // 잘못된 타이틀이면 아무 동작 안 함
    }
    // 페이지 푸시 (새 화면으로 이동)
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    // 다음 버튼 활성 조건: 필수 약관 2개 모두 동의했을 때
    final isNextEnabled = agreeTerms && agreePrivacy;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // 따뜻한 크림색 배경
      appBar: AppBar(
        title: const Text(
          "📝 약관 동의",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent, // 투명 배경
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFAB91), Color(0xFFFFAB91)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // 뒤로가기 아이콘 버튼
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 웰컴 메시지 영역
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFCC80).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '☕️ 잠깐!',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Colors.brown,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '서비스 이용을 위해\n몇 가지 약관에 동의해주세요\n\n안전하고 따뜻한 공간을 위해서예요 🌸',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.brown,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 전체 동의 선택 카드
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFFFAB91), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFAB91).withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    // 전체 동의 토글 (전체 카드 탭 시)
                    onTap: () => _updateAll(!agreeAll),
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // 체크박스 디자인
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color:
                                  agreeAll
                                      ? const Color(0xFFFF8A65)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFFF8A65),
                                width: 2,
                              ),
                            ),
                            child:
                                agreeAll
                                    ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                    : null,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            '✨ 전체 동의하기',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF5D4037),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 개별 약관 동의 카드들
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD7CCC8).withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 이용약관 동의 카드 (필수)
                    _buildAgreementCard(
                      checked: agreeTerms,
                      title: '이용약관 동의',
                      isRequired: true,
                      icon: Icons.description_outlined,
                      onChanged: (val) {
                        setState(() => agreeTerms = val!);
                        _updateIndividual(); // 개별 변경 시 전체 상태 재계산
                      },
                      onViewPressed: () => _showPolicyPage('이용약관'),
                    ),
                    // 개인정보처리방침 동의 카드 (필수)
                    _buildAgreementCard(
                      checked: agreePrivacy,
                      title: '개인정보처리방침',
                      isRequired: true,
                      icon: Icons.privacy_tip_outlined,
                      onChanged: (val) {
                        setState(() => agreePrivacy = val!);
                        _updateIndividual();
                      },
                      onViewPressed: () => _showPolicyPage('개인정보처리방침'),
                    ),
                    // 마케팅 정보 수신 동의 카드 (선택)
                    _buildAgreementCard(
                      checked: agreeMarketing,
                      title: '마케팅 정보 수신 동의',
                      isRequired: false,
                      icon: Icons.campaign_outlined,
                      onChanged: (val) {
                        setState(() => agreeMarketing = val!);
                        _updateIndividual();
                      },
                      onViewPressed: () => _showPolicyPage('마케팅 동의'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 다음 버튼 (필수 약관 동의 시 활성화)
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient:
                      isNextEnabled
                          ? const LinearGradient(
                            colors: [Color(0xFFFFAB91), Color(0xFFFF8A65)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                  color: isNextEnabled ? null : const Color(0xFFD7CCC8),
                  boxShadow:
                      isNextEnabled
                          ? [
                            BoxShadow(
                              color: const Color(0xFFFFAB91).withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ]
                          : null,
                ),
                child: ElevatedButton(
                  onPressed:
                      isNextEnabled
                          ? () {
                            Navigator.pushNamed(
                              context,
                              '/signup',
                              arguments: {
                                'agreeMarketing': agreeMarketing,
                              }, // 선택 동의 상태 전달
                            );
                          }
                          : null, // 비활성화 시 null 처리
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // 그라데이션 살리기 위해 투명 배경
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    isNextEnabled ? '🌟 다음으로' : '필수 약관에 동의해주세요',
                    style: TextStyle(
                      fontSize: isNextEnabled ? 19 : 16,
                      fontWeight: FontWeight.w700,
                      color:
                          isNextEnabled
                              ? Colors.white
                              : const Color(0xFF8D6E63),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // 개별 약관 동의 카드 위젯 생성 함수
  Widget _buildAgreementCard({
    required bool checked, // 체크 상태
    required String title, // 약관 제목
    required bool isRequired, // 필수 여부
    required IconData icon, // 왼쪽 아이콘
    required ValueChanged<bool?> onChanged, // 체크박스 변경 콜백
    required VoidCallback onViewPressed, // '보기' 버튼 클릭 콜백
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: checked ? const Color(0xFFFFF3E0) : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: checked ? const Color(0xFFFFAB91) : const Color(0xFFEEEEEE),
          width: checked ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // 카드 전체 탭 시 체크박스 토글
          onTap: () => onChanged(!checked),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 체크박스 커스텀 디자인
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color:
                        checked ? const Color(0xFFFF8A65) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          checked
                              ? const Color(0xFFFF8A65)
                              : const Color(0xFFBCAAA4),
                      width: 2,
                    ),
                  ),
                  child:
                      checked
                          ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 16,
                          )
                          : null,
                ),
                const SizedBox(width: 12),

                // 약관 아이콘
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color:
                        checked
                            ? const Color(0xFFFF8A65).withOpacity(0.15)
                            : const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color:
                        checked
                            ? const Color(0xFFFF8A65)
                            : const Color(0xFFBCAAA4),
                  ),
                ),
                const SizedBox(width: 12),

                // 제목 및 필수/선택 라벨
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              checked
                                  ? const Color(0xFF5D4037)
                                  : const Color(0xFF8D6E63),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isRequired
                                  ? const Color(0xFFFFAB91).withOpacity(0.2)
                                  : const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isRequired ? '필수' : '선택',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color:
                                isRequired
                                    ? const Color(0xFFD84315)
                                    : const Color(0xFF8D6E63),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // '보기' 버튼
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE0B2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: onViewPressed,
                    child: const Text(
                      '보기',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5D4037),
                      ),
                    ),
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
