import 'package:flutter/material.dart';
import 'post.dart';

class PostList extends StatelessWidget {
  final List<Post> listItems;

  const PostList(this.listItems, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        final post = listItems[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(post.body),
            subtitle: Text('by ${post.author}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(post.likes.toString()),
                IconButton(
                  icon: Icon(
                    post.userLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                    color: post.userLiked ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    post.toggleLike();

                    (context as Element).markNeedsBuild();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
