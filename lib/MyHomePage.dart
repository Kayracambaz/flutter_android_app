import 'package:flutter/material.dart';
import 'post.dart';
import 'postList.dart';
import 'TextInputWidget.dart';
import 'auth.dart';

class MyHomePage extends StatefulWidget {
  final String name;

  const MyHomePage(this.name, {super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];

  void addNewPost(String text) {
    setState(() {
      posts.add(Post(text, widget.name));
    });
  }

  void _handleSignOut() {
    signOutGoogle();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.name}'),
        actions: [
          IconButton(
            onPressed: _handleSignOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: PostList(posts)),
          TextInputWidget(addNewPost),
        ],
      ),
    );
  }
}
