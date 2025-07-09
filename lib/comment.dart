class Comment {
  final String id;
  final String author;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.author,
    required this.text,
    required this.timestamp,
  });

  factory Comment.fromJson(String id, Map data) {
    return Comment(
      id: id,
      author: data['author'] ?? 'Unknown',
      text: data['text'] ?? '',
      timestamp:
          DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
