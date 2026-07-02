import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:kyvanvien/theme/colors.dart';
import 'package:kyvanvien/view/LoginRegister/TokenHandler.dart';
import 'package:kyvanvien/view/StoriesList.dart';
import '../models/stories.dart';
import 'ChapterDetailPage.dart';
import 'StatefulWidget.dart';// Import StoriesList
import 'ChapterPage.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductDetail extends StatelessWidget {
  final StoriesModel story;
  double? _rating;


  ProductDetail({required this.story});

  int? _userId;  // Biến private để lưu trữ userId

  int? get userId => _userId;  // Getter để truy cập userId

  set userId(int? id) {  // Setter để gán giá trị cho userId
    _userId = id;
  }
  //đánh giá truyện
  Future<void> _rateStory(double rating) async {
    print('userId: $userId'); // Print userId
    print('storyId: ${story.id}'); // Print storyId
    print('rating: $rating'); // Print rating

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/v1/ratings/rate'),
      body: {
        'userId': userId.toString(),
        'storyId': story.id.toString(),
        'ratingValue': rating.toString(),
      },
    );

    if (response.statusCode == 200) {
      print("Rating saved successfully");
    } else {
      print('Server response: ${response.body}'); // Print the server response
      throw Exception('Failed to save rating');
    }
  }
  // Future<double> fetchPreviousRating(int userId, int storyId) async {
  //   final response = await http.get(
  //     Uri.parse('http://10.0.2.2:8080/api/v1/ratings/previous'),
  //     headers: {
  //       'userId': userId.toString(),
  //       'storyId': storyId.toString(),
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
  //     double previousRating = jsonResponse['rating'];
  //     return previousRating;
  //   } else {
  //     throw Exception('Failed to load previous rating from API');
  //   }
  // }


  Future<StoriesModel> fetchStoryDetails() async {
    print('Story: $story'); // Print the story for debugging
    print('id: ${story.id}');
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/stories/${story.id}'));

    if (response.statusCode == 200) {
      return StoriesModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load story details from API');
    }
  }

  Future<int?> fetchHistory(int userId, int storyId) async {

    // Tạo URL với các tham số truyền vào
    final uri = Uri.parse('http://10.0.2.2:8080/api/v1/reading-history/by-story')
        .replace(queryParameters: {
      'userId': userId.toString(),
      'storyId': storyId.toString(),
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      int chapterId = jsonResponse['chapterId'];
      return chapterId;
    }  else if (response.statusCode == 204) {
      print('No content returned from API'); // Log for debugging
      return null; // Trả về null nếu API trả về 204
    } else {
      throw Exception('Failed to load chapter from API');
    }
  }

  Future<List<Chapter>> fetchChapters() async {
    print('Product: $story'); // Print the product for debugging
    print('id: ${story.id}');
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/chapters/story/${story.id}'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      print('Response from API: $jsonResponse'); // Print the response for debugging
      return jsonResponse.map((item) => Chapter.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load chapters from API');
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

  Future<void> loadUserId() async {
    try {
      String? token = await getToken();

      if (token == null) {
        print("Token is null");
        return;
      }

      final parts = token.split('.');

      if (parts.length != 3) {
        print("Invalid token structure");
        return;
      }

      // Giải mã phần payload từ base64
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));

      if (payload.isEmpty) {
        print("Failed to decode payload");
        return;
      }

      // Chuyển payload thành Map
      Map<String, dynamic> tokenData = json.decode(payload);

      if (tokenData.containsKey('userId')) {
        userId = tokenData['userId'];
        print("userId loaded successfully: $userId");
      } else {
        print("userId not found in token payload");
      }
    } catch (e) {
      print("Error in loadUserId: $e");
    }
  }


  void _showRatingModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 4,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              RatingBar.builder(
                initialRating: 5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40.0,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _rating = rating; // Store the rating value
                },
              ),

              SizedBox(height: 10.0),
              ElevatedButton(
                child: Text('Lưu đánh giá'),
                onPressed: () async {
                  await loadUserId(); // Load the userId
                  if (_rating != null && userId != null) {
                    _rateStory(_rating!); // Call the function to rate the story
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: titleColor),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StoriesList(),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.error_outline,color: titleColor,),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share,color: titleColor,),
            onPressed: () {},
          ),
        ],
      ),

      body: Container(
        color: primaryColor,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                story.title,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              _buildRow(Icons.person, story.author),
                              SizedBox(height: 8.0),
                              _buildRow(Icons.hourglass_empty,story.typeName),
                              SizedBox(height: 8.0),
                              _buildRow(Icons.menu_book_rounded, story.chapterCount.toString() + ' Chương'),
                              SizedBox(height: 8.0),
                              _buildRow(Icons.favorite, story.likeCount.toString()),
                              SizedBox(height: 8.0),
                              _buildRow(Icons.visibility, story.viewCount.toString()),
                              SizedBox(height: 8.0),
                              Text(
                                'Thể Loại: ${story.genreName}',
                                style: TextStyle(
                                  color: extracolor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  RatingBar.builder(
                                    initialRating: story.averageRating, // replace this with your story's rating
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    ignoreGestures: true, // Add this line
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                      "(" + story.ratingCount.toString()+")",
                                    style: TextStyle(color: textColor),
                                  ),
                                ],

                              ),
                              SizedBox(height: 8.0),
                              IconRow(storyId: story.id),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              width: 118,
                              height: 180,
                              child: Image.memory(
                                base64Decode(story.storyImg.split(',').last),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 8.0),
                              Text(
                                'Giới Thiệu:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Html(
                                data: story.description,
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
                      ],
                    ),
                    SizedBox(height: 90),
                  ],
                ),
              ),
            ),
            Stack(
              children: <Widget>[
                // Your other widgets go here
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Container(
                      color: primaryColor, // Set the color as per your requirement
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.star_half_sharp),
                              color: titleColor,
                              onPressed: () {
                                _showRatingModal(context);
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: titleColor, // Set the button color to #CB997E
                              ),
                              child: Text('Đọc Truyện',
                                style: TextStyle(
                                  color: Color(0xFFFFE8D6),
                                  fontFamily: 'Montserrat',// Set the text color to #FFFFFF
                                ),
                              ), // Button for reading
                              onPressed: () async {

                                loadUserId().then((_) {
                                  if (userId != null) {
                                    fetchHistory(userId!, story.id).then((chapterId) async {
                                      List<Chapter> chapters = await fetchChapters();

                                      Chapter selectedChapter;

                                      if (chapterId != null) {
                                        // Tìm chapter theo `chapterId` từ lịch sử đọc
                                        selectedChapter = chapters.firstWhere(
                                              (chapter) => chapter.chapterId == chapterId,
                                          orElse: () => chapters[0], // Nếu không tìm thấy, trả về chương đầu tiên
                                        );
                                      } else {
                                        print('No chapter found for the given userId and storyId. Loading first chapter.');
                                        selectedChapter = chapters[0];
                                      }

                                      await saveOrUpdateUserProgress(userId!, story.id, selectedChapter.chapterId);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChapterDetailPage(
                                            chapter: selectedChapter,
                                            chapters: chapters,
                                            story: story,
                                          ),
                                        ),
                                      );
                                    }).catchError((error) {
                                      // Xử lý lỗi khác
                                      print('Error: $error');
                                    });
                                  } else {
                                    print('Failed to load userId');
                                    // Xử lý khi không lấy được userId
                                  }
                                }).catchError((error) {
                                  print('Error loading userId: $error');
                                });


                              },
                            ),
                            // In ProductDetail.dart
                            IconButton(
                              icon: Icon(Icons.menu),color: titleColor, // Icon with three horizontal lines
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChapterPage(story: story, ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon,color: Color(0xFF21222b),),
        SizedBox(width: 4.0),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontFamily: 'Lobster',
              fontSize: 15.0,
            ),
          ),
        ),
      ],
    );
  }
}