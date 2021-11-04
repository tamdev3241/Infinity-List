import 'package:demo_bloc_infinitylist/models/comment.dart';

abstract class CommentState {
  const CommentState();
}

//States of page
class CommentStateInitial extends CommentState {}

class CommentStateFailure extends CommentState {}

class CommentStateSuccess extends CommentState {
  final List<Comment> comments;
  final bool hasReachedEnd;
  const CommentStateSuccess({this.comments, this.hasReachedEnd});

  CommentStateSuccess cloneWith({
    List<Comment> comments,
    bool hasReachedEnd,
  }) =>
      CommentStateSuccess(
        comments: comments ?? this.comments,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      );
}
