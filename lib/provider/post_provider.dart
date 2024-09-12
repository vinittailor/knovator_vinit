import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:knovator_vinit/model/post.dart';
import 'package:knovator_vinit/services/api_service.dart';
import 'package:knovator_vinit/services/local_storage_service.dart';
import 'package:knovator_vinit/utils/constants.dart';


class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  final Map<int, bool> _readStatus = {};
  final Map<int, Timer?> _timers = {};
  final Map<int, int> _remainingTime = {};
  bool _isLoading = true;
  bool _isDetailLoading = true;
  String? _errorPostListMessage;
  String? _errorPostDetailMessage;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isDetailLoading => _isDetailLoading;
  String? get errorPostListMessage => _errorPostListMessage;
  String? get errorPostDetailMessage => _errorPostDetailMessage;

  Future<void> fetchPosts() async {
    try {
      _isLoading = true;
      // notifyListeners();

      // // Fetch posts from local storage first
      // await _loadPostsFromLocalStorage();

      // Fetch posts from the API
      final List<Post> fetchedPosts = await ApiService.fetchPosts();
      _posts = fetchedPosts;

      // Mark unread posts and initialize timers
      _readStatus.clear();
      _remainingTime.clear();
      for (var post in _posts) {
        _readStatus[post.id!] = false;
        _remainingTime[post.id!] = _getRandomDuration();
      }

      // Save posts to local storage
      await LocalStorage.savePosts(_posts);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorPostListMessage = 'Failed to fetch posts: $e';
      notifyListeners();
    }
  }

  Future<void> _loadPostsFromLocalStorage() async {
    try {
      _posts = await LocalStorage.getPosts() ?? [];

      if(_posts.isNotEmpty){
        // Initialize read status and remaining time from local storage data
        for (var post in _posts) {
          _readStatus[post.id!] = _readStatus[post.id!] ?? false;
          _remainingTime[post.id!] = _remainingTime[post.id!] ?? _getRandomDuration();
        }
        _isLoading = false;
        notifyListeners();
      }


    } catch (e) {
      print('Failed to load posts from local storage: $e');
      _errorPostListMessage = 'Failed to load posts from local storage: $e';
      notifyListeners();
    }
  }

  Future<Post> fetchPostDetail(int postId) async {
    try {


      final Post post = await ApiService.fetchPostDetail(postId);


      notifyListeners();
      return post;
    } catch (e) {

      _errorPostDetailMessage = 'Failed to fetch post details: $e';

      notifyListeners();
      rethrow;
    }
  }


  void markAsRead(int? postId) {
    if (postId == null) return;

    _readStatus[postId] = true;
    notifyListeners();
  }

  bool isRead(int? postId) {
    if (postId == null) return false;
    return _readStatus[postId] ?? false;
  }

  void startTimer(int? postId) {
    if (postId == null) return;

    if (_timers[postId] != null) return; // Timer already running

    _timers[postId] = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime[postId] != null && _remainingTime[postId]! > 0) {
        _remainingTime[postId] = _remainingTime[postId]! - 1;
        notifyListeners();
      } else {
        _timers[postId]?.cancel();
        _timers[postId] = null;
        notifyListeners();
      }
    });
  }

  void stopTimer(int? postId) {
    if (postId == null) return;

    _timers[postId]?.cancel();
    _timers[postId] = null;
  }

  int getRemainingTime(int? postId) {
    if (postId == null) return 0;
    return _remainingTime[postId] ?? 0;
  }

  int _getRandomDuration() {
    // Returns a random duration (10, 20, or 25 seconds)
    List<int> durations = AppConstants.timerDurations;
    // durations.shuffle();
   int index = Random().nextInt(3);
    return durations[index];
  }


}
