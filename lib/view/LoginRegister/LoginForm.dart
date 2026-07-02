import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../menu_page.dart';
import 'ForgotPassword.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  String? _emailErrorMessage;
  String? _passwordErrorMessage;
  String? _loginErrorMessage;

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      String token = responseBody['token'];

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/token.json');
      await file.writeAsString(jsonEncode({'token': token}));

      print('Login successful');

      // Navigate to MenuPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuPage()),
      );
    } else {
      setState(() {
        _loginErrorMessage = 'Email hoặc Mật khẩu của bạn không đúng';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: emailController,
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
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
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
                ),
                obscureText: _obscureText,
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
                _loginErrorMessage ?? '',
                style: TextStyle(color: Colors.red),
              ),
              ElevatedButton(
                child: Text('Đăng nhập'),
                onPressed: () {
                  setState(() {
                    _emailErrorMessage = emailController.text.contains('@gmail.com') ? null : 'Vui lòng nhập email hợp lệ';
                    _passwordErrorMessage = passwordController.text.length >= 8 ? null : 'Mật khẩu của bạn tối thiểu phải có 8 kí tự trở lên';
                  });
                  if (_emailErrorMessage == null && _passwordErrorMessage == null) {
                    login(emailController.text, passwordController.text);
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
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text('Quên mật khẩu?'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}