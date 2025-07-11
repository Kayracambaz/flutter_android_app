import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'comment.dart';

class CommentSection extends StatefulWidget {
  final String postId;

  const CommentSection({super.key, required this.postId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final commentController = TextEditingController();
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    final ref = FirebaseDatabase.instance
        .ref()
        .child('posts')
        .child(widget.postId)
        .child('comments');

    final snapshot = await ref.get();

    if (snapshot.exists) {
      final Map data = snapshot.value as Map;
      final List<Comment> loaded = [];

      data.forEach((key, value) {
        loaded.add(Comment.fromJson(key, value));
      });

      loaded.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      setState(() {
        comments = loaded;
      });
    }
  }

  Future<void> _addComment() async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser!;
    final now = DateTime.now();
    final commentRef = FirebaseDatabase.instance
        .ref()
        .child('posts')
        .child(widget.postId)
        .child('comments')
        .push();

    await commentRef.set({
      'author': user.displayName ?? "Anonymous",
      'text': text,
      'timestamp': now.toIso8601String(),
    });

    final newComment = Comment(
      id: commentRef.key!,
      author: user.displayName ?? "Anonymous",
      text: text,
      timestamp: now,
    );

    setState(() {
      comments.insert(0, newComment);
      commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...comments.map((c) => ListTile(
              title: Text(c.author),
              subtitle: Text(c.text),
              trailing: Text(
                "${c.timestamp.hour}:${c.timestamp.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(fontSize: 12),
              ),
            )),
        const Divider(thickness: 1, height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: "Add a comment...",
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _addComment,
            )
          ],
        )
      ],
    );
  }
}
