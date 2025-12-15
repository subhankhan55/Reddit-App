// lib/features/post/controller/post_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/type_defs.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/post/repository/post_repository.dart';
import 'package:reddit_app/models/post_model.dart';
import 'package:routemaster/routemaster.dart';

// 1. Provider to expose the list of posts by the current user
final userPostsProvider = StreamProvider.family((ref, String uid) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(uid);
});

// 2. StateNotifierProvider for the PostController (handles loading state)
final postControllerProvider = StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(PostRepositoryProvider);
  return PostController(
    postRepository: postRepository,
    ref: ref,
  );
});

// 3. Provider for the Global Feed
final guestPostsProvider = StreamProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchAllPosts();
});


class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;

  PostController({
    required PostRepository postRepository,
    required Ref ref,
  })  : _postRepository = postRepository,
        _ref = ref,
        super(false); // StateNotifier<bool> manages loading state

  // --- BUSINESS LOGIC: CREATE POST (Existing) ---
  void createPost({
    required BuildContext context,
    required String title,
    required String description,
  }) async {
    // ... (Existing implementation)
    state = true; 
    final user = _ref.read(userProvider)!; 
    final postId = _postRepository.posts.doc().id; 

    final PostModel post = PostModel(
      id: postId, 
      title: title,
      description: description,
      karma: 0,
      upvotes: [],
      downvotes: [],
      communityName: 'r/global', 
      communityIcon: '',
      type: 'text',
      authorUid: user.uid,
      createdAt: DateTime.now(),
    );

    try {
      await _postRepository.addPost(post);
      showSuccessSnackBar(context, 'Post created successfully!');
      Routemaster.of(context).pop();
    } catch (e) {
      showErrorSnackBar(context, e.toString());
    } finally {
      state = false; 
    }
  }
  
  // --- BUSINESS LOGIC: DELETE POST (Existing) ---
  void deletePost(BuildContext context, PostModel post) async {
    state = true; 
    try {
      await _postRepository.deletePost(post);
      showSuccessSnackBar(context, 'Post deleted successfully!');
    } catch (e) {
      showErrorSnackBar(context, e.toString());
    } finally {
      state = false; 
    }
  }

  // --- NEW METHOD: EDIT POST (UPDATE) ---
  void editPost({
    required BuildContext context,
    required PostModel post,
    required String newTitle,
    required String newDescription,
  }) async {
    state = true; 

    // Create a new PostModel instance with updated fields
    final updatedPost = post.copyWith(
      title: newTitle,
      description: newDescription,
    );

    try {
      await _postRepository.editPost(updatedPost);
      showSuccessSnackBar(context, 'Post updated successfully!');
    } catch (e) {
      showErrorSnackBar(context, e.toString());
    } finally {
      state = false; 
    }
  }


  // --- DATA FETCHING: FEEDS (Existing) ---
  Stream<List<PostModel>> fetchAllPosts() {
    return _postRepository.fetchAllPosts();
  }

  Stream<List<PostModel>> fetchUserPosts(String uid) {
    return _postRepository.fetchUserPosts(uid);
  }

  // --- UTILITIES (Existing) ---
  void showErrorSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text.replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
  }

  void showSuccessSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: Colors.green,
        ),
      );
  }
}