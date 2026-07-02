class WalletModel {
  final int transactionId;
  final int walletId;
  final String userName;
  final DateTime createdAt;
  final double amount;

  WalletModel({
    required this.transactionId,
    required this.walletId,
    required this.userName,
    required this.createdAt,
    required this.amount
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      transactionId: json['transactionId'] ?? 0,
      walletId: json['walletId'] ?? 0,
      userName: json['userName'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      amount: json['amount'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'walletId': walletId,
      'userName': userName,
      'createdAt': createdAt.toIso8601String(),
      'amount': amount,
    };
  }

  static List<WalletModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => WalletModel.fromJson(item)).toList();
  }
}