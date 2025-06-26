import 'package:flutter/material.dart';
import 'package:your_write/data/models/comment_model.dart';
import 'package:your_write/ui/widgets/comment/shared_comment_input.dart';
import 'package:your_write/ui/widgets/comment/shared_comment_list.dart';
import 'package:your_write/data/models/home_post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeDetailPage extends StatefulWidget {
  final String postId;
  final bool scrollToCommentInput;

  const HomeDetailPage({
    super.key,
    required this.postId,
    this.scrollToCommentInput = false,
  });

  @override
  State<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends State<HomeDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final List<CommentModel> _comments = [];
  HomePostModel? _post;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPost();
    _loadComments();
  }

  Future<void> _loadPost() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('home_posts')
            .doc(widget.postId)
            .get();

    if (!doc.exists) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _post = HomePostModel.fromMap(doc.data()!, doc.id);
      _isLoading = false;
    });

    if (widget.scrollToCommentInput) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => scrollToCommentInput(),
      );
    }
  }

  Future<void> _loadComments() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('home_posts')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('createdAt', descending: true)
            .get();

    final comments =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return CommentModel(
            id: doc.id,
            author: data['author'] ?? '익명',
            content: data['content'] ?? '',
            createdAt: (data['createdAt'] as Timestamp).toDate(),
          );
        }).toList();

    setState(() {
      _comments.clear();
      _comments.addAll(comments);
    });
  }

  void _addComment(String content) async {
    if (content.trim().isEmpty) return;

    final commentData = {
      'author': '익명',
      'content': content,
      'createdAt': Timestamp.now(),
    };

    await FirebaseFirestore.instance
        .collection('home_posts')
        .doc(widget.postId)
        .collection('comments')
        .add(commentData);

    setState(() {
      _comments.insert(
        0,
        CommentModel(
          id: '',
          author: '익명',
          content: content,
          createdAt: DateTime.now(),
        ),
      );
      _controller.clear();
    });
  }

  /// 댓글 입력란으로 스크롤 + 포커스 주는 함수
  void scrollToCommentInput() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_post == null) {
      return Scaffold(body: Center(child: Text('게시글을 찾을 수 없습니다.')));
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0XFFFFFDF4),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Image.asset('assets/appbar_logo.png'),
                Padding(
                  padding: const EdgeInsets.only(top: 85, left: 30),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.keyboard_return_sharp, size: 30),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  Text(
                    _post!.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${_post!.author}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#${_post!.keyword}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_post!.date.year}.${_post!.date.month.toString().padLeft(2, '0')}.${_post!.date.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 32, thickness: 2),
                  Text(
                    _post!.content,
                    style: const TextStyle(fontSize: 18, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 32, thickness: 2),
                  SharedCommentInput(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: _addComment,
                  ),
                  const SizedBox(height: 16),
                  SharedCommentList(comments: _comments),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
