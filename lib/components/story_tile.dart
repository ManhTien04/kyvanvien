import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kyvanvien/models/stories.dart';
import 'package:kyvanvien/theme/colors.dart';

class StoryTile extends StatelessWidget {
  final StoriesModel story;
  final void Function()? onTap;
  const StoryTile({
    super.key,
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  onTap,
      child: Container(
        width: 125,
        height: 50,
        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
        padding: const EdgeInsets.only(left: 5.0,right: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //image
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.memory(
                base64Decode(story.storyImg.split(',').last),
                height: 130,
                width: 110,
                fit: BoxFit.cover,
              ),
            ),
            //text
            Text(
              story.title,
              maxLines: 2, // Limit to 2 lines
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                color: textColor,
                fontFamily: 'Inter',
              ),
            ),
            //chapter
            SizedBox(
              width: 110,
              child: Row(
                children: [
                  Text("Chương ${story.chapterCount}",
                    maxLines: 2, // Limit to 2 lines
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
