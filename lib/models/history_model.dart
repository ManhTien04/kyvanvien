class HistoryModel {
  final int hgId;
  final int userId;
  final String userName;
  final int storyId;
  final String storyName;
  final DateTime createAt;
  final double amount;

  HistoryModel({
    required this.hgId,
    required this.userId,
    required this.userName,
    required this.storyId,
    required this.storyName,
    required this.createAt,
    required this.amount
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      hgId: json['hgId'] ?? 0,
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      storyId: json['storyId'] ?? 0,
      storyName: json['storyName'] ?? '',
      createAt: DateTime.fromMillisecondsSinceEpoch(json['createAt']),
      amount: json['amount'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hgId': hgId,
      'userId': userId,
      'userName': userName,
      'storyId': storyId,
      'storyName': storyName,
      'createAt': createAt.toIso8601String(),
      'amount': amount,
    };
  }

  static List<HistoryModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => HistoryModel.fromJson(item)).toList();
  }
}