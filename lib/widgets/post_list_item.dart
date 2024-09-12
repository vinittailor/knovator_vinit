import 'package:flutter/material.dart';
import 'package:knovator_vinit/model/post.dart';
import 'package:knovator_vinit/provider/post_provider.dart';
import 'package:knovator_vinit/screens/post_detail_screen.dart';
import 'package:knovator_vinit/utils/constants.dart';
import 'package:knovator_vinit/utils/gaps.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostListItem extends StatelessWidget {
  final Post post;

  const PostListItem({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final isRead = postProvider.isRead(post.id);
    final remainingTime = postProvider.getRemainingTime(post.id);




    return VisibilityDetector(
      key: Key('post_${post.id}'),
      onVisibilityChanged: (info){

        if (info.visibleFraction > 0.2) {
          // The item is visible, resume the timer
          postProvider.startTimer(post.id);
        } else {
          // The item is not visible, stop the timer
          postProvider.stopTimer(post.id);
        }
      },
      child: GestureDetector(
        onTap: () {
          postProvider.markAsRead(post.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(postId: post.id!),
            ),
          );
        },
        child: Container(
          color: isRead ? AppConstants.white : AppConstants.lightYellow,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingHorizontal,
            vertical: AppConstants.paddingVertical,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: AppConstants.marginVertical,
            horizontal: AppConstants.paddingHorizontal,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  post.title ?? 'Untitled Post',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              10.wGap, // Horizontal gap
              TimerIcon(remainingTime: remainingTime),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerIcon extends StatelessWidget {
  final int remainingTime;

  const TimerIcon({
    Key? key,
    required this.remainingTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.timer, color: Colors.black),
        4.wGap, // Small horizontal gap between icon and text
        Text(
          '${remainingTime}s',
          style: const TextStyle(fontSize: 14.0, color: Colors.black),
        ),
      ],
    );
  }
}
