import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kyvanvien/view/LoginRegister/TokenHandler.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:kyvanvien/view/comment_page.dart';
import 'package:kyvanvien/view/donate_page.dart';
import 'package:kyvanvien/ui/story_detail/donate.dart';

class IconRow extends StatefulWidget {
  final int storyId;

  IconRow({required this.storyId});

  @override
  _IconRowState createState() => _IconRowState();
}

class _IconRowState extends State<IconRow> {
  Color favoriteColor = Colors.grey;
  Color commentColor = Colors.grey;
  Color followColor = Colors.grey;
  Color giftColor = Colors.grey;
  bool isFollowed = false;
  int? userId;
  // Flow{
  @override
  void initState() {
    super.initState();
    _initializeUserId().then((_) {
      if (userId != null) {
        checkIfFollowing(userId!);
        checkIfLiked(userId!);
      }
    });
  }

  Future<void> _initializeUserId() async {
    String? token = await getToken();
    if (token != null) {
      try {
        final parts = token.split('.');
        if (parts.length != 3) {
          throw Exception('invalid token');
        }

        final payloadPart = parts[1];
        final payloadString = B64urlEncRfc7515.decodeUtf8(payloadPart);
        final payload = jsonDecode(payloadString) as Map<String, dynamic>;

        userId = payload['userId']; // extract userId from the payload
        setState(() {});
      } catch (e) {
        print('Failed to decode token: $e');
      }
    }
  }
  Future<void> checkIfFollowing(int userId) async {
    String? token = await getToken();
    if (token != null) {
      final response = await http.get(
        Uri.http('10.0.2.2:8080', '/api/v1/user-follows/one-follow', {
          'userId': userId.toString(),
          'storyId': widget.storyId.toString(),
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        isFollowed = result != null;
        followColor = isFollowed ? Colors.green : Colors.grey;
        setState(() {});
      } else if (response.statusCode == 204) {
        isFollowed = false;
        followColor = Colors.grey;
        setState(() {});
      } else {
        print('Error: ${response.body}');
        throw Exception('Failed to check following status: ${response.body}');
      }
    }
  }

  Future<void> followStory(int userId, [int? chapterId]) async {
    String? token = await getToken();
    if (token != null) {
      final response = await http.post(
        Uri.http('10.0.2.2:8080', '/api/v1/user-follows/follow', {
          'userId': userId.toString(),
          'storyId': widget.storyId.toString(),
          if (chapterId != null) 'chapterId': chapterId.toString(),
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Followed story ${widget.storyId}');
      } else {
        print('Error: ${response.body}');
        throw Exception('Failed to follow story: ${response.body}');
      }
    }
  }

  Future<void> unfollowStory(int userId, [int? chapterId]) async {
    String? token = await getToken();
    if (token != null) {
      final response = await http.post(
        Uri.http('10.0.2.2:8080', '/api/v1/user-follows/unfollow', {
          'userId': userId.toString(),
          'storyId': widget.storyId.toString(),
          if (chapterId != null) 'chapterId': chapterId.toString(),
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Unfollowed story ${widget.storyId}');
      } else {
        print('Error: ${response.body}');
        throw Exception('Failed to unfollow story: ${response.body}');
      }
    }
  }
// }Flow
//like{
  bool isLiked = false;
  Color likeColor = Colors.grey;

  Future<void> likeStory(int userId) async {
    String? token = await getToken();
    if (token != null) {
      final response = await http.post(
        Uri.http('10.0.2.2:8080', '/api/v1/user-likes/like', {
          'userId': userId.toString(),
          'storyId': widget.storyId.toString(),
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Liked story ${widget.storyId}');
      } else {
        print('Error: ${response.body}');
        throw Exception('Failed to like story: ${response.body}');
      }
    }
  }

  Future<void> unlikeStory(int userId) async {
    String? token = await getToken();
    if (token != null) {
      final response = await http.post(
        Uri.http('10.0.2.2:8080', '/api/v1/user-likes/unlike', {
          'userId': userId.toString(),
          'storyId': widget.storyId.toString(),
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        print('Unliked story ${widget.storyId}');
      } else {
        print('Error: ${response.body}');
        throw Exception('Failed to unlike story: ${response.body}');
      }
    }
  }

  Future<void> checkIfLiked(int userId) async {
    String? token = await getToken();
    if (token != null) {
      final response = await http.get(
        Uri.http('10.0.2.2:8080', '/api/v1/user-likes/check', {
          'userId': userId.toString(),
          'storyId': widget.storyId.toString(),
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        isLiked = result != null;
        likeColor = isLiked ? Colors.red : Colors.grey;
      } else if (response.statusCode == 204) {
        isLiked = false;
        likeColor = Colors.grey;
      } else {
        print('Error: ${response.body}');
        throw Exception('Failed to check like status: ${response.body}');
      }
      setState(() {});
    }
  }

// }like

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.favorite),
          color: likeColor,
          onPressed: () {
            if (userId != null) {
              setState(() {
                isLiked = !isLiked;
                likeColor = likeColor == Colors.grey ? Colors.red : Colors.grey;
              });
              if (isLiked) {
                likeStory(userId!);
              } else {
                unlikeStory(userId!);
              }
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.comment),
          color: commentColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommentPage(storyId: widget.storyId),
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(isFollowed ? Icons.bookmark_added : Icons.bookmark_add_outlined),
          color: followColor,
          onPressed: () {
            if (userId != null) {
              setState(() {
                isFollowed = !isFollowed;
                followColor = followColor == Colors.grey ? Colors.green : Colors.grey;
              });
              if (isFollowed) {
                followStory(userId!);
              } else {
                unfollowStory(userId!);
              }
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.card_giftcard),
          color: giftColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DonateDetail(storyId: widget.storyId),
              ),
            );
          },
        ),
      ],
    );
  }
}