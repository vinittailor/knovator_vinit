import 'dart:convert';
import 'package:knovator_vinit/model/post.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalStorage {
  static const String _postsKey = 'posts';

  // Save the list of posts to local storage
  static Future<void> savePosts(List<Post> posts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String postsJson = json.encode(posts.map((post) => post.toJson()).toList());
    await prefs.setString(_postsKey, postsJson);
  }

  // Retrieve the list of posts from local storage
  static Future<List<Post>?> getPosts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? postsJson = prefs.getString(_postsKey);

    if (postsJson == null) return null;

    final List<dynamic> postsList = json.decode(postsJson);
    return postsList.map((json) => Post.fromJson(json)).toList();
  }
}
