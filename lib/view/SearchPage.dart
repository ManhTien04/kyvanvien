import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/stories.dart';
import '../theme/colors.dart';
import 'story_detail.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _controller;
  late Future<List<StoriesModel>> _searchResult;
  Timer? _debounce;
  late FocusNode _focusNode;
  // Timer for debouncing search input

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _searchResult = Future.value([]); // Initialize _searchResult with an empty list
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  Future<List<StoriesModel>> fetchStoryTitles(String query) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/stories/search?query=$query'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((item) => StoriesModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load stories from API');
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();  // Cancel previous timer if active

    // Start new debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        setState(() {
          _searchResult = fetchStoryTitles(query);
        });
      } else {
        setState(() {
          _searchResult = Future.value([]);  // Reset to empty list when query is cleared
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _focusNode.requestFocus());
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: titleColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,  // Use the FocusNode
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                fillColor: Colors.grey[200], // Màu nền xám nhẹ
                filled: true, // Đặt màu nền cho TextField
                hintText: 'Search', // Placeholder text
                hintStyle: TextStyle(color: Colors.grey), // Màu chữ placeholder
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0), // Bo góc
                  borderSide: BorderSide.none, // Không viền
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey), // Icon search thay vì chữ 'Search'
              ),
              onChanged: _onSearchChanged,  // Handle search input changes
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StoriesModel>>(
              future: _searchResult,
              builder: (BuildContext context, AsyncSnapshot<List<StoriesModel>> snapshot) {
                if (snapshot.hasData) {
                  List<StoriesModel> stories = snapshot.data!;
                  if (stories.isEmpty) {
                    return Center(child: Text('Tên Truyện Không Tồn Tại'));
                  }
                  return ListView.builder(
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      var base64Image = stories[index].storyImg.split(',').last; // Remove the data URI scheme
                      var imageBytes = base64Decode(base64Image); // Decode the base64 string to bytes
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0), // Add 3px space above and below each search result
                        child: ListTile(
                          leading: Container(
                            width: 50.0, // Specify the width
                            height: 100.0, // Specify the height
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.memory(imageBytes, fit: BoxFit.cover), // Display the story image
                            ),
                          ),
                          title: Text(stories[index].title, style: TextStyle(color: Colors.black54)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetail(story: stories[index]),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
