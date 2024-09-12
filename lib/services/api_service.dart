import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:knovator_vinit/model/post.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  // Fetch all posts
 static Future<List<Post>> fetchPosts() async {
    final Uri url = Uri.parse('$_baseUrl/posts');
    try {
      print("fetchPostDetail response url ${url}");
      final http.Response response = await http.get(url);
      print("fetchPostDetail response ${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print("fetchPostDetail response data ${data}");

        return data.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load posts. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load posts. Error: $error');
    }
  }

  // Fetch a specific post by ID
  static Future<Post> fetchPostDetail(int postId) async {
    final Uri url = Uri.parse('$_baseUrl/posts/$postId');
    try {
      final http.Response response = await http.get(url);

      print("fetchPostDetail response ${response.statusCode}");
      if (response.statusCode == 200) {
        print("fetchPostDetail response body ${json.decode(response.body)}");
        return Post.fromJson(json.decode(response.body));

      } else {
        throw Exception('Failed to load post details. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load post details. Error: $error');
    }
  }
}
