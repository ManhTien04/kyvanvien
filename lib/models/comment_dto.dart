class CommentDto {

  final int chapterId;
  final int storyId;
  final int userId;
  final String commentText;


  CommentDto({

    required this.chapterId,
    required this.storyId,
    required this.userId,
    required this.commentText,

  });

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    return CommentDto(

      chapterId: json['chapterId'],

      storyId: json['storyId'],
      userId: json['userId'],

      commentText: json['commentText'],

    );
  }

  Map<String, dynamic> toJson() {
    return {

      'chapterId': chapterId,
      'storyId': storyId,
      'userId': userId,
      'commentText': commentText,

    };
  }
}
