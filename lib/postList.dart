import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'post.dart';
import 'comment_section.dart';

class PostList extends StatelessWidget {
  final List<Post> listItems;
  final Function(String) onDeletePost;

  const PostList(this.listItems, {required this.onDeletePost, super.key});

  void _updateLikeInDatabase(Post post) {
    if (post.id == null) return;

    final postRef = FirebaseDatabase.instance.ref().child('posts/${post.id}');
    postRef.update({
      'likes': post.likes,
      'usersLiked': post.usersLiked.toList(),
    });
  }

  void _showDeleteConfirmation(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure want to delete this post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDeletePost(postId);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (listItems.isEmpty) {
      return Center(child: Text("Hiç gönderi yok"));
    }
    final user = FirebaseAuth.instance.currentUser;

    return ListView.builder(
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        final post = listItems[index];
        final isOwner = post.author == user?.displayName;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (isOwner)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          if (post.id != null) {
                            _showDeleteConfirmation(context, post.id!);
                          }
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  post.body,
                  style: const TextStyle(fontSize: 15),
                ),
                if (post.timestamp != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      DateFormat('MMMM d, y – HH:mm')
                          .format(post.timestamp!.toLocal()),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${post.likes} likes',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    IconButton(
                      icon: Icon(
                        post.userLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.userLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        if (user == null) return;
                        post.toggleLike(user);
                        _updateLikeInDatabase(post);
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (post.id != null) CommentSection(postId: post.id!),
              ],
            ),
          ),
        );
      },
    );
  }
}
