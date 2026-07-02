import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyvanvien/models/story.dart';
import 'package:kyvanvien/ui/home/complete_novels.dart';
import 'package:kyvanvien/ui/home/hot_novels.dart';
import 'package:kyvanvien/ui/home/new_novels.dart';
import 'package:kyvanvien/theme/colors.dart';

import '../components/story_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView( // Add this
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //truyện đề cử
              HotNovels(),
              const SizedBox(height: 5,),

              //truyện mới nhất
              NewNovels(),
              const SizedBox(height: 5,),

              //truyện đã xong
              CompleteNovels(),
            ],
          ),
        ),
      ),
    );
  }
}