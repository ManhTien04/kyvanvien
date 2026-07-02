import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:kyvanvien/models/stories.dart';
import 'package:kyvanvien/view/LoginRegister/TokenHandler.dart';
import 'package:kyvanvien/view/story_detail.dart';

import '../theme/colors.dart';

class BookCase extends StatefulWidget {
  @override
  _BookCaseState createState() => _BookCaseState();
}

class _BookCaseState extends State<BookCase> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<StoriesModel> readingHistory = []; // Replace with your Story model
  List<StoriesModel> bookmarks = []; // Replace with your Story model

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    fetchReadingHistory();
    fetchBookmarks();
  }



  Future<void> fetchReadingHistory() async {
    String? token = await getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final parts = token.split('.');
    final payload = B64urlEncRfc7515.decodeUtf8(parts[1]);
    final jwt = jsonDecode(payload);
    final userId = jwt['userId'];

    Uri uri = Uri.parse('http://10.0.2.2:8080/api/v1/reading-history/user/$userId');

    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<StoriesModel> stories = [];

      for (var item in jsonResponse) {
        Uri storyUri = Uri.parse('http://10.0.2.2:8080/api/v1/stories/${item['storyId']}');
        final storyResponse = await http.get(storyUri, headers: {
          'Authorization': 'Bearer $token',
        });

        if (storyResponse.statusCode == 200) {
          var storyJson = json.decode(utf8.decode(storyResponse.bodyBytes));
          StoriesModel story = StoriesModel.fromJson(storyJson);
          stories.add(story);
        } else {
          print('Failed to load story details for story ID ${item['storyId']}');
        }
      }

      setState(() {
        readingHistory = stories;
      });
    } else {
      throw Exception('Failed to load reading history from API');
    }
  }


  Future<void> fetchBookmarks() async {
    bookmarks = await fetchFollowedStories();
    setState(() {});
  }

  Future<List<StoriesModel>> fetchFollowedStories() async {
    List<StoriesModel> stories = [];
    String? token = await getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final parts = token.split('.');
    final payload = B64urlEncRfc7515.decodeUtf8(parts[1]);
    final jwt = jsonDecode(payload);
    final userId = jwt['userId'];

    Uri uri = Uri.parse('http://10.0.2.2:8080/api/v1/user-follows/user/$userId');

    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      for (var story in jsonResponse) {
        int? storyId = story['storyId'];

        if (storyId != null) {
          Uri storyUri = Uri.parse('http://10.0.2.2:8080/api/v1/stories/$storyId');
          try {
            final storyResponse = await http.get(storyUri);

            if (storyResponse.statusCode == 200) {
              var storyJson = json.decode(utf8.decode(storyResponse.bodyBytes));
              StoriesModel storyDetails = StoriesModel.fromJson(storyJson);
              stories.add(storyDetails);
            }
          } catch (e) {
            print('Failed to load story details for story ID $storyId: $e');
          }
        }
      }
    } else {
      throw Exception('Failed to load followed stories from API');
    }

    return stories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false, // This line removes the back button
        title: Text('Tủ Truyện', style: TextStyle(
          color: titleColor,
        ),),
        centerTitle: true, // This line centers the title
        bottom: TabBar(
          controller: _tabController,
          labelColor: titleColor,
          indicatorColor: titleColor,
          tabs: [
            Tab(text: 'Lịch Sử Đọc',),
            Tab(text: 'Đánh Dấu'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            buildReadingHistoryList(readingHistory),
            buildBookmarksList(bookmarks),
          ],
        ),
      ),
    );
  }
  Widget buildReadingHistoryList(List<StoriesModel> stories) {
    return ListView.builder(
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 13.0, right: 13.0),
            child: Container(
              padding: const EdgeInsets.only(bottom: 5.0),
              color: primaryColor,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(story: story),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.memory(
                          base64Decode(story.storyImg.split(',').last),
                          height: 100,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              story.title,
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              story.author,
                              style: TextStyle(
                                color: extracolor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget buildBookmarksList(List<StoriesModel> stories) {
    return ListView.builder(
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 13.0, right: 13.0),
            child: Container(
              padding: const EdgeInsets.only(bottom: 5.0),
              color: primaryColor,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(story: story),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.memory(
                          base64Decode(story.storyImg.split(',').last),
                          height: 100,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              story.title,
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              story.author,
                              style: TextStyle(
                                color: extracolor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}