import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:kyvanvien/theme/colors.dart';
import 'package:kyvanvien/view/ChapterDetailPage.dart';
import 'package:kyvanvien/view/LoginRegister/TokenHandler.dart';
import 'package:kyvanvien/view/StoriesList.dart';
import '../models/stories.dart'; // Import StoriesModel

class Chapter {
  final int chapterId;
  final int storyId;
  final String title;
  final int chapterNumber;
  final String content;

  Chapter({
    required this.chapterId,
    required this.storyId,
    required this.title,
    required this.chapterNumber,
    required this.content
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterId: json['chapterId'],
      storyId: json['storyId'],
      title: json['title'],
      chapterNumber: json['chapterNumber'],
      content: json['content'],
    );
  }
}

class ChapterPage extends StatelessWidget {
  final StoriesModel story;
  ChapterPage({required this.story});

  Future<List<Chapter>> fetchChapters() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/chapters/story/${story.id}'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      print('Response from API: $jsonResponse');
      return jsonResponse.map((item) => Chapter.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load chapters from API');
    }
  }

  Future<int?> getUserId() async {
    // Giả sử bạn có hàm getToken() và cách lấy userId từ token
    String? token = await getToken();
    if (token != null) {
      final parts = token.split('.');
      final payload = B64urlEncRfc7515.decodeUtf8(parts[1]);
      Map<String, dynamic> tokenData = json.decode(payload);
      return tokenData['userId'];
    }
    return null;
  }

  Future<void> saveOrUpdateUserProgress(int userId, int storyId, int chapterId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/v1/reading-history/save-or-update'),
      body: {
        'userId': userId.toString(),
        'storyId': storyId.toString(),
        'chapterId': chapterId.toString(),
      },
    );

    if (response.statusCode == 200) {
      print("Progress saved successfully");
    } else {
      throw Exception('Failed to save user progress');
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Chapter>>(
      future: fetchChapters(),
      builder: (BuildContext context, AsyncSnapshot<List<Chapter>> snapshot) {
        if (snapshot.hasData) {
          List<Chapter> chapters = snapshot.data!;
          return Scaffold(
            backgroundColor: primaryColor,
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: Padding(
                padding: EdgeInsets.only(left: 60), // Add padding here
                child: Text("Chương Truyện", style: TextStyle(color: titleColor)), // Set the title color
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                  color: titleColor,
                ), // Add back button
                onPressed: () => Navigator.pop(context), // Go back to the previous screen when the back button is pressed
              ),
            ),
            body: ListView.builder(
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chapters[index].title),
                  onTap: () async {
                    // Lấy userId
                    int? userId = await getUserId();

                    // Lưu hoặc cập nhật tiến trình đọc nếu userId không null
                    if (userId != null) {
                      await saveOrUpdateUserProgress(userId, story.id, chapters[index].chapterId);
                    }

                    // Điều hướng đến trang chi tiết chương
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChapterDetailPage(
                          chapter: chapters[index],
                          chapters: chapters,
                          story: story,
                        ),
                      ),
                    );
                  },

                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}