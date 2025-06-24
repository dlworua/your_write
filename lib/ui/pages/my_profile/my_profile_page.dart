import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/my_profile/widgets/post_grid.dart';
import 'package:your_write/ui/pages/my_profile/widgets/profile_header.dart';
import 'package:your_write/ui/pages/my_profile/widgets/tap_filter.dart';

// 마이페이지 (내 프로필 페이지)
class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  // Firebase에서 현재 로그인된 사용자의 유저 정보를 불러오는 함수
  Future<Map<String, dynamic>?> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid; // 현재 사용자 UID
    if (uid == null) return null;

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get(); // Firestore에서 사용자 문서 가져오기
    return doc.data(); // 사용자 데이터 반환
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _loadUserData(), // 사용자 데이터를 불러옴
      builder: (context, snapshot) {
        // 데이터가 아직 없을 경우 로딩 표시
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), // 로딩 스피너
          );
        }

        final userData = snapshot.data!; // 데이터가 있을 경우

        return Scaffold(
          backgroundColor: const Color(0xFFFFF3E0), // 배경색 (연한 오렌지 계열)
          appBar: AppBar(
            title: const Text('마이페이지'), // 상단 앱바 제목
            backgroundColor: const Color(0xFFFF8A65), // 앱바 배경색
            foregroundColor: Colors.white, // 텍스트 및 아이콘 색상
            actions: [
              IconButton(
                icon: const Icon(Icons.logout), // 로그아웃 아이콘
                onPressed: () async {
                  // 로그아웃 처리
                  await FirebaseAuth.instance.signOut();
                  // 로그인 페이지로 이동하고 모든 이전 페이지 제거
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (_) => false,
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // 사용자 프로필 정보를 표시하는 위젯
              ProfileHeader(
                nickname: userData['nickname'] ?? '', // 닉네임
                email: userData['email'] ?? '', // 이메일
              ),
              const FilterTabs(), // 게시물 필터 탭 (예: 전체/AI글 등)
              Expanded(child: const PostGrid()), // 그리드 형태의 게시글 목록
            ],
          ),
        );
      },
    );
  }
}
