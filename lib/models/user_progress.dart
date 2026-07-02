class UserProgress {
  final int userId;
  final int storyId;
  final int chapterId;

  UserProgress({required this.userId, required this.storyId, required this.chapterId});

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['userId'],
      storyId: json['storyId'],
      chapterId: json['chapterId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'storyId': storyId,
      'chapterId': chapterId,
    };
  }
}
