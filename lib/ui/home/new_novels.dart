import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kyvanvien/theme/colors.dart';
import 'package:kyvanvien/view/StoriesList.dart';
import '../../components/story_tile2.dart';
import '../../models/stories.dart';
import '../../models/story.dart';
import 'package:http/http.dart' as http;

import '../../view/story_detail.dart';



class NewNovels extends StatefulWidget {
  const NewNovels({super.key});

  @override
  State<NewNovels> createState() => _NewNovelsState();
}

class _NewNovelsState extends State<NewNovels>{
  List<StoriesModel> storyMenu2 = [];
  StoriesModel? selectedStory;

  @override
  void initState() {
    super.initState();
    fetchStories().then((stories) {
      setState(() {
        storyMenu2 = stories.length > 10 ? stories.sublist(0, 10) : stories;
        selectedStory = stories[0];
      });
    });
  }

  Future<List<StoriesModel>> fetchStories() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/stories'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) {
        // Decode the title here
        String title = item['title'];
        String decodedTitle = utf8.decode(title.runes.toList());

        // Decode other fields here
        String author = item['author'];
        String decodedAuthor = utf8.decode(author.runes.toList());

        String description = item['description'];
        String decodeddescription = utf8.decode(description.runes.toList());

        String typeName = item['typeName'];
        String decodedtypeName = utf8.decode(typeName.runes.toList());

        String genreName = item['genreName'];
        String decodedgenreName = utf8.decode(genreName.runes.toList());



        // Replace the title and other fields in the item with the decoded versions
        item['title'] = decodedTitle;
        item['author'] = decodedAuthor;
        item['description'] = decodeddescription;
        item['typeName'] = decodedtypeName;
        item['genreName'] = decodedgenreName;

        // Continue this process for other fields that are displaying incorrectly

        return StoriesModel.fromJson(item);
      }).toList();
    } else {
      throw Exception('Failed to load stories from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Truyện Mới Nhất",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoriesList(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(
                        Icons.navigate_next,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: storyMenu2.length,
                itemBuilder: (context, index) => StoryTile2(
                  story: storyMenu2[index],
                  onTap: () {
                    setState(() {
                      selectedStory = storyMenu2[index];
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 5),
            if (selectedStory != null)
              _buildSelectedStoryCard(selectedStory!),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedStoryCard(StoriesModel story) {
    // Chuyển đổi chuỗi base64 thành dữ liệu nhị phân
    String base64Image = story.storyImg.split(',').last;
    Uint8List bytes = base64Decode(base64Image);

    // Sử dụng MemoryImage để tải hình ảnh từ dữ liệu nhị phân
    ImageProvider imageProvider = MemoryImage(bytes);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Hình ảnh của truyện
              Container(
                width: 120,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: imageProvider, // Sử dụng imageProvider ở đây
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 20.0),
              // Thông tin truyện
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title,
                      style: TextStyle(color: textColor, fontSize: 18),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Chương: ${story.chapterCount}",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: story.averageRating, // Đây là giá trị rating của bạn
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.yellow[700],
                          ),
                          itemCount: 5,
                          itemSize: 20.0, // Kích thước của mỗi ngôi sao
                          direction: Axis.horizontal,
                        ),
                        SizedBox(width: 10),
                        Text(
                          story.averageRating.toStringAsFixed(1),
                          style: TextStyle(color: textColor),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetail(story: story), // pass the story object here
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text('Đọc',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}