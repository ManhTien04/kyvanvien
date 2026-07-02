import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:kyvanvien/theme/colors.dart';
import 'package:kyvanvien/view/story_detail.dart'; // Ensure this file is updated to use Story
import 'menu_page.dart';
import 'package:kyvanvien/models/stories.dart';

class StoriesList extends StatefulWidget {
  final int selectedStatusId;

  const StoriesList({Key? key, this.selectedStatusId = 0}) : super(key: key);


  @override
  _StoriesListState createState() => _StoriesListState();
}

class _StoriesListState extends State<StoriesList> {
  List<StoriesModel> stories = []; // Changed from products to _stories
  int selectedStatusId = 0;
  int selectedGenreId = 0;
  int selectedTypeId = 0;

  @override
  void initState() {
    super.initState();
    selectedStatusId = widget.selectedStatusId; // Gán giá trị từ widget vào state
    fetchStories(filters: {
      if (selectedStatusId > 0) 'statusId': selectedStatusId.toString(),
    });
    }

  Future<void> fetchStories({Map<String, String>? filters}) async {
    Uri uri;
    if (filters != null && filters.isNotEmpty) {
      uri = Uri.http('10.0.2.2:8080', '/api/v1/stories/filter1', filters);
    } else {
      uri = Uri.parse('http://10.0.2.2:8080/api/v1/stories');
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        stories = StoriesModel.fromJsonList(jsonResponse); // Changed to Story
      });
    } else {
      throw Exception('Failed to load stories from API'); // Updated error message
    }
  }

  //view

  Future<void> addView(int storyId) async {
    try {
      Uri uri = Uri.parse('http://10.0.2.2:8080/api/v1/views/add-view');
      final response = await http.post(uri, body: {'storyId': storyId.toString()});

      if (response.statusCode != 200) {
        throw Exception('Failed to add view for story. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      if (e is http.ClientException) {
        print('ClientException message: ${e.message}');
      }
    }
  }


  // @override
  // void initState() {
  //   super.initState();
  //   fetchStories(); // Load the initial list without filters
  // }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(

          builder: (context, setState) {
            return Container(
              color: Color(0xFFFFFFFF),
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRadioButtonGroup('Trạng Thái', [
                            {"id": 0, "name": "Tất Cả"},
                            {"id": 1, "name": "Đang Ra"},
                            {"id": 2, "name": "Tạm Dừng"},
                            {"id": 3, "name": "Đã Hoàn Thành"},
                          ], (value) => setState(() => selectedStatusId = value)),
                          _buildRadioButtonGroup('Thể Loại', [
                            {"id": 0, "name": "Tất Cả"},
                            {"id": 1, "name": "Tiên Hiệp"},
                            {"id": 2, "name": "Huyền Huyễn"},
                            {"id": 3, "name": "Khoa Huyễn"},
                            {"id": 4, "name": "Võng Du"},
                            {"id": 5, "name": "Đô Thị"},
                            {"id": 6, "name": "Kiếm Hiệp"},
                            {"id": 7, "name": "Đồng Nhân"},
                            {"id": 8, "name": "Lịch Sử"},
                            {"id": 9, "name": "Kì Huyễn"},
                            {"id": 10, "name": "Canh Kỹ"},
                            {"id": 11, "name": "Ngôn Tình"},
                            {"id": 12, "name": "Linh Dị"},
                          ], (value) => setState(() => selectedGenreId = value)),
                          _buildRadioButtonGroup('Kiểu Viết', [
                            {"id": 0, "name": "Tất Cả"},
                            {"id": 1, "name": "Chuyển Ngữ"},
                            {"id": 2, "name": "Sáng Tác"},
                          ], (value) => setState(() => selectedTypeId = value)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Map<String, String> filters = {};
                        if (selectedStatusId > 0) {
                          filters['statusId'] = selectedStatusId.toString();
                        }
                        if (selectedGenreId > 0) {
                          filters['genreId'] = selectedGenreId.toString();
                        }
                        if (selectedTypeId > 0) {
                          filters['typeId'] = selectedTypeId.toString();
                        }
                        fetchStories(filters: filters); // Changed to fetchStories
                        Navigator.pop(context); // Close the filter modal
                      },
                      child: Text(
                        'Lọc Truyện',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 13, // Text size
                          fontWeight: FontWeight.bold, // Text weight
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: titleColor, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Button corner radius
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Button padding
                        elevation: 5, // Button shadow
                        shadowColor: Colors.deepPurple.withOpacity(0.5), // Shadow color
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRadioButtonGroup(String title, List<Map<String, dynamic>> buttonList, Function(int) onSelected) {
    return Container(
      padding: EdgeInsets.all(10), // Padding around the entire container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10), // Adjust bottom padding here
              child: Text(title, style: TextStyle(fontSize: 20, color: titleColor)),
            ),
          ),
          Wrap(
            direction: Axis.horizontal, // Change direction to horizontal
            spacing: 5,
            runSpacing: 10, // Adjust runSpacing here
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start, // Add this line
            crossAxisAlignment: WrapCrossAlignment.start, // Add this line
            children: buttonList.map((item) {
              return IntrinsicWidth(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: title == 'Trạng Thái' ? 8.0 : 0.0, // Adjust right padding based on title
                      top: 2.0,
                      bottom: 2.0
                  ),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: ChoiceChip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide.none,
                      ),
                      backgroundColor: Colors.white,
                      selectedColor: titleColor,
                      showCheckmark: false,
                      label: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.5),
                        child: Text(item['name']),
                      ),
                      selected: item['id'] == (title == 'Trạng Thái'
                          ? selectedStatusId
                          : title == 'Thể Loại'
                          ? selectedGenreId
                          : selectedTypeId),
                      onSelected: (bool selected) {
                        onSelected(item['id']);
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: titleColor),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MenuPage()),
            );
          },
        ),
        title: Center(
          child: Text(
            'Danh Sách Truyện',
            style: TextStyle(
              color: titleColor,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_alt_outlined, color: titleColor),
            onPressed: _openFilterModal,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: stories.length, // Changed from products to _stories
              itemBuilder: (context, index) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 13.0, right: 13.0),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      color: primaryColor,
                      child: InkWell(
                        onTap: () {
                          addView(stories[index].id); // Updated to Story
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetail(story: stories[index]), // Updated to Story
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
                                  base64Decode(stories[index].storyImg.split(',').last),
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
                                      stories[index].title,
                                      style: TextStyle(
                                        color: textColor,
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(
                                      stories[index].author,
                                      style: TextStyle(
                                        color: extracolor,
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.menu_book,
                                          color: extracolor,
                                          size: 18.0, // Adjust the size as needed
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          "${stories[index].chapterCount}",
                                          style: TextStyle(
                                            color: textColor,
                                          ),
                                        ),
                                        SizedBox(width: 5.0),
                                        // if (stories[index].averageRating != 0.0)
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow[700],
                                              size: 18.0, // Adjust the size as needed
                                            ),
                                            SizedBox(width: 5.0),
                                            Text(
                                              stories[index].averageRating.toStringAsFixed(1),
                                              style: TextStyle(
                                                color: textColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
            ),
          ),
        ],
      ),
    );
  }
}
