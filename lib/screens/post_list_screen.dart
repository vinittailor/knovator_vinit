import 'package:flutter/material.dart';
import 'package:knovator_vinit/provider/post_provider.dart';
import 'package:knovator_vinit/utils/loading_spinner.dart';
import 'package:knovator_vinit/widgets/post_list_item.dart';
import 'package:provider/provider.dart';


class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<PostProvider>().fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post List'),
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.isLoading) {
            return  const Center(child: LoadingSpinner());
          }

          if (postProvider.errorPostListMessage != null) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${postProvider.errorPostListMessage}'),

                  TextButton(onPressed: (){
                    postProvider.fetchPosts();
                  }, child: Text("Retry",style: Theme.of(context).textTheme.headlineSmall,))
                ],
              ),
            );
          }

          if (postProvider.posts.isEmpty) {
            return const Center(child: Text('No posts available'));
          }
          return ListView.builder(
            itemCount: postProvider.posts.length,
            itemBuilder: (context, index) {
              final post = postProvider.posts[index];
              return PostListItem(post: post);
            },
          );
        },
      ),
    );
  }
}
