import 'package:flutter/material.dart';
import 'package:knovator_vinit/model/post.dart';
import 'package:knovator_vinit/utils/loading_spinner.dart';
import 'package:provider/provider.dart';

import '../provider/post_provider.dart';

class PostDetailScreen extends StatelessWidget {
  final int postId;

  const PostDetailScreen({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: FutureBuilder<Post>(
        future: _fetchPostDetail(context, postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingSpinner(); // Use the LoadingSpinner widget
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Post not found.'));
          }

          final post = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   post.title ?? 'No Title',
                //   style: Theme.of(context).textTheme.headlineSmall,
                // ),
                // 16.hGap,
                Text(
                  post.body ?? 'No Content',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Post> _fetchPostDetail(BuildContext context, int postId) async {

    print("_fetchPostDetail postid $postId");
    final postProvider = context.read<PostProvider>();
    return await postProvider.fetchPostDetail(postId);
  }
}
