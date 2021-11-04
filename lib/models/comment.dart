class Comment {
  final int id;
  final String name;
  final String email;
  final String body;
  Comment({this.id, this.name, this.email, this.body});

  factory Comment.fromJson(Map<String, dynamic> comment) => Comment(
        id: comment['id'],
        name: comment['name'],
        email: comment['email'],
        body: comment['body'],
      );
}
