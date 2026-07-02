class StoriesModel {
  final int id;
  final String storyImg;
  final String title;
  final String slug;
  final String author;
  final int userId;
  final String userName;
  final String description;
  final int genreId;
  final String genreName;
  final int statusId;
  final String statusName;
  final int typeId;
  final String typeName;
  final int chapterCount;
  final int likeCount;
  final int viewCount;
  final double averageRating;
  final int ratingCount;

  StoriesModel({
    required this.id,
    required this.storyImg,
    required this.title,
    required this.slug,
    required this.author,
    required this.userId,
    required this.userName,
    required this.description,
    required this.genreId,
    required this.genreName,
    required this.statusId,
    required this.statusName,
    required this.typeId,
    required this.typeName,
    required this.chapterCount,
    required this.likeCount,
    required this.viewCount,
    required this.averageRating,
    required this.ratingCount
  });

  factory StoriesModel.fromJson(Map<String, dynamic> json) {
    return StoriesModel(
        id: json['id'] ?? 0,
        storyImg: json['storyImg'] ?? '',
        title: json['title'] ?? '',
        slug: json['slug'] ?? '',
        author: json['author'] ?? '',
        userId: json['userId'] ?? 0,
        userName: json['userName'] ?? '',
        description: json['description'] ?? '',
        genreId: json['genreId'] ?? 0,
        genreName: json['genreName'] ?? '',
        statusId: json['statusId'] ?? 0,
        statusName: json['statusName'] ?? '',
        typeId: json['typeId'] ?? 0,
        typeName: json['typeName'] ?? '',
        chapterCount: json['chapterCount'] ?? 0,
        likeCount: json['likeCount'] ?? 0,
        viewCount: json['viewCount'] ?? 0,
        averageRating: json['averageRating'] ?? 0,
        ratingCount: json['ratingCount'] ?? 0

    );
  }
  static List<StoriesModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => StoriesModel.fromJson(item)).toList();
  }
}