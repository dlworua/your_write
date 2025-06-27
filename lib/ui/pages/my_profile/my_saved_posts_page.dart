import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_write/data/models/unified_post_model.dart';
import 'package:your_write/ui/pages/my_profile/widgets/unified_post_item.dart';

class MySavedPostsPage extends StatefulWidget {
  const MySavedPostsPage({super.key});

  @override
  State<MySavedPostsPage> createState() => _MySavedPostsPageState();
}

class _MySavedPostsPageState extends State<MySavedPostsPage> {
  List<UnifiedPostModel> _posts = [];

  Future<void> _loadPosts() async {
    final List<UnifiedPostModel> results = [];

    final ai = await FirebaseFirestore.instance.collection('ai_writes').get();
    final random =
        await FirebaseFirestore.instance.collection('random_writes').get();
    final home =
        await FirebaseFirestore.instance.collection('home_posts').get();

    for (final doc in ai.docs) {
      results.add(UnifiedPostModel.fromMap(doc.data(), doc.id, BoardType.ai));
    }
    for (final doc in random.docs) {
      results.add(
        UnifiedPostModel.fromMap(doc.data(), doc.id, BoardType.random),
      );
    }
    for (final doc in home.docs) {
      results.add(UnifiedPostModel.fromMap(doc.data(), doc.id, BoardType.home));
    }

    setState(() {
      _posts = results;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("내가 저장한 글")),
      body:
          _posts.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadPosts,
                child: ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    return UnifiedPostItem(post: _posts[index]);
                  },
                ),
              ),
    );
  }
}
