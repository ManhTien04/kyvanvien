import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kyvanvien/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'package:kyvanvien/view/story_detail.dart';

import '../../components/story_tile.dart';
import '../../models/stories.dart';
import '../../view/StoriesList.dart';

class CompleteNovels extends StatefulWidget {
  const CompleteNovels({Key? key}) : super(key: key);

  @override
  State<CompleteNovels> createState() => _CompleteNovelsState();
}

class _CompleteNovelsState extends State<CompleteNovels> {
  Future<List<StoriesModel>> fetchStories() async {
    Uri uri = Uri.http('10.0.2.2:8080', '/api/v1/stories/filter', {
      'statusId': '3',
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<StoriesModel> stories = jsonResponse.map((item) => StoriesModel.fromJson(item)).toList();

      // Giới hạn số lượng truyện ở đây
      if (stories.length > 8) {
        stories = stories.sublist(0, 8);
      }

      return stories;
    } else {
      throw Exception('Failed to load stories from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Truyện Đã Hoàn Thành",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: 25,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoriesList(
                          selectedStatusId: 3, // Giá trị 3 đại diện cho "Đã Hoàn Thành"
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.navigate_next,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Container(
            height: 200,
            child: FutureBuilder<List<StoriesModel>>(
              future: fetchStories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load stories'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => StoryTile(
                      story: snapshot.data![index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetail(
                              story: snapshot.data![index],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(child: Text('No stories available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
