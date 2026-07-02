import 'package:flutter/material.dart';
import 'package:kyvanvien/ui/story_detail/donate.dart';
import 'package:kyvanvien/view/story_detail.dart';

import '../theme/colors.dart';

class DonateDetail extends StatelessWidget {
  final int storyId;

  const DonateDetail({required this.storyId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,  // Đảm bảo tiêu đề được căn giữa
        title: Text(
          'Tặng Quà ',
          style: TextStyle(
            color: titleColor,
            //fontWeight: FontWeight.bold,
            fontSize: 25, // Change text color to #FFE8D6
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: titleColor), // Change color to #FFE8D6
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Donate(storyId: storyId), // Changed from DonateDetail to Donate
          ],
        ),
      ),
    );
  }
}