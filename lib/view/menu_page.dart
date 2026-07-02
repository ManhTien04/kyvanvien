import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyvanvien/models/story.dart';
import 'package:kyvanvien/view/home_page.dart';
import 'package:kyvanvien/view/StoriesList.dart';
import 'package:kyvanvien/theme/colors.dart';

import '../components/story_tile.dart';
import 'Profile.dart';
import 'SearchPage.dart';
import 'book_case.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  int _selectedIndex = 1;

  final List<Widget> screens = [
    BookCase(),
    HomePage(),
    StoriesList(),
    Profile(),
  ];

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: _selectedIndex == 1 ? AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('lib/images/Untitled-1.png'),
          ),
        ),
        title: Text(
          'Kỳ Văn Viện',
          style: GoogleFonts.montserrat(
            fontSize: 25,
            color: titleColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30.0,
            color: titleColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
        ],
      ) : null,
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
        onTap: (index) => _changeTab(index),
        selectedItemColor: titleColor,
        unselectedItemColor: extracolor,
        backgroundColor: primaryColor,

        // Hide the labels
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}