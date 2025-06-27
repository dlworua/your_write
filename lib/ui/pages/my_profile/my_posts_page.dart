// 내가 쓴글 불러오기
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPostsPage extends StatelessWidget {
  const MyPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid; // 현재 로그인한 사용자 UID 가져오기

    if (uid == null) {
      // 로그인된 사용자가 없는 경우 메시지 표시
      return const Center(child: Text('로그인된 사용자 없음'));
    }

    // Firestore에서 현재 사용자가 작성한 글(writes 컬렉션)을 불러오기 위한 쿼리
    final postsRef = FirebaseFirestore.instance
        .collection('writes')
        .where('uid', isEqualTo: uid) // uid가 현재 사용자와 같은 문서만
        .orderBy('createdAt', descending: true); // 최신순 정렬

    return Scaffold(
      appBar: AppBar(title: const Text('내가 쓴 글')), // 상단 앱바 제목

      body: StreamBuilder<QuerySnapshot>(
        stream: postsRef.snapshots(), // 실시간으로 글 목록 불러오기
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            // 로딩 중일 때 로딩 인디케이터 표시
            return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs; // 불러온 문서 목록

          if (docs.isEmpty) {
            // 작성한 글이 없을 때 메시지
            return const Center(child: Text('작성한 글이 없습니다.'));
          }

          // 작성한 글 리스트 출력
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data =
                  docs[index].data()
                      as Map<String, dynamic>; // 문서 데이터를 Map으로 변환
              return ListTile(
                title: Text(data['title'] ?? '제목 없음'), // 글 제목 표시
                subtitle: Text(
                  data['content']?.toString().substring(0, 50) ??
                      '', // 본문 일부 표시 (최대 50자)
                ),
              );
            },
          );
        },
      ),
    );
  }
}
