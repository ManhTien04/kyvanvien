import 'package:flutter/material.dart';
import 'package:kyvanvien/theme/colors.dart';

import 'LoginRegister/LoginForm.dart';
import 'LoginRegister/RegisterForm.dart';


class LoginRegisterPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginRegisterPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    LoginForm(),
    RegisterPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Đăng nhập' : 'Đăng kí'),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: titleColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.login, color: _currentIndex == 0 ? titleColor: Colors.grey),
            label: 'Đăng nhập',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration, color: _currentIndex == 1 ? titleColor : Colors.grey),
            label: 'Đăng kí',
          ),
        ],
      ),
    );
  }
}