import 'package:flutter/material.dart';
import '../../models/stories.dart';

class StoryBanner extends StatelessWidget {
  final StoriesModel story;
  final ImageProvider imageProvider;

  StoryBanner({required this.story, required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          // Hình ảnh nền cho banner
          Container(
            width: MediaQuery.of(context).size.width * 1.0, // Độ rộng banner
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider, // Sử dụng imageProvider ở đây
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay để tạo hiệu ứng mờ phía trên
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Thông tin truyện trên banner
          Positioned(
            left: 10,
            bottom: 10,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Chương: ${story.chapterCount}",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Tác giả: ${story.author}",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                // Row(
                //   children: List.generate(
                //     5,
                //         (starIndex) => Icon(
                //       starIndex < 4 ? Icons.star : Icons.star_border,
                //       color: Colors.yellow,
                //       size: 20,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}