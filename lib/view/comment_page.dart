import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'dart:convert';
import 'package:kyvanvien/models/comments.dart';
import 'package:kyvanvien/models/comment_dto.dart';
import 'package:flutter/services.dart';
import 'package:kyvanvien/theme/colors.dart';

import 'LoginRegister/TokenHandler.dart';

class NoNewlineTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll('\n', '');
    return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }
}

class CommentPage extends StatefulWidget {
  final int storyId;

  const CommentPage({super.key, required this.storyId});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  int userId = 0;
  List<CommentModel> comments = [];
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchComments();
    loadUserId();
  }

  Future<void> loadUserId() async {
    String? token = await getToken();
    if (token != null) {
      final parts = token.split('.');
      if (parts.length > 1) { // Kiểm tra xem có phần thứ hai không
        final payload = B64urlEncRfc7515.decodeUtf8(parts[1]);
        Map<String, dynamic> tokenData = json.decode(payload);

        setState(() {
          userId = tokenData['userId'] ?? 0;
        });
      } else {
        print('Invalid token format');
      }
    } else {
      print('Token is null');
    }
  }


  Future<void> _fetchComments() async {
    final String baseUrl = 'http://10.0.2.2:8080/api/v1/comments/story/${widget.storyId}';

    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          comments = jsonData.map((json) => CommentModel.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }


  Future<void> _addComment() async {
    if (commentController.text.isEmpty) return;

    try {
      final chapterResponse = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/v1/chapters/story/${widget.storyId}'),
      );

      if (chapterResponse.statusCode == 200) {
        List<dynamic> jsonData = json.decode(chapterResponse.body);

        int chapterId = jsonData[0]['chapterId'] ?? 0; // Đảm bảo không có Null

        const String baseUrl = 'http://10.0.2.2:8080/api/v1/comments';
        final newComment = CommentDto(
          chapterId: chapterId,
          storyId: widget.storyId,
          userId: userId,
          commentText: commentController.text,
        );

        final response = await http.post(
          Uri.parse(baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(newComment.toJson()),
        );

        if (response.statusCode == 200) {
          _fetchComments();
          commentController.clear();
        } else {
          print('Failed to create comment: ${response.statusCode}');
        }
      } else {
        print('Failed to fetch chapters: ${chapterResponse.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 70), // Add left padding to the title
          child: Text(
            'Bình Luận',
            style: TextStyle(color: titleColor), // Set the color of the title
          ),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: titleColor, // Set the color of the back button
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return Container(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(comment.userName[0]),
                    ),
                    title: Text(comment.userName, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(comment.commentText,style: TextStyle(fontSize: 16.0),),
                    trailing: Text(comment.timeAgo),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    maxLength: 115, // Limit to 115 characters
                    maxLines: null, // This allows for unlimited lines
                    inputFormatters: [NoNewlineTextInputFormatter()], // Prevents newline
                    decoration: InputDecoration(
                      hintText: 'Viết Bình Luận Của Bạn',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}