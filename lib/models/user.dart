class User {
  final int userId;
  final String fullName;
  final String email;
  final String password;
  final String userImg;
  final int balance;

  User({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.password,
    required this.userImg,
    required this.balance
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: (json['userId'] as num).toInt(),
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      userImg: json['userImg'] ?? '',
      balance: (json['balance'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': this.userId,
      'fullName': this.fullName,
      'email': this.email,
      'password': this.password,
      'userImg': this.userImg,
      'balance': this.balance,
    };
  }

  static List<User> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => User.fromJson(item)).toList();
  }
}