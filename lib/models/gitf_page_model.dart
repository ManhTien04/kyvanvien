class GiftPageModel {
  final int rgId;
  final int userId;
  final String userName;
  final int? adminId; // adminId có thể là null
  final String? adminName; // adminName có thể là null
  final int cardValue;
  final int diamondsUsed;
  final DateTime requestDate;
  final String status;
  final String? adminResponse; // adminResponse có thể là null
  final DateTime? adminResponseDate; // adminResponseDate có thể là null

  GiftPageModel({
    required this.rgId,
    required this.userId,
    required this.userName,
    this.adminId, // adminId có thể là null
    this.adminName, // adminName có thể là null
    required this.cardValue,
    required this.diamondsUsed,
    required this.requestDate,
    required this.status,
    this.adminResponse, // adminResponse có thể là null
    this.adminResponseDate, // adminResponseDate có thể là null
  });

  factory GiftPageModel.fromJson(Map<String, dynamic> json) {
    return GiftPageModel(
      rgId: json['rgId'] ?? 0,
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      adminId: json['adminId'], // adminId có thể là null
      adminName: json['adminName'], // adminName có thể là null
      cardValue: json['cardValue'] ?? 0,
      diamondsUsed: json['diamondsUsed'] ?? 0,
      requestDate: DateTime.fromMillisecondsSinceEpoch(json['requestDate'] ?? 0), // Chuyển đổi từ millisecond sang DateTime
      status: json['status'] ?? '',
      adminResponse: json['adminResponse'], // adminResponse có thể là null
      adminResponseDate: json['adminResponseDate'] != null ? DateTime.fromMillisecondsSinceEpoch(json['adminResponseDate']) : null, // Chuyển đổi từ millisecond sang DateTime nếu không null
    );
  }

  static List<GiftPageModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => GiftPageModel.fromJson(item)).toList();
  }
}