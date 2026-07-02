import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../LoginRegisterPage.dart';
import 'LoginForm.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  String? _emailErrorMessage;
  String? _passwordErrorMessage;
  String? _apiErrorMessage;

  Future<void> register(String fullName, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'fullName': fullName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 500) {
      setState(() {
        _apiErrorMessage = 'Email đã tồn tại trong hệ thống. Vui lòng sử dụng email khác.';
      });
    } else if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Successful'),
            content: Text('You have successfully registered.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // Clear the text fields
                  fullNameController.clear();
                  emailController.clear();
                  passwordController.clear();
                  confirmPasswordController.clear();

                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginRegisterPage()),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      _apiErrorMessage = 'Registration failed. Please try again.';
    }
  }

  void clearErrorMessage() {
    if (_apiErrorMessage == 'Vui lòng nhập đủ dữ liệu vào form') {
      setState(() {
        _apiErrorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: fullNameController,
                  onTap: clearErrorMessage,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  onTap: clearErrorMessage,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      _emailErrorMessage = null;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  onTap: clearErrorMessage,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  obscureText: _obscureText,
                  onChanged: (value) {
                    setState(() {
                      _passwordErrorMessage = null;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  onTap: clearErrorMessage,
                  decoration: InputDecoration(
                    labelText: 'Nhập lại mật khẩu',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextConfirm ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureTextConfirm = !_obscureTextConfirm;
                        });
                      },
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  obscureText: _obscureTextConfirm,
                  onChanged: (value) {
                    setState(() {
                      _passwordErrorMessage = null;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(
                  _emailErrorMessage ?? '',
                  style: TextStyle(color: Colors.red),
                ),
                Text(
                  _passwordErrorMessage ?? '',
                  style: TextStyle(color: Colors.red),
                ),
                Text(
                  _apiErrorMessage ?? '',
                  style: TextStyle(color: Colors.red),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    child: Text('Đăng kí'),
                    onPressed: () {
                      setState(() {
                        if (fullNameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
                          _apiErrorMessage = 'Vui lòng nhập đủ dữ liệu vào form';
                        } else if (passwordController.text.length < 8) {
                          _passwordErrorMessage = 'Mật khẩu của bạn tối thiểu phải có 8 kí tự trở lên';
                        } else {
                          _emailErrorMessage = emailController.text.endsWith('gmail.com') ? null : 'Vui lòng nhập email hợp lệ';
                          _passwordErrorMessage = passwordController.text == confirmPasswordController.text ? null : 'Error: Passwords do not match';
                        }
                      });
                      if (_emailErrorMessage == null && _passwordErrorMessage == null && _apiErrorMessage == null) {
                        register(fullNameController.text, emailController.text, passwordController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      elevation: 10,
                      shadowColor: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}