import 'package:flutter/material.dart';

// 프로필 상단 정보 위젯
class ProfileHeader extends StatelessWidget {
  final String nickname; // 사용자 닉네임
  final String email; // 사용자 이메일

  const ProfileHeader({super.key, required this.nickname, required this.email});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20), // 전체 패딩 설정
      child: Column(
        children: [
          const Text(
            'My Profile', // 프로필 제목 텍스트
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12), // 간격
          // 프로필 이미지 배경 테두리 + 그라데이션 효과
          Container(
            padding: const EdgeInsets.all(3), // 이미지와 테두리 사이 여백
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  Color(0xff4dabf7), // 파랑
                  Color(0xffda77f2), // 보라
                  Color(0xfff783ac), // 핑크
                ],
              ),
              borderRadius: BorderRadius.circular(500), // 완전한 원 형태
            ),
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/app_logo.png'), // 앱 로고 이미지 사용
              radius: 40, // 프로필 이미지 크기
            ),
          ),
          const SizedBox(height: 8), // 간격
          // 닉네임 출력
          Text(
            nickname,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // 이메일 출력 (회색 텍스트)
          Text(email, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12), // 간격
          // 팔로잉/팔로워/작품수 표시 영역 (현재 주석 처리됨)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              // _FollowInfo(title: '팔로잉', count: 0),
              SizedBox(width: 16),
              // _FollowInfo(title: '팔로워', count: 0),
              SizedBox(width: 16),
              // _FollowInfo(title: '작품수', count: 4),
            ],
          ),
          const SizedBox(height: 12), // 간격
          // 프로필 편집 버튼
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/edit-profile'); // 편집 페이지로 이동
            },
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
}
