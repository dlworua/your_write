import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/my_profile/widgets/tap_filter.dart';
import 'widgets/profile_header.dart';
import 'widgets/post_grid.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _myPosts = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserAndPosts();
  }

  Future<void> _loadUserAndPosts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _error = '로그인된 사용자가 없습니다.';
        _loading = false;
      });
      return;
    }

    try {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      final nickname = userDoc.data()?['nickname'] ?? '';

      if (nickname.isEmpty) {
        setState(() {
          _error = '닉네임 정보가 없습니다.';
          _loading = false;
        });
        return;
      }

      final collections = ['ai_writes', 'random_writes', 'home_posts'];
      List<Map<String, dynamic>> allPosts = [];

      for (final col in collections) {
        final query =
            await FirebaseFirestore.instance
                .collection(col)
                .where('nickname', isEqualTo: nickname)
                .get();

        final posts =
            query.docs.map((doc) {
              final data = doc.data();

              DateTime? date;
              if (data['date'] is Timestamp) {
                date = (data['date'] as Timestamp).toDate();
              } else if (data['date'] is DateTime) {
                date = data['date'] as DateTime;
              }

              return {
                'title': data['title'] ?? '',
                'writer': data['nickname'] ?? '',
                'content': data['content'] ?? '',
                'date':
                    date != null
                        ? '${date.year}년 ${date.month}월 ${date.day}일'
                        : '',
              };
            }).toList();

        allPosts.addAll(posts);
      }

      // 날짜 문자열 -> DateTime 으로 변환 후 내림차순 정렬
      allPosts.sort((a, b) {
        DateTime dateA = _parseDate(a['date']);
        DateTime dateB = _parseDate(b['date']);
        return dateB.compareTo(dateA);
      });

      setState(() {
        _userData = userDoc.data();
        _myPosts = allPosts;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = '데이터 불러오기 실패: $e';
        _loading = false;
      });
    }
  }

  DateTime _parseDate(String dateStr) {
    // "2024년 6월 27일" -> DateTime 변환
    try {
      final parts = dateStr
          .replaceAll('년', '')
          .replaceAll('월', '')
          .replaceAll('일', '')
          .split(' ');
      if (parts.length < 3) return DateTime(1970);
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return DateTime(1970);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(body: Center(child: Text(_error!)));
    }

    if (_userData == null) {
      return const Scaffold(body: Center(child: Text('사용자 데이터를 찾을 수 없습니다.')));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text('마이페이지'),
        backgroundColor: const Color(0xFFFF8A65),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
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
          ProfileHeader(
            nickname: _userData?['nickname'] ?? '',
            email: _userData?['email'] ?? '',
          ),
          FilterTabs(count: _myPosts.length),
          Expanded(child: PostGrid(items: _myPosts)),
        ],
      ),
    );
  }
}
