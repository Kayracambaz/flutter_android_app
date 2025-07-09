import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
  final dbRef = FirebaseDatabase.instance.ref().child("posts");

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    final snapshot = await dbRef.get();
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final List<Post> loadedPosts = [];

      data.forEach((key, value) {
        final post = Post.fromJson(value, id: key, currentUid: uid);
        loadedPosts.add(post);
      });

      setState(() {
        posts = loadedPosts;
      });
    }
  }

  Future<void> addNewPost(String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final newPost = Post(
      text,
      widget.name,
      timestamp: now,
    );
    final newPostRef = dbRef.push();

    await newPostRef.set(newPost.toJson());

    setState(() {
      posts.add(Post(
        text,
        widget.name,
        id: newPostRef.key,
        timestamp: now,
      ));
    });
  }

  Future<void> deletePost(String postId) async {
    await dbRef.child(postId).remove();
    setState(() {
      posts.removeWhere((post) => post.id == postId);
    });
  }

  Future<void> _handleSignOut() async {
    await signOutGoogle();
    Navigator.pushReplacementNamed(context, '/');
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
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home Page'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      )),
      body: Column(
        children: <Widget>[
          Expanded(child: PostList(posts, onDeletePost: deletePost)),
          TextInputWidget(addNewPost),
        ],
      ),
    );
  }
}
