import 'package:firebase_auth/firebase_auth.dart';

DateTime? timestamp;

class Post {
  String? id;
  String body;
  String author;
  int likes;
  bool userLiked;
  Set<String> usersLiked;
  DateTime? timestamp;

  Post(
    this.body,
    this.author, {
    this.likes = 0,
    this.userLiked = false,
    this.id,
    Set<String>? usersLiked,
    this.timestamp,
  }) : usersLiked = usersLiked ?? {};

  void toggleLike(User user) {
    final uid = user.uid;

    if (usersLiked.contains(uid)) {
      usersLiked.remove(uid);
      if (likes > 0) likes -= 1;
      userLiked = false;
    } else {
      usersLiked.add(uid);
      likes += 1;
      userLiked = true;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'author': author,
      'likes': likes,
      'usersLiked': usersLiked.toList(),
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory Post.fromJson(Map<dynamic, dynamic> json,
      {String? id, String? currentUid}) {
    Set<String> likedSet = Set<String>.from(json['usersLiked'] ?? []);

    return Post(
      json['body'] ?? '',
      json['author'] ?? '',
      likes: json['likes'] ?? 0,
      id: id,
      usersLiked: likedSet,
      userLiked: currentUid != null ? likedSet.contains(currentUid) : false,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
    );
  }
  @override
  String toString() {
    return 'Post{id: $id, body: $body, author: $author, likes: $likes, userLiked: $userLiked, usersLiked: $usersLiked, timestamp: $timestamp}';
  }
}
