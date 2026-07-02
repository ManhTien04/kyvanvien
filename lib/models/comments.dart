class CommentModel {
  final int commentId;
  final int chapterId;
  final String chapterName;
  final int storyId;
  final int userId;
  final String userName;
  final String commentText;
  final int createdAt;

  CommentModel({
    required this.commentId,
    required this.chapterId,
    required this.chapterName,
    required this.storyId,
    required this.userId,
    required this.userName,
    required this.commentText,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['commentId'] ?? 0,
      chapterId: json['chapterId'],
      chapterName: json['chapterName'] ?? '',
      storyId: json['storyId'],
      userId: json['userId'],
      userName: json['userName'] ?? '',
      commentText: json['commentText'] ?? '',
      createdAt: json['createdAt'] ?? 0,
    );
  }

  // Hàm chuyển đổi createdAt thành DateTime
  DateTime get createdAtDateTime {
    return DateTime.fromMillisecondsSinceEpoch(createdAt);
  }

  // Hàm định dạng ngày giờ thành chuỗi với giờ và phút ở trước ngày
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAtDateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} Năm';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} Tháng';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} Ngày';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}p';
    } else if (difference.inSeconds >= 0) {
      return 'Vừa Xong';
    } else {
      return 'Just now';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commentId'] = commentId;
    data['chapterId'] = chapterId;
    data['chapterName'] = chapterName;
    data['storyId'] = storyId;
    data['userId'] = userId;
    data['userName'] = userName;
    data['commentText'] = commentText;
    data['createdAt'] = createdAt;
    return data;
  }
}
