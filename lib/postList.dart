import 'package:flutter/material.dart';
import 'post.dart';

class PostList extends StatefulWidget {
  final List<Post> listItems;

  const PostList(this.listItems, {super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  void like(Function callBack) {
    setState(() {
      callBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listItems.length,
      itemBuilder: (context, index) {
        var post = widget.listItems[index];
        return Card(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  title: Text(post.body),
                  subtitle: Text("by ${post.author}"),
                ),
              ),
              IconButton(
                icon: Icon(
                  post.userLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                  color: post.userLiked ? Colors.green : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    post.likePost();
                  });
                },
              ),
              Text(post.likes.toString()),
            ],
          ),
        );
      },
    );
  }
}
