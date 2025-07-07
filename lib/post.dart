class Post {
  String body;
  String author;
  int likes;
  bool userLiked;

  Post(this.body, this.author, {this.likes = 0, this.userLiked = false});

  void toggleLike() {
    if (userLiked) {
      if (likes > 0) likes -= 1;
    } else {
      likes += 1;
    }
    userLiked = !userLiked;
  }

  @override
  String toString() {
    return '$author: "$body" (${likes} likes)';
  }
}
