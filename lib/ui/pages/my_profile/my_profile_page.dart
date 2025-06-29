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
      if (mounted) {
        setState(() {
          _error = '로그인된 사용자가 없습니다.';
          _loading = false;
        });
      }
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
        if (mounted) {
          setState(() {
            _error = '닉네임 정보가 없습니다.';
            _loading = false;
          });
        }
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
              final rawDate = data['date'];
              DateTime? date;

              if (rawDate is Timestamp) {
                date = rawDate.toDate();
              } else if (rawDate is DateTime) {
                date = rawDate;
              } else if (rawDate is String) {
                try {
                  date = DateTime.parse(rawDate);
                } catch (_) {
                  date = DateTime(1970);
                }
              }

              return {
                'title': data['title'] ?? '',
                'writer': data['nickname'] ?? '',
                'content': data['content'] ?? '',
                'date': date != null ? _formatKoreanDateTime(date) : '',
                'sortDate': date ?? DateTime(1970),
              };
            }).toList();

        allPosts.addAll(posts);
      }

      allPosts.sort((a, b) {
        return (b['sortDate'] as DateTime).compareTo(a['sortDate'] as DateTime);
      });

      if (mounted) {
        setState(() {
          _userData = userDoc.data();
          _myPosts = allPosts;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '데이터 불러오기 실패: $e';
          _loading = false;
        });
      }
    }
  }

  String _formatKoreanDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    return '${local.year}년 ${local.month}월 ${local.day}일';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFDF6E3),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              color: Color(0xFFD4AF37),
              strokeWidth: 3,
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFDF6E3),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFCD853F).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              _error!,
              style: const TextStyle(
                color: Color(0xFF8B4513),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (_userData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFDF6E3),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFCD853F).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              '사용자 데이터를 찾을 수 없습니다.',
              style: TextStyle(
                color: Color(0xFF8B4513),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E3),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          '마이페이지',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 142, 132, 101),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 213, 180, 158), Color(0xFFE6CCB2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.logout_rounded, size: 20),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (_) => false,
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDF6E3), Color(0xFFFAF0E6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFFD4AF37).withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            ProfileHeader(
              nickname: _userData?['nickname'] ?? '',
              email: _userData?['email'] ?? '',
            ),
            FilterTabs(count: _myPosts.length),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCD853F).withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: PostGrid(items: _myPosts),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
