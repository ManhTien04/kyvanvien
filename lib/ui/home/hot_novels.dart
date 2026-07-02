import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kyvanvien/theme/colors.dart';
import '../../components/story_banner.dart';
import '../../models/stories.dart';
import 'package:http/http.dart' as http;

class HotNovels extends StatefulWidget {
  const HotNovels({Key? key}) : super(key: key);

  @override
  _HotNovelsState createState() => _HotNovelsState();
}

class _HotNovelsState extends State<HotNovels> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  List<StoriesModel> storyMenu = [];

  @override
  void initState() {
    super.initState();
    fetchStories().then((stories) {
      setState(() {
        // Giới hạn số truyện được hiển thị là 6
        storyMenu = stories.length > 6 ? stories.sublist(0, 6) : stories;
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

        // Decode the author's name here
        String author = item['author'];
        String decodedAuthor = utf8.decode(author.runes.toList());

        // Replace the title and author in the item with the decoded versions
        item['title'] = decodedTitle;
        item['author'] = decodedAuthor;

        return StoriesModel.fromJson(item);
      }).toList();
    } else {
      throw Exception('Failed to load stories from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.9;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Truyện Đề Cử",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              height: 240,
              width: containerWidth,
              child: PageView.builder(
                controller: _pageController,
                itemCount: storyMenu.length,
                itemBuilder: (context, index) {
                  // Chuyển đổi chuỗi base64 thành dữ liệu nhị phân
                  String base64Image = storyMenu[index].storyImg.split(',').last;
                  Uint8List bytes = base64Decode(base64Image);

                  // Sử dụng MemoryImage để tải hình ảnh từ dữ liệu nhị phân
                  ImageProvider imageProvider = MemoryImage(bytes);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: StoryBanner(story: storyMenu[index], imageProvider: imageProvider),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}