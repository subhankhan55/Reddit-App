// lib/features/post/controller/post_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/type_defs.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/post/repository/post_repository.dart';
import 'package:reddit_app/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
// REMOVED: import 'package:uuid/uuid.dart'; // NO external UUID package

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

  // --- BUSINESS LOGIC: CREATE POST ---
  void createPost({
    required BuildContext context,
    required String title,
    required String description,
  }) async {
    state = true; // Set loading state

    // 1. Get the current user data
    final user = _ref.read(userProvider)!; 
    
    // 2. SIMPLEST ID GENERATION: Ask the repository's collection for a new ID.
    // This uses the Firestore dependency which is already required.
    final postId = _postRepository.posts.doc().id; 

    // 3. Create the PostModel (Simplified)
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

    // 4. Save the post to Firestore via the Repository
    try {
      await _postRepository.addPost(post);
      // Success: Navigate back and show success message
      showSuccessSnackBar(context, 'Post created successfully!');
      Routemaster.of(context).pop();
    } catch (e) {
      // Failure: Show error message caught from the Repository
      showErrorSnackBar(context, e.toString());
    } finally {
      state = false; // Stop loading
    }
  }

  // --- DATA FETCHING: FEEDS ---

  Stream<List<PostModel>> fetchAllPosts() {
    return _postRepository.fetchAllPosts();
  }

  Stream<List<PostModel>> fetchUserPosts(String uid) {
    return _postRepository.fetchUserPosts(uid);
  }

  // --- UTILITIES ---

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