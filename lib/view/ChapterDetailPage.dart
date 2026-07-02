import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:flutter_html/flutter_html.dart';
import 'package:kyvanvien/theme/colors.dart';
import 'package:kyvanvien/view/LoginRegister/TokenHandler.dart';
import 'package:kyvanvien/view/story_detail.dart';
import '../models/stories.dart';
import 'ChapterPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChapterDetailPage extends StatefulWidget {
  final Chapter chapter;
  final List<Chapter> chapters;
  final StoriesModel story;

  ChapterDetailPage({required this.chapter, required this.chapters,required this.story});

  @override
  _ChapterDetailPageState createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  bool _isBottomNavVisible = false;
  bool _isSavingProgress = false;
  int? userId;

  void _toggleBottomNavVisibility() {
    setState(() {
      _isBottomNavVisible = !_isBottomNavVisible;
    });
  }

  int getCurrentChapterIndex() {
    return widget.chapters.indexWhere((chapter) => chapter.chapterId == widget.chapter.chapterId);
  }

  @override
  void initState() {
    super.initState();
    loadUserId().then((_) {
      if (userId != null) {
        saveOrUpdateUserProgressWithUserId(widget.chapter.storyId, widget.chapter.chapterId);
      } else {
        print("Failed to load userId");
      }
    }).catchError((error) {
      print("Error loading userId: $error");
    });
  }

  Future<void> loadUserId() async {
    String? token = await getToken(); // Giả sử bạn đã có hàm getToken() để lấy token
    if (token != null) {
      final parts = token.split('.');
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      Map<String, dynamic> tokenData = json.decode(payload);
      setState(() {
        userId = tokenData['userId'];
      });
    }
  }

  Future<void> saveOrUpdateUserProgressWithUserId(int storyId, int chapterId) async {
    if (userId != null) {
      await saveOrUpdateUserProgress(userId!, storyId, chapterId);
    }
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

  Future<void> _handleNavigation(int index) async {
    int currentIndex = getCurrentChapterIndex();
    Chapter? targetChapter;

    switch (index) {
      case 0:
      // Navigate to the previous chapter
        if (currentIndex > 0 && currentIndex < widget.chapters.length) {
          targetChapter = widget.chapters[currentIndex - 1];
        }
        break;
      case 1:
      // Navigate to the next chapter
        if (currentIndex >= 0 && currentIndex < widget.chapters.length - 1) {
          targetChapter = widget.chapters[currentIndex + 1];
        }
        break;
      case 2:
      // Handle the bookmark logic or other custom logic
        break;
    }

    if (targetChapter != null && !_isSavingProgress) {
      setState(() {
        _isSavingProgress = true;
      });

      try {
        await saveOrUpdateUserProgressWithUserId(targetChapter.storyId, targetChapter.chapterId);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChapterDetailPage(
              chapter: targetChapter!,
              chapters: widget.chapters, story: widget.story,
            ),
          ),
        );
      } catch (e) {
        print('Failed to save progress: $e');
      } finally {
        setState(() {
          _isSavingProgress = false;
        });
      }
    } else if (targetChapter == null) {
      print('No chapter available for navigation.');
    }
  }

  @override
  Widget build(BuildContext context) {

    int currentIndex = getCurrentChapterIndex();

    Color backButtonColor = currentIndex > 0 ? Colors.red : Colors.grey;
    Color forwardButtonColor = currentIndex < widget.chapters.length - 1 ? Colors.red : Colors.grey;

    var document = parse(widget.chapter.content);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: readpage,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetail(story: widget.story),
            ),
          ),
        ),
        title: Text(widget.chapter.title),
      ),
      body: Container(
        color: readpage,
        child: GestureDetector(
          onTap: _toggleBottomNavVisibility, // Toggle BottomNavigationBar on tap
          onPanUpdate: (details) {
            if (_isBottomNavVisible) {
              _toggleBottomNavVisibility(); // Hide BottomNavigationBar on scroll/pan
            }
          },
          child: Padding(
            padding: EdgeInsets.only(right: 10.0,left: 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Html(
                    data: widget.chapter.content,
                    style: {
                      "body": Style(
                        fontSize: FontSize(16.0),
                        textAlign: TextAlign.justify,
                      ),
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),


      bottomNavigationBar: _isBottomNavVisible
          ? BottomNavigationBar(
        backgroundColor: readpage,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.arrow_back_ios,
              color: backButtonColor, // Sử dụng biến màu đã tính toán trước
            ),
            label: 'Trước Đó',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: forwardButtonColor,
            ),
            label: 'Tiếp Theo',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              size: 30,
            ),
            label: 'Danh Sách Chương',
          ),
        ],
        onTap: (index) {
          if (index==0){
            _handleNavigation(index);
          } else if(index==1) {
            _handleNavigation(index);
          } else if(index==2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChapterPage(story: widget.story, )),
            );
          }
        },
      )
          : null,


    );
  }
}
