import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:kyvanvien/theme/colors.dart';
import 'dart:convert';
import 'package:kyvanvien/view/LoginRegister/TokenHandler.dart';
import 'package:kyvanvien/models/user.dart';

class NewPassword extends StatefulWidget {
  final int userId;

  NewPassword({required this.userId});

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  Future<void> changePassword(String oldPassword, String newPassword) async {
    String? token = await getToken();
    if (token != null) {
      final parts = token.split('.');
      final payload = B64urlEncRfc7515.decodeUtf8(parts[1]);
      Map<String, dynamic> tokenData = json.decode(payload);
      final userId = tokenData['userId'];

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/v1/user/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        User userData = User.fromJson(jsonDecode(response.body));

        final changePasswordResponse = await http.post(
          Uri.parse('http://10.0.2.2:8080/api/v1/user/change-password'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{
            'email': userData.email,
            'oldPassword': oldPassword,
            'newPassword': newPassword,
          }),
        );

        print('Data sent to API: ${jsonEncode(<String, String>{
          'email': userData.email,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        })}');

        if (changePasswordResponse.statusCode == 200) {
          // Password changed successfully
        } else {
          print('Failed to change password. Status code: ${changePasswordResponse.statusCode}');
          print('Response body: ${changePasswordResponse.body}');

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Thông báo'),
                content: Text('Đổi Mật Khẩu Không Thành Công. Vui Lòng Kiểm Tra Lại Mật Khẩu Hiện Tại Của Bạn'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          throw Exception('Failed to change password');
        }
      } else {
        throw Exception('Failed to load user data');
      }
    } else {
      throw Exception('Failed to get token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 60), // Add left padding to the title
          child: Text(
            'Đổi Mật Khẩu',
            style: TextStyle(color: titleColor), // Set the color of the title
          ),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: titleColor, // Set the color of the back button
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _currentPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu hiện tại',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu hiện tại';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu mới',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu mới';
                    }
                    if (value == _currentPasswordController.text) {
                      return 'Mật khẩu mới không được trùng với mật khẩu hiện tại';
                    }
                    if (value.length < 8) {
                      return 'Mật khẩu phải có ít nhất 8 ký tự';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmNewPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Nhập lại mật khẩu mới',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập lại mật khẩu mới';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Mật khẩu mới không khớp';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 70.0),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Xác nhận thay đổi mật khẩu'),
                              content: Text('Bạn chắc chắn muốn thay đổi mật khẩu chứ ? chúng tôi sẽ không thể khôi phục mật khẩu cũ của bạn sau khi thay đổi mật khẩu mới'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Hủy'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Đồng ý'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    try {
                                      await changePassword(
                                        _currentPasswordController.text,
                                        _newPasswordController.text,
                                      );
                                      // Clear the form fields after successful password change
                                      _currentPasswordController.clear();
                                      _newPasswordController.clear();
                                      _confirmNewPasswordController.clear();
                                    } catch (e) {
                                      // Handle error
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Xác nhận'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: primaryColor,
    );
  }
}