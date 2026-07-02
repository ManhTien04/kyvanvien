import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyvanvien/theme/colors.dart';

import '../models/stories.dart';
import '../models/story.dart';

class StoryTile2 extends StatelessWidget {
  final StoriesModel story;
  final void Function()? onTap;
  const StoryTile2({
    super.key,
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Chuyển đổi chuỗi base64 thành dữ liệu nhị phân
    String base64Image = story.storyImg.split(',').last;
    Uint8List bytes = base64Decode(base64Image);

    // Sử dụng MemoryImage để tải hình ảnh từ dữ liệu nhị phân
    ImageProvider imageProvider = MemoryImage(bytes);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 50,
        margin: const EdgeInsets.only(left: 2.0, right: 2.0),
        padding: const EdgeInsets.only(left: 2.0,right: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //image
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image(
                image: imageProvider, // Sử dụng imageProvider ở đây
                height: 100,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            // Phần còn lại của widget
          ],
        ),
      ),
    );
  }
}