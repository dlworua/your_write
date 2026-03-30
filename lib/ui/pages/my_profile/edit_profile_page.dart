import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nicknameController = TextEditingController();
  bool _isSaving = false;
  String _originalNickname = '';
  // ignore: unused_field
  bool _isNicknameAvailable = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _nicknameController.addListener(() {
      setState(() {
        _isNicknameAvailable = true; // 입력이 바뀌면 중복 상태 초기화
      });
    });
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      final nickname = doc.data()?['nickname'] ?? '';
      _nicknameController.text = nickname;
      _originalNickname = nickname;
    }
  }

  Future<bool> _checkNicknameDuplicate(String nickname) async {
    final query =
        await FirebaseFirestore.instance
            .collection('users')
            .where('nickname', isEqualTo: nickname)
            .get();

    if (query.docs.isEmpty) return true; // 사용 가능

    // 현재 로그인한 사용자의 닉네임이면 OK
    final user = FirebaseAuth.instance.currentUser;
    return query.docs.first.id == user?.uid;
  }

  /// 글 컬렉션에서 닉네임 일괄 업데이트
  Future<void> _updateNicknameInPosts(
      String uid, String oldNickname, String newNickname) async {
    final db = FirebaseFirestore.instance;
    final collections = {
      'home_posts': 'author',
      'ai_writes': 'nickname',
      'random_writes': 'nickname',
    };

    for (final entry in collections.entries) {
      final snapshot = await db
          .collection(entry.key)
          .where('uid', isEqualTo: uid)
          .get();

      if (snapshot.docs.isEmpty) continue;
      final batch = db.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {entry.value: newNickname});
      }
      await batch.commit();
    }
  }

  /// 좋아요 서브컬렉션에서 닉네임 일괄 업데이트
  Future<void> _updateNicknameInLikes(
      String uid, String oldNickname, String newNickname) async {
    final db = FirebaseFirestore.instance;

    // 모든 게시글 컬렉션을 순회하며 해당 유저의 좋아요를 찾아서 업데이트
    final collections = ['home_posts', 'ai_writes', 'random_writes'];

    for (final collectionName in collections) {
      final postsSnapshot = await db.collection(collectionName).get();

      for (final postDoc in postsSnapshot.docs) {
        // 각 게시글의 likes 서브컬렉션에서 현재 유저의 좋아요 찾기
        final likeDoc = postDoc.reference.collection('likes').doc(uid);
        final likeSnapshot = await likeDoc.get();

        if (likeSnapshot.exists) {
          await likeDoc.update({'nickname': newNickname});
        }
      }
    }
  }

  /// 댓글 서브컬렉션에서 닉네임 일괄 업데이트
  Future<void> _updateNicknameInComments(
      String uid, String oldNickname, String newNickname) async {
    final db = FirebaseFirestore.instance;

    // 모든 게시글 컬렉션을 순회하며 댓글 업데이트
    final collections = ['home_posts', 'ai_writes', 'random_writes'];

    for (final collectionName in collections) {
      final postsSnapshot = await db.collection(collectionName).get();

      for (final postDoc in postsSnapshot.docs) {
        // 각 게시글의 comments 서브컬렉션에서 현재 유저의 댓글 찾기
        final commentsSnapshot = await postDoc.reference
            .collection('comments')
            .where('uid', isEqualTo: uid)
            .get();

        if (commentsSnapshot.docs.isEmpty) continue;

        final batch = db.batch();
        for (final commentDoc in commentsSnapshot.docs) {
          batch.update(commentDoc.reference, {'author': newNickname});
        }
        await batch.commit();
      }
    }
  }

  Future<void> _saveProfile() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final isAvailable = await _checkNicknameDuplicate(nickname);
      if (!isAvailable) {
        setState(() {
          _isNicknameAvailable = false;
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '이미 사용 중인 닉네임입니다.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: const Color(0xFFCD853F),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // 1. users 컬렉션 닉네임 업데이트
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'nickname': nickname});

        // 2. 기존 글 닉네임 일괄 업데이트
        await _updateNicknameInPosts(user.uid, _originalNickname, nickname);

        // 3. 기존 좋아요 닉네임 일괄 업데이트
        try {
          await _updateNicknameInLikes(user.uid, _originalNickname, nickname);
        } catch (e) {
          print('좋아요 업데이트 실패: $e');
        }

        // 4. 기존 댓글 닉네임 일괄 업데이트
        try {
          await _updateNicknameInComments(user.uid, _originalNickname, nickname);
        } catch (e) {
          print('댓글 업데이트 실패: $e');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '프로필이 저장되었습니다.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: const Color(0xFFD4AF37),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '오류 발생: $e',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: const Color(0xFFCD853F),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nickname = _nicknameController.text.trim();
    final isButtonEnabled =
        !_isSaving && nickname.isNotEmpty && nickname != _originalNickname;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E3),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          '프로필 수정',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 198, 169, 140), Color(0xFFFAF0E6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_rounded, size: 18),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
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
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCD853F).withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Color(0xFFD4AF37),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '프로필 정보',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF8B4513),
                              ),
                            ),
                            Text(
                              '닉네임을 수정할 수 있어요',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFCD853F),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '닉네임',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8B4513),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF6E3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFD4AF37).withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: TextField(
                            controller: _nicknameController,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF8B4513),
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: '새로운 닉네임을 입력해주세요',
                              hintStyle: TextStyle(
                                color: const Color(0xFF8B4513).withOpacity(0.5),
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                              prefixIcon: Container(
                                margin: const EdgeInsets.only(
                                  left: 12,
                                  right: 8,
                                ),
                                child: Icon(
                                  Icons.edit_rounded,
                                  color: const Color(
                                    0xFFD4AF37,
                                  ).withOpacity(0.7),
                                  size: 20,
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 0,
                                minHeight: 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isButtonEnabled ? _saveProfile : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            212,
                            195,
                            145,
                          ),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          disabledBackgroundColor: const Color.fromARGB(
                            255,
                            175,
                            167,
                            140,
                          ).withOpacity(0.5),
                        ).copyWith(
                          overlayColor: WidgetStateProperty.all(
                            Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child:
                            _isSaving
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save_rounded, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      '저장하기',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
